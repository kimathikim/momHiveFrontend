import 'package:flutter/material.dart';
import 'new_conversation_page.dart';
import "message_detail.dart";

class MessagesPage extends StatelessWidget {
  final bool fromBottomNavBar;

  const MessagesPage({super.key, this.fromBottomNavBar = true});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFAF4),
      appBar: AppBar(
        title: const Text('Messages'),
        leading: fromBottomNavBar
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const <Widget>[
          MessageCard(
            sender: 'Linda Brown',
            lastMessage: 'Looking forward to our meeting.',
            time: '10:30 AM',
            isNew: true,
            imageUrl: 'https://dummyimage.com/100x100/000/fff&text=L',
          ),
          MessageCard(
            sender: 'Linda Brown',
            lastMessage: 'Looking forward to our meeting.',
            time: '10:30 AM',
            isNew: true,
            imageUrl: 'https://dummyimage.com/100x100/000/fff&text=L',
          ),
          MessageCard(
            sender: 'Mary Johnson',
            lastMessage: 'Thanks for the advice!',
            time: 'Yesterday',
            isNew: true,
            imageUrl: 'https://dummyimage.com/100x100/000/fff&text=M',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewConversationPage(),
            ),
          );
        },
        backgroundColor: const Color(0xFFF55200),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final String sender;
  final String lastMessage;
  final String time;
  final bool isNew;
  final String imageUrl;

  const MessageCard(
      {super.key,
      required this.sender,
      required this.lastMessage,
      required this.time,
      required this.isNew,
      required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white, // Add this line
        child: Tooltip(
            message: 'Tap to view message thread',
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
              title:
                  Text(sender, style: Theme.of(context).textTheme.titleLarge),
              subtitle: Text('$lastMessage\n$time',
                  style: const TextStyle(fontSize: 14.0)),
              trailing: isNew
                  ? const Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Icon(Icons.fiber_manual_record, color: Colors.green),
                        Text('3',
                            style: TextStyle(
                                color: Colors
                                    .white)), // replace '3' with the number of new messages
                      ],
                    )
                  : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MessageDetailPage(contactName: sender, senderID: '1')),
                );
              },
            )));
  }
}
