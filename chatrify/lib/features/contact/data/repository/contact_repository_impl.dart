import 'package:chatrify/features/contact/data/data_sources/contacts_remote_data_source.dart';
import 'package:chatrify/features/contact/domain/entity/contact_entity.dart';
import 'package:chatrify/features/contact/domain/repository/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactsRemoteDataSource contactsRemoteDataSource;

  ContactRepositoryImpl({required this.contactsRemoteDataSource});

  @override
  Future<void> addContact({required String email}) async {
    await contactsRemoteDataSource.addContact(email: email);
  }

  @override
  Future<List<ContactEntity>> fetchContacts() async {
    return await contactsRemoteDataSource.fetchContacts();
  }

  @override
  Future<List<ContactEntity>> getRecentContacts() async {
    return await contactsRemoteDataSource.fetchRecentContacts();
  }

}