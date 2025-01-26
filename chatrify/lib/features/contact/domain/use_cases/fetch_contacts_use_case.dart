import 'package:chatrify/features/contact/domain/entity/contact_entity.dart';
import 'package:chatrify/features/contact/domain/repository/contact_repository.dart';

class FetchContactsUseCase {
  final ContactRepository contactRepository;

  FetchContactsUseCase({required this.contactRepository});

  Future<List<ContactEntity>> call() async {
    return await contactRepository.fetchContacts();
  }
}