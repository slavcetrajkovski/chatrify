import 'package:chatrify/features/chat/data/data_sources/message_remote_data_source.dart';
import 'package:chatrify/features/chat/domain/entity/daily_question_entity.dart';
import 'package:chatrify/features/chat/domain/entity/message_entity.dart';
import 'package:chatrify/features/chat/domain/repository/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {

  final MessageRemoteDataSource remoteDataSource;

  MessageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MessageEntity>> fetchMessages(String conversationId) async {
    return await remoteDataSource.fetchMessages(conversationId);
  }

  @override
  Future<void> sendMessage(MessageEntity message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Future<DailyQuestionEntity> fetchDailyQuestion(String conversationId) async {
    return await remoteDataSource.fetchDailyQuestion(conversationId);
  }

}