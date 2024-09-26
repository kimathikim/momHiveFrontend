<<<<<<< HEAD
import 'package:flutter/material.dart';

class MessageDetailPage extends StatelessWidget {
  final String contactName;

  const MessageDetailPage({super.key, required this.contactName});

  @override
=======
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MessageDetailPage extends StatefulWidget {
  final String contactName;
  final String userId;
  final bool isGroup;

  const MessageDetailPage({
    Key? key,
    required this.contactName,
    required this.userId,
    this.isGroup = false,
  }) : super(key: key);

  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final storage = const FlutterSecureStorage();
  IO.Socket? socket;
  bool _isConnected = false;
  String? _token;
  String? _roomId;

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
  }

  Future<void> _initializeWebSocket() async {
    _token = await storage.read(key: 'auth_token');
    if (_token == null) {
      return;
    }

    socket = IO.io(
      'https://momhive-992deeb4847a.herokuapp.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $_token'})
          .build(),
    );

    socket!.on('connect', (_) {
      print('Connected');
      setState(() {
        _isConnected = true;
      });
      _joinRoom();
    });

    socket!.on('disconnect', (_) {
      setState(() {
        _isConnected = false;
      });
    });
    socket!.on('receive_private_message', (data) {
      final messageData =
          data is Map<String, dynamic> ? data : jsonDecode(data);

      setState(() {
        _messages.add({
          'userId': messageData['sender_id'],
          'message': messageData['content'],
          'timestamp': messageData['timestamp'],
          'sentByUser': messageData['sender_id'] == widget.userId,
        });
      });
    });

    socket!.on('receive_group_message', (data) {
      final Map<String, dynamic> messageData = data as Map<String, dynamic>;
      setState(() {
        _messages.add({
          'userId': messageData['sender_id'],
          'message': messageData['content'],
          'timestamp': messageData['timestamp'],
          'sentByUser': messageData['sender_id'] == widget.userId,
        });
      });
    });

    socket!.connect();
  }

  void _joinRoom() {
    if (widget.isGroup) {
      _joinGroupRoom();
    } else {
      _joinPrivateRoom();
    }
  }

  void _joinPrivateRoom() {
    final receiverId = _roomId ?? widget.userId;
    socket!.emit('join_private_room', {
      'token': _token,
      'receiver_id': receiverId,
    });
  }

  void _joinGroupRoom() {
    final groupId = _roomId ?? widget.userId;
    socket!.emit('join_group_room', {
      'token': _token,
      'group_id': groupId,
    });
  }

  void _sendMessage(String message) {
    if (_isConnected && message.isNotEmpty) {
      if (widget.isGroup) {
        _sendGroupMessage(message);
      } else {
        _sendPrivateMessage(message);
      }
    } else {
      _sendMessageViaApi(message);
    }

    // setState(() {
    //   _messages.add({
    //     'userId': widget.userId,
    //     'message': message,
    //     'sentByUser': true,
    //     'timestamp': DateTime.now().toIso8601String(),
    //   });
    // });
    //
    _messageController.clear();
  }

  void _sendPrivateMessage(String message) {
    socket!.emit('send_private_message', {
      'token': _token,
      'receiver_id': widget.userId,
      'content': message,
    });
  }

  void _sendGroupMessage(String message) {
    socket!.emit('send_group_message', {
      'token': _token,
      'group_id': widget.userId,
      'content': message,
    });
  }

  Future<void> _sendMessageViaApi(String message) async {
    final response = await http.post(
      Uri.parse(
        widget.isGroup
            ? 'https://momhive-992deeb4847a.herokuapp.com/api/v1/messages/group'
            : 'https://momhive-992deeb4847a.herokuapp.com/api/v1/messages/private',
      ),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        widget.isGroup ? 'group_id' : 'receiver_id': widget.userId,
        'content': message,
      }),
    );
    if (response.statusCode != 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send message')),
      );
    }
  }

  String formatTimestamp(String isoString) {
    final DateTime dateTime = DateTime.parse(isoString);
    return DateFormat('hh:mm a').format(dateTime);
  }

  //
  // @override
  // void dispose() {
  //   _messageController.dispose();
  //   socket?.disconnect();
  //   super.dispose();
  // }
  //
  @override
>>>>>>> 58e33d3 (Add eventlet)
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
<<<<<<< HEAD
              backgroundImage: const AssetImage(
                  'assets/avatar_placeholder.png'), // Use actual contact's avatar here
            ),
            const SizedBox(width: 10),
            Text(
              contactName,
=======
              backgroundImage: const AssetImage('assets/momhive_logo.png'),
            ),
            const SizedBox(width: 10),
            Text(
              widget.contactName,
>>>>>>> 58e33d3 (Add eventlet)
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.yellow[700],
<<<<<<< HEAD
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Implement more options here
            },
          ),
        ],
=======
>>>>>>> 58e33d3 (Add eventlet)
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
<<<<<<< HEAD
              itemCount:
                  10, // This should be the number of messages in the conversation
              itemBuilder: (context, index) {
                // Replace this with the actual message data and logic to alternate between sender and receiver
                bool isSentByUser = index % 2 == 0;

                return Align(
                  alignment: isSentByUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
=======
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSentByUser = message['sentByUser'] as bool;
                return Align(
                  alignment: isSentByUser
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
>>>>>>> 58e33d3 (Add eventlet)
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
<<<<<<< HEAD
                      color: isSentByUser ? Colors.yellow[100] : Colors.white,
                      borderRadius: BorderRadius.circular(15),
=======
                      color: isSentByUser ? Colors.green[50] : Colors.white,
                      borderRadius: isSentByUser
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15))
                          : const BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
>>>>>>> 58e33d3 (Add eventlet)
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
<<<<<<< HEAD
                    child: const Text(
                      'This is a messagejijijijijijijijijijijijijijijijijfffffffffffffffffffffffffffffffffffffffffffffffffffff jiji jijij ji j ji',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
=======
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['message'],
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          formatTimestamp(message['timestamp']),
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                      ],
>>>>>>> 58e33d3 (Add eventlet)
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
<<<<<<< HEAD
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
=======
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Message...',
>>>>>>> 58e33d3 (Add eventlet)
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
<<<<<<< HEAD
                          horizontal: 20, vertical: 5),
=======
                          horizontal: 20, vertical: 10),
>>>>>>> 58e33d3 (Add eventlet)
                    ),
                  ),
                ),
                IconButton(
<<<<<<< HEAD
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
=======
                  icon: Icon(Icons.send, color: Colors.green[600]),
                  onPressed: () {
                    _sendMessage(_messageController.text);
>>>>>>> 58e33d3 (Add eventlet)
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
