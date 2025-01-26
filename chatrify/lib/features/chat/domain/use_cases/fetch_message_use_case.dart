import 'package:chatrify/features/chat/domain/repository/message_repository.dart';

import '../entity/message_entity.dart';

class FetchMessageUseCase {
  final MessageRepository messageRepository;

  FetchMessageUseCase({required this.messageRepository});

  Future<List<MessageEntity>> call(String conversationId) async {
    return await messageRepository.fetchMessages(conversationId);
  }
}