import 'package:chatrify/features/chat/domain/entity/daily_question_entity.dart';
import 'package:chatrify/features/chat/domain/repository/message_repository.dart';

class FetchDailyQuestionUseCase {
  final MessageRepository messageRepository;

  FetchDailyQuestionUseCase({required this.messageRepository});

  Future<DailyQuestionEntity> call(String conversationId) async {
    return await messageRepository.fetchDailyQuestion(conversationId);
  }
}