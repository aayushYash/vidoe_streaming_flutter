import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatWidget extends StatefulWidget {
  final String partyId;
  const ChatWidget({Key? key, required this.partyId}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final DatabaseReference _chatDB = FirebaseDatabase.instance.ref();
  final TextEditingController _messageController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  void _sendMessage() {
    if (_messageController.text.isEmpty || user == null) return;

    _chatDB.child('watch_parties/${widget.partyId}/chat').push().set({
      'user': user!.displayName ?? "Guest",
      'message': _messageController.text,
      'timestamp': ServerValue.timestamp,
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _chatDB
                  .child('watch_parties/${widget.partyId}/chat')
                  .orderByChild('timestamp')
                  .onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const Center(child: Text("No messages yet"));
                }
    
                Map<dynamic, dynamic> messages =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
    
                return ListView(
                  children: messages.values.map((msg) {
                    return ListTile(
                      
                      tileColor: Colors.deepPurple,
                      title: Text(msg['user']),
                      subtitle: Text(msg['message']),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: "Type a message",border: OutlineInputBorder()),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
