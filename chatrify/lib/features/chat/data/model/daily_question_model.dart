import 'package:chatrify/features/chat/domain/entity/daily_question_entity.dart';

class DailyQuestionModel extends DailyQuestionEntity {

  DailyQuestionModel({required String content}): super(content: content);

  factory DailyQuestionModel.fromJson(Map<String, dynamic> json) {
    return DailyQuestionModel(content: json['question'] ?? 'No question available');
  }

}