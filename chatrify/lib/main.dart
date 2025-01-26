import 'package:chatrify/core/socket_service.dart';
import 'package:chatrify/features/chat/data/data_sources/message_remote_data_source.dart';
import 'package:chatrify/features/chat/data/repository/message_repository_impl.dart';
import 'package:chatrify/features/chat/domain/use_cases/fetch_daily_question_use_case.dart';
import 'package:chatrify/features/chat/domain/use_cases/fetch_message_use_case.dart';
import 'package:chatrify/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:chatrify/features/chat/presentation/page/chat_page.dart';
import 'package:chatrify/core/theme.dart';
import 'package:chatrify/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:chatrify/features/auth/domain/use_cases/login_use_case.dart';
import 'package:chatrify/features/auth/domain/use_cases/register_use_case.dart';
import 'package:chatrify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chatrify/features/auth/presentation/page/login_page.dart';
import 'package:chatrify/features/auth/presentation/page/register_page.dart';
import 'package:chatrify/features/contact/data/data_sources/contacts_remote_data_source.dart';
import 'package:chatrify/features/contact/data/repository/contact_repository_impl.dart';
import 'package:chatrify/features/contact/domain/use_cases/add_contact_use_case.dart';
import 'package:chatrify/features/contact/domain/use_cases/fetch_contacts_use_case.dart';
import 'package:chatrify/features/contact/domain/use_cases/fetch_recent_contacts_use_case.dart';
import 'package:chatrify/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:chatrify/features/conversation/data/data_source/conversation_remote_data_source.dart';
import 'package:chatrify/features/conversation/data/repository/conversation_repository_impl.dart';
import 'package:chatrify/features/conversation/domain/use_cases/check_or_create_conversation_use_case.dart';
import 'package:chatrify/features/conversation/domain/use_cases/fetch_conversations_use_case.dart';
import 'package:chatrify/features/conversation/presentation/bloc/conversation_bloc.dart';
import 'package:chatrify/features/conversation/presentation/page/conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/data/repository/auth_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final socketService = SocketService();
  await socketService.initSocket();

  final authRepository = AuthRepositoryImpl(authRemoteDataSource: AuthRemoteDataSource());
  final conversationRepository = ConversationRepositoryImpl(conversationRemoteDataSource: ConversationRemoteDataSource());
  final messageRepository = MessageRepositoryImpl(remoteDataSource: MessageRemoteDataSource());
  final contactRepository = ContactRepositoryImpl(contactsRemoteDataSource: ContactsRemoteDataSource());

  runApp(MyApp(
    authRepository: authRepository,
    conversationRepository: conversationRepository,
    messageRepository: messageRepository,
    contactRepository: contactRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final ConversationRepositoryImpl conversationRepository;
  final MessageRepositoryImpl messageRepository;
  final ContactRepositoryImpl contactRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.conversationRepository,
    required this.messageRepository,
    required this.contactRepository
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthBloc(
                registerUseCase: RegisterUseCase(repository: authRepository),
                loginUseCase: LoginUseCase(repository: authRepository)
            )
        ),

        BlocProvider(
            create: (_) => ConversationBloc(
              fetchConversationsUseCase: FetchConversationsUseCase(conversationRepository)
            )
        ),

        BlocProvider(
            create: (_) => ChatBloc(
                fetchMessageUseCase: FetchMessageUseCase(messageRepository: messageRepository),
                fetchDailyQuestionUseCase: FetchDailyQuestionUseCase(messageRepository: messageRepository),
            )
        ),

        BlocProvider(
            create: (_) => ContactBloc(
                fetchContactsUseCase: FetchContactsUseCase(contactRepository: contactRepository),
                addContactUseCase: AddContactUseCase(contactRepository: contactRepository),
                checkOrCreateConversationUseCase: CheckOrCreateConversationUseCase(conversationRepository: conversationRepository),
                fetchRecentContactsUseCase: FetchRecentContactsUseCase(contactRepository: contactRepository)
            )
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          home: LoginPage(),
          routes: {
            '/login': (_) => LoginPage(),
            '/register': (_) => RegisterPage(),
            '/conversationPage': (_) => ConversationPage(),
          }
      ),
    );
  }
}
