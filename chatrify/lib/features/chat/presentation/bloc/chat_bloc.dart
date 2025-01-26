import 'package:chatrify/features/chat/domain/entity/message_entity.dart';
import 'package:chatrify/features/chat/domain/use_cases/fetch_daily_question_use_case.dart';
import 'package:chatrify/features/chat/domain/use_cases/fetch_message_use_case.dart';
import 'package:chatrify/features/chat/presentation/bloc/chat_event.dart';
import 'package:chatrify/features/chat/presentation/bloc/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/socket_service.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FetchMessageUseCase fetchMessageUseCase;
  final FetchDailyQuestionUseCase fetchDailyQuestionUseCase;
  final SocketService _socketService = SocketService();
  final List<MessageEntity> _messages = [];
  final _storage = FlutterSecureStorage();

  ChatBloc({required this.fetchMessageUseCase, required this.fetchDailyQuestionUseCase}): super(ChatLoadingState()) {
    on<LoadMessageEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<ReceiveMessageEvent>(_onReceiveMessage);
    on<LoadDailyQuestionEvent>(_onLoadDailyQuestionEvent);
  }

  Future<void> _onLoadMessages(LoadMessageEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());

    try {
      final messages = await fetchMessageUseCase(event.conversationId);
      _messages.clear();
      _messages.addAll(messages);
      emit(ChatLoadedState(List.from(_messages)));

      _socketService.socket.off('newMessage');

      _socketService.socket.emit('joinConversation', event.conversationId);
      _socketService.socket.on('newMessage', (data) {
        print('step 1 - receive: $data');
        add(ReceiveMessageEvent(data));
      });
    } catch(error) {
      emit(ChatErrorState('Failed to load messages'));
    }
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    String userId = await _storage.read(key: 'userId') ?? '';
    print('userId: $userId');

    final newMessage = {
      'conversationId': event.conversationId,
      'content': event.content,
      'senderId': userId
    };

    _socketService.socket.emit('sendMessage', newMessage);
  }

  Future<void> _onReceiveMessage(ReceiveMessageEvent event, Emitter<ChatState> emit) async {
    print('step 2 - receive event called');
    print(event.message);

    final message = MessageEntity(
        id: event.message['id'],
        conversationId: event.message['conversation_id'],
        senderId: event.message['sender_id'],
        content: event.message['content'],
        createdAt: event.message['created_at']
    );

    _messages.add(message);
    emit(ChatLoadedState(List.from(_messages)));
  }
  
  Future<void> _onLoadDailyQuestionEvent(LoadDailyQuestionEvent event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoadingState());

      final dailyQuestion = await fetchDailyQuestionUseCase(event.conversationId);

      emit(DailyQuestionLoadedState(dailyQuestion));
    } catch(error) {
      emit(ChatErrorState('Неуспешно генерирање на порака'));
    }
  }
}