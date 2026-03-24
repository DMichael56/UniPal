import 'package:flutter/material.dart';
import 'package:myapp/screens/group_chat_screen.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/screens/bookings_screen.dart';
import 'package:myapp/screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeDashboard(),
    const GroupSelectionPage(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

//Home dash board
class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(12),
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      
      children: [
        _card(context, 'Booking', Icons.meeting_room, const BookingsScreen()),
        _card(context, 'Notes', Icons.note, const RevisionNotesPage()),
        _card(context, 'Groups', Icons.group, const GroupSelectionPage()),
        _card(context, 'Calendar', Icons.calendar_month, const CalendarPage()),
        _card(context, 'Files', Icons.folder, const FindResourcesPage()),
        _card(context, 'Upload', Icons.upload, const UploadPage()),
      ],
    );
  }




  Widget _card(BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// Basic page
class BasicPage extends StatelessWidget {
  final String title;
  const BasicPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: Center(child: Text(title, style: const TextStyle(fontSize: 20))),
    );
  }
}


// Other pages
class RevisionNotesPage extends BasicPage {
  const RevisionNotesPage({super.key}) : super(title: 'Revision Notes');
}

class UploadPage extends BasicPage {
  const UploadPage({super.key}) : super(title: 'Upload');
}

class FindResourcesPage extends BasicPage {
  const FindResourcesPage({super.key}) : super(title: 'Find Resources');
}



class CalendarPage extends BasicPage {
  const CalendarPage({super.key}) : super(title: 'Calendar');
}