import 'package:chatrify/features/chat/presentation/page/chat_page.dart';
import 'package:chatrify/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:chatrify/features/contact/presentation/bloc/contact_event.dart';
import 'package:chatrify/features/contact/presentation/bloc/contact_state.dart';
import 'package:chatrify/features/conversation/presentation/bloc/conversation_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ContactBloc>(context).add(FetchContacts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Контакти', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.transparent,
      ),
      body: BlocListener<ContactBloc, ContactState>(
        listener: (context, state) {
          final contactsBloc = BlocProvider.of<ContactBloc>(context);

          if(state is ConversationReady) {
            var res = Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  ChatPage(
                    conversationId: state.conversationId,
                    mate: state.contactName
                  )
              )
            );

            if(res != null) {
              contactsBloc.add(FetchContacts());
            }
          }
        },
        child: BlocBuilder<ContactBloc, ContactState>(
          builder: (context, state){
            if(state is ContactLoading) {
              return Center(child: CircularProgressIndicator(),);
            } else if(state is ContactLoaded) {
              return ListView.builder(
                itemCount: state.contacts.length,
                itemBuilder: (context, index) {
                  final contact = state.contacts[index];
                  return ListTile(
                    title: Text(contact.username, style: TextStyle(color: Colors.white)),
                    subtitle: Text(contact.email, style: TextStyle(color: Colors.white)),
                    onTap: (){
                      BlocProvider.of<ContactBloc>(context).add(
                          CheckOrCreateConversation(contact.id, contact.username)
                      );
                    },
                  );
                },
              );
            } else if (state is ContactError) {
              return Center(child: Text(state.message),);
            }

            return Center(child: Text('Нема контакти'),);
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddContactDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text('Додади контакт', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(
                hintText: 'Внеси емаил на контактот',
                hintStyle: TextStyle(color: Colors.white)
            )
          ),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Откажи')
            ),
            ElevatedButton(
              onPressed: (){
                final email = emailController.text.trim();
                if(email.isNotEmpty) {
                  BlocProvider.of<ContactBloc>(context).add(AddContact(email));
                  Navigator.pop(context);
                }
              },
              child: Text(
                  'Додади'
              )
            )
          ]
        )
    );
  }
}
