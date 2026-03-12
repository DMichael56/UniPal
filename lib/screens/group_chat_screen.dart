
import 'package:flutter/material.dart';

class GroupChatScreen extends StatelessWidget {
  const GroupChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Chat'),
      ),
      body: const Center(
        child: Text('This is the group chat screen.'),
      ),
    );
  }
}
