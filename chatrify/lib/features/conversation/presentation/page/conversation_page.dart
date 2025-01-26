import 'package:chatrify/core/theme.dart';
import 'package:chatrify/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:chatrify/features/contact/presentation/bloc/contact_event.dart';
import 'package:chatrify/features/contact/presentation/bloc/contact_state.dart';
import 'package:chatrify/features/contact/presentation/page/contact_page.dart';
import 'package:chatrify/features/conversation/presentation/bloc/conversation_bloc.dart';
import 'package:chatrify/features/conversation/presentation/bloc/conversation_event.dart';
import 'package:chatrify/features/conversation/presentation/bloc/conversation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../chat/presentation/page/chat_page.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ConversationBloc>(context).add(FetchConversations());
    BlocProvider.of<ContactBloc>(context).add(LoadRecentContacts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text('Пораки', style: Theme.of(context).textTheme.titleLarge),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 70,
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))]),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Последни',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),

          BlocBuilder<ContactBloc, ContactState>(
            builder: (context, state) {
              if(state is RecentContactsLoaded) {
                return Container(
                  height: 100,
                  padding: EdgeInsets.all(5),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.recentContacts.length,
                      itemBuilder: (context, index) {
                        final contact = state.recentContacts[index];
                        return _buildRecentContact(contact.username, context);
                      }
                  ),
                );
              } else if(state is ConversationLoading) {
                return Center(child: CircularProgressIndicator(),);
              }

              return Center(child: Text('Нема пораки'),);
            },
          ),

          SizedBox(height: 10,),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: DefaultColors.messageListPage,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50)
                )
              ),

              child: BlocBuilder<ConversationBloc, ConversationState>(
                builder: (context, state) {
                  if(state is ConversationLoading) {
                    return Center(child: CircularProgressIndicator(),);
                  } else if(state is ConversationLoaded) {
                    return ListView.builder(
                      itemCount: state.conversations.length,
                      itemBuilder: (context, index) {
                          final conversation = state.conversations[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                ChatPage(conversationId: conversation.id, mate: conversation.participantName)
                              ));
                            },
                            child: _buildMessageTile(
                                conversation.participantName,
                                conversation.lastMessage,
                                conversation.lastMessageTime.toString()),
                          );
                        }
                    );
                  } else if(state is ConversationError) {
                    return Center(child: Text(state.message),);
                  }

                  return Center(child: Text('Нема пораки'),);
                },
              )
            )
          )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var res = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactPage())
            );

            if(res == null) {
              BlocProvider.of<ContactBloc>(context).add(LoadRecentContacts());
            }
          },
          backgroundColor: DefaultColors.buttonColor,
          child: Icon(Icons.contacts)
        )
    );
  }

  Widget _buildMessageTile(String name, String message, String time) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          radius: 30,
        ),
        title: Text(name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(
          message,
          style: TextStyle(color: Colors.grey),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(time, style: TextStyle(color: Colors.grey)));
  }

  Widget _buildRecentContact(String name, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          CircleAvatar(
            radius: 30,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ]));
  }
}
