import 'package:chatrify/features/conversation/data/data_source/conversation_remote_data_source.dart';
import 'package:chatrify/features/conversation/domain/entity/conversation_entity.dart';
import 'package:chatrify/features/conversation/domain/repository/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSource conversationRemoteDataSource;

  ConversationRepositoryImpl({required this.conversationRemoteDataSource});

  @override
  Future<List<ConversationEntity>> fetchConversations() async {
    return await conversationRemoteDataSource.fetchConversations();
  }

  @override
  Future<String> checkOrCreateConversation({required String contactId}) async {
    return await conversationRemoteDataSource.checkOrCreateConversation(contactId: contactId);
  }
}
