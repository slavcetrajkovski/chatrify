import 'package:chatrify/features/contact/domain/use_cases/add_contact_use_case.dart';
import 'package:chatrify/features/contact/domain/use_cases/fetch_contacts_use_case.dart';
import 'package:chatrify/features/contact/domain/use_cases/fetch_recent_contacts_use_case.dart';
import 'package:chatrify/features/contact/presentation/bloc/contact_event.dart';
import 'package:chatrify/features/contact/presentation/bloc/contact_state.dart';
import 'package:chatrify/features/conversation/domain/use_cases/check_or_create_conversation_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final FetchContactsUseCase fetchContactsUseCase;
  final AddContactUseCase addContactUseCase;
  final CheckOrCreateConversationUseCase checkOrCreateConversationUseCase;
  final FetchRecentContactsUseCase fetchRecentContactsUseCase;

  ContactBloc({
    required this.fetchContactsUseCase,
    required this.addContactUseCase,
    required this.checkOrCreateConversationUseCase,
    required this.fetchRecentContactsUseCase
  }) : super(ContactInitial()) {
    on<FetchContacts>(_onFetchContacts);
    on<AddContact>(_onAddContact);
    on<CheckOrCreateConversation>(_onCheckOrCreateConversation);
    on<LoadRecentContacts>(_onLoadRecentContactsEvent);

  }

  Future<void> _onLoadRecentContactsEvent(LoadRecentContacts event, Emitter<ContactState> emit) async {
    emit(ContactLoading());

    try {
      final recentContacts = await fetchRecentContactsUseCase();
      emit(RecentContactsLoaded(recentContacts));
    } catch(error) {
      emit(ContactError('Failed to load recent contacts'));
    }
  }

  Future<void> _onFetchContacts(FetchContacts event, Emitter<ContactState> emit) async {
    emit(ContactLoading());

    try {
      final contacts = await fetchContactsUseCase();
      emit(ContactLoaded(contacts));
    } catch(error) {
      emit(ContactError('Неуспешно додавање на контакт'));
    }
  }

  Future<void> _onAddContact(AddContact event, Emitter<ContactState> emit) async {
    emit(ContactLoading());

    try {
      await addContactUseCase(email: event.email);
      emit(ContactAdded());

      add(FetchContacts());
    } catch(error) {
      emit(ContactError('Неуспешно додавање на контакт'));
    }
  }

  Future<void> _onCheckOrCreateConversation(CheckOrCreateConversation event, Emitter<ContactState> emit) async {
    try {
      emit(ContactLoading());

      final conversationId = await checkOrCreateConversationUseCase(contactId: event.contactId);

      emit(ConversationReady(conversationId: conversationId, contactName: event.contactName));
    } catch(error) {
      emit(ContactError('Неуспешно започнување на конверзација'));
    }
  }
}