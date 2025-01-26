import 'dart:convert';

import 'package:chatrify/features/contact/data/model/contact_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ContactsRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:6000';
  final _storage = FlutterSecureStorage();

  Future<List<ContactModel>> fetchContacts() async {
    String token = await _storage.read(key: 'token') ?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/contacts'),
      headers:{'Authorization': 'Bearer $token'}
    );

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ContactModel.fromJson(json)).toList();
    } else {
      throw Exception('Неуспешно додавање на контакт');
    }
  }

  Future<void> addContact({required String email}) async {
    String token = await _storage.read(key: 'token') ?? '';

    final response = await http.post(
        Uri.parse('$baseUrl/contacts'),
        body: jsonEncode({'contactEmail': email}),
        headers:{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    if(response.statusCode != 201) {
      throw Exception('Failed to add contact');
    }
  }

  Future<List<ContactModel>> fetchRecentContacts() async {
    String token = await _storage.read(key: 'token') ?? '';

    final response = await http.get(
        Uri.parse('$baseUrl/contacts/recent'),
        headers:{'Authorization': 'Bearer $token'}
    );

    if(response.statusCode == 201) {
      List data = jsonDecode(response.body);
      return data.map((json) => ContactModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch recent contacts');
    }
  }
}