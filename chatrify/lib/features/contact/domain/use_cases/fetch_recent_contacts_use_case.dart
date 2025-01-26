import 'package:chatrify/features/contact/domain/entity/contact_entity.dart';
import 'package:chatrify/features/contact/domain/repository/contact_repository.dart';

class FetchRecentContactsUseCase {
  final ContactRepository contactRepository;

  FetchRecentContactsUseCase({required this.contactRepository});

  Future<List<ContactEntity>> call() async {
    return await contactRepository.getRecentContacts();
  }
}