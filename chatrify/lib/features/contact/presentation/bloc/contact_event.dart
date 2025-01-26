abstract class ContactEvent {}

class FetchContacts extends ContactEvent {}

class CheckOrCreateConversation extends ContactEvent {
  final String contactId;
  final String contactName;

  CheckOrCreateConversation(this.contactId, this.contactName);
}

class AddContact extends ContactEvent {
  final String email;

  AddContact(this.email);
}

class LoadRecentContacts extends ContactEvent {}