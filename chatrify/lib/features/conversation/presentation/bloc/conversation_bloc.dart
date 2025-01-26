import 'package:chatrify/core/socket_service.dart';
import 'package:chatrify/features/conversation/domain/use_cases/fetch_conversations_use_case.dart';
import 'package:chatrify/features/conversation/presentation/bloc/conversation_event.dart';
import 'package:chatrify/features/conversation/presentation/bloc/conversation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final FetchConversationsUseCase fetchConversationsUseCase;
  final SocketService _socketService = SocketService();

  ConversationBloc({required this.fetchConversationsUseCase}) : super(ConversationInitial()) {
    on<FetchConversations>(_onFetchConversations);
    _initializeSocketListeners();
  }

  void _initializeSocketListeners() {
    try {
      _socketService.socket.on('conversationUpdated', _onConversationUpdate);
    } catch(e) {
      print('Error initializing socket listeners: $e');
    }
  }

  Future<void> _onFetchConversations(FetchConversations event, Emitter<ConversationState> emit) async {
    emit(ConversationLoading());

    try {
      final conversations = await fetchConversationsUseCase();
      emit(ConversationLoaded(conversations));
    } catch(error) {
      emit(ConversationError('Failed to load conversations'));
    }
  }

  void _onConversationUpdate(data) {
    add(FetchConversations());
  }
}
