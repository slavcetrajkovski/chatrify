import 'package:chatrify/features/contact/domain/entity/contact_entity.dart';

abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<ContactEntity> contacts;

  ContactLoaded(this.contacts);
}

class ContactError extends ContactState {
  final String message;

  ContactError(this.message);
}

class ContactAdded extends ContactState {}

class ConversationReady extends ContactState {
  final String conversationId;
  final String contactName;

  ConversationReady({required this.conversationId, required this.contactName});
}

class RecentContactsLoaded extends ContactState {
  final List<ContactEntity> recentContacts;

  RecentContactsLoaded(this.recentContacts);
}