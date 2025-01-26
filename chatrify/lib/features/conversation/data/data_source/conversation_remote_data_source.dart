import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../model/conversation_model.dart';

class ConversationRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:6000';
  final _storage = FlutterSecureStorage();

  Future<List<ConversationModel>> fetchConversations() async {
    String token = await _storage.read(key: 'token') ?? '';

    final response =
        await http.get(Uri.parse('$baseUrl/conversations'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ConversationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch conversations');
    }
  }

  Future<String> checkOrCreateConversation({required String contactId}) async {
    String token = await _storage.read(key: 'token') ?? '';

    final response =
      await http.post(
          Uri.parse('$baseUrl/conversations/check-or-create'),
          body: jsonEncode({'contactId': contactId}),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['conversationId'];
    } else {
      throw Exception('Failed to check or create conversation');
    }
  }
}
