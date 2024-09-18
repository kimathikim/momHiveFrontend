import 'package:flutter/material.dart';

class MessageDetailPage extends StatelessWidget {
  final String contactName;

  const MessageDetailPage({super.key, required this.contactName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: const AssetImage(
                  'assets/avatar_placeholder.png'), // Use actual contact's avatar here
            ),
            const SizedBox(width: 10),
            Text(
              contactName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.yellow[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Implement more options here
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount:
                  10, // This should be the number of messages in the conversation
              itemBuilder: (context, index) {
                // Replace this with the actual message data and logic to alternate between sender and receiver
                bool isSentByUser = index % 2 == 0;

                return Align(
                  alignment: isSentByUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSentByUser ? Colors.yellow[100] : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const Text(
                      'This is a messagejijijijijijijijijijijijijijijijijfffffffffffffffffffffffffffffffffffffffffffffffffffff jiji jijij ji j ji',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.emoji_emotions_outlined,
                      color: Colors.grey[600]),
                  onPressed: () {
                    // Open emoji keyboard
                  },
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.grey[600]),
                  onPressed: () {
                    // Implement file attachment functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.grey[600]),
                  onPressed: () {
                    // Implement camera functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.yellow[700]),
                  onPressed: () {
                    // Implement sending message functionality
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
