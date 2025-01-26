import '../entity/contact_entity.dart';

abstract class ContactRepository {

  Future<List<ContactEntity>> fetchContacts();

  Future<void> addContact({required String email});

  Future<List<ContactEntity>> getRecentContacts();
}