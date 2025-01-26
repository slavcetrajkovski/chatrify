import 'package:chatrify/features/conversation/domain/entity/conversation_entity.dart';
import 'package:chatrify/features/conversation/domain/repository/conversation_repository.dart';

class FetchConversationsUseCase {
  final ConversationRepository repository;

  FetchConversationsUseCase(this.repository);

  Future<List<ConversationEntity>> call() async {
    return repository.fetchConversations();
  }
}
