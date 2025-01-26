import 'dart:convert';

import 'package:chatrify/features/chat/data/model/daily_question_model.dart';
import 'package:chatrify/features/chat/domain/entity/message_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../model/message_model.dart';

class MessageRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:6000';
  final _storage = FlutterSecureStorage();

  Future<List<MessageEntity>> fetchMessages(String conversationId) async {
    String token = await _storage.read(key: 'token') ?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/messages/$conversationId'),
      headers: {'Authorization': 'Bearer $token'}
    );

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch messages');
    }
  }

  Future<DailyQuestionModel> fetchDailyQuestion(String conversationId) async {
    String token = await _storage.read(key: 'token') ?? '';

    final response = await http.get(
        Uri.parse('$baseUrl/conversations/$conversationId/daily-question'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    if(response.statusCode == 200) {
      return DailyQuestionModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Неуспешно генерирање на прашање');
    }
  }
}