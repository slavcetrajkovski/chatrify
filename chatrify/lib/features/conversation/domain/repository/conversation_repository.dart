import 'package:chatrify/features/conversation/domain/entity/conversation_entity.dart';

abstract class ConversationRepository {
  Future<List<ConversationEntity>> fetchConversations();

  Future<String> checkOrCreateConversation({required String contactId});
}
