import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MessageDetailPage extends StatefulWidget {
  final String contactName;
  final String senderID;
  final bool isGroup;

  const MessageDetailPage({
    Key? key,
    required this.contactName,
    required this.senderID,
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
  Map<String, dynamic>? _userDetails;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final token = await storage.read(key: 'auth_token');
      if (token == null) throw Exception('Token is null');

      final response = await http.get(
        Uri.parse('https://momhive-backend.onrender.com/api/v1/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _userDetails = data;
        });
        _initializeWebSocket(); // Initialize WebSocket after fetching user details
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again.');
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (e) {
      print('Error fetching user details: $e');
      _showSnackBar('Error fetching user details: $e');
    }
  }

  void _initializeWebSocket() {
    if (_userDetails == null) return;

    print('Initializing WebSocket...');
    socket = IO.io(
      'https://momhive-backend.onrender.com/socket.io/',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.on('connect', (_) {
      print('Connected to WebSocket');
      setState(() {
        _isConnected = true;
      });
      _joinRoom();
    });

    socket!.on('disconnect', (_) {
      print('Disconnected from WebSocket');
      setState(() {
        _isConnected = false;
      });
    });

    socket!.on('connect_error', (err) {
      print('Connection error: $err');
      _showSnackBar('Connection error. Please try again.');
    });

    socket!.on('receive_private_message', (data) => _handleReceivedMessage(data));
    socket!.on('receive_group_message', (data) => _handleReceivedMessage(data));

    socket!.connect();
  }

  void _joinRoom() {
    if (_userDetails == null) return;

    final userId = _userDetails!['id'];
    if (widget.isGroup) {
      print('Joining group room: ${widget.senderID}');
      socket!.emit('join_group_room', {'group_id': widget.senderID, 'user_id': userId});
    } else {
      print('Joining private room with ${widget.senderID}');
      socket!.emit('join_private_room', {'sender_id': userId, 'receiver_id': widget.senderID});
    }
  }

  void _handleReceivedMessage(dynamic data) {
    if (!mounted) return;

    print('Received message: $data');
    setState(() {
      _messages.insert(0, {
        'userId': data['sender_id'],
        'message': data['content'],
        'timestamp': data['timestamp'],
        'sentByUser': data['sender_id'] == _userDetails!['id'],
      });
    });
  }

  void _sendMessage(String message) {
    if (message.isEmpty || _userDetails == null) return;

    final event = widget.isGroup ? 'send_group_message' : 'send_private_message';
    final payload = widget.isGroup
        ? {'group_id': widget.senderID, 'content': message, 'sender_id': _userDetails!['id']}
        : {'receiver_id': widget.senderID, 'content': message, 'sender_id': _userDetails!['id']};

    print('Sending message: $payload');
    socket!.emit(event, payload);

    setState(() {
      _messages.insert(0, {
        'userId': _userDetails!['id'],
        'message': message,
        'sentByUser': true,
        'timestamp': DateTime.now().toIso8601String(),
      });
    });

    _messageController.clear();
  }

  String formatTimestamp(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return 'Invalid timestamp';
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _messageController.dispose();
    socket?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: const AssetImage('assets/momhive_logo.png'),
            ),
            const SizedBox(width: 10),
            Text(
              widget.contactName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.yellow[700],
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
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSentByUser = message['sentByUser'] as bool;
                return Align(
                  alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: _buildMessageBubble(message, isSentByUser),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isSentByUser) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSentByUser ? Colors.green[50] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message['message'], style: const TextStyle(color: Colors.black87, fontSize: 15)),
          const SizedBox(height: 5),
          Text(formatTimestamp(message['timestamp']), style: const TextStyle(color: Colors.black54, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey[600]),
            onPressed: () {
              // Open emoji keyboard
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Message...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.green[600]),
            onPressed: () => _sendMessage(_messageController.text),
          ),
        ],
      ),
    );
  }
}

