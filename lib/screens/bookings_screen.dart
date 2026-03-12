
import 'package:flutter/material.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('building name?'),
      ),
      body: ListView.builder(
        itemCount: 1, // fake ones for now
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('Booking #${index + 1}'),
              subtitle: const Text('i guess the details here'),
              trailing: const Icon(Icons.more_vert),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add the onPressed code here (this message is for who was assigned to design the UI)
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
