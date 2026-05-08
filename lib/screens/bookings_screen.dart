import 'package:flutter/material.dart';
import 'package:myapp/models/booking_model.dart';
import 'package:myapp/services/booking_service.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tile(context, 'Start Booking', const BookingStepperPage()),
          _tile(context, 'Building Selection', const BuildingSelectionPage()),
          _tile(context, 'Room Layout', const RoomLayoutPage()),
          _tile(context, 'My Bookings', const ViewBookingPage()),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, String text, Widget page) {
    return Card(
      child: ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
}

class BookingStepperPage extends StatefulWidget {
  const BookingStepperPage({super.key});

  @override
  State<BookingStepperPage> createState() => _BookingStepperPageState();
}

class _BookingStepperPageState extends State<BookingStepperPage> {
  int _currentStep = 0;

  String? building;
  String? room;
  int people = 1;
  DateTime? selectedDate;
  String? selectedTime;
  final TextEditingController _titleController = TextEditingController();

  final List<String> timeSlots = List.generate(10, (index) {
    return '${(index + 9).toString().padLeft(2, '0')}:00'; // 09:00 to 18:00
  });

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_currentStep == 0 && building == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a building.')),
      );
      return;
    }
    if (_currentStep == 1 && room == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a room.')),
      );
      return;
    }
    if (_currentStep == 2) {
      if (_titleController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a title.')),
        );
        return;
      }
      if (selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date.')),
        );
        return;
      }
      if (selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a time.')),
        );
        return;
      }
    }
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Room'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          )
        ],
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _continue,
        onStepCancel: _cancel,
        steps: [
          Step(
            title: const Text('Building'),
            content: DropdownButton<String>(
              hint: const Text('Select building'),
              value: building,
              items: ['A', 'B', 'C']
                  .map((b) => DropdownMenuItem(
                        value: b,
                        child: Text('Building $b (WiFi, Seats available)'),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => building = val),
            ),
          ),
          Step(
            title: const Text('Room'),
            content: DropdownButton<String>(
              hint: const Text('Select room'),
              value: room,
              items: ['101', '102', '201']
                  .map((r) => DropdownMenuItem(
                        value: r,
                        child: Text('Room $r'),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => room = val),
            ),
          ),
          Step(
            title: const Text('Details'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Booking Title',
                    hintText: 'e.g., Team Meeting, Study Session',
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Number of People:'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (people > 1) {
                          setState(() => people--);
                        }
                      },
                    ),
                    Text('$people', style: Theme.of(context).textTheme.titleLarge),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (people < 20) {
                          setState(() => people++);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickDate,
                      child: Text(selectedDate == null
                          ? 'Select Date'
                          : selectedDate.toString().split(' ')[0]),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      hint: const Text('Select Time'),
                      value: selectedTime,
                      items: timeSlots.map((time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedTime = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Confirm'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${_titleController.text}\nBuilding: $building\nRoom: $room\nPeople: $people\nDate: ${selectedDate?.toString().split(' ')[0] ?? 'N/A'}\nTime: ${selectedTime ?? 'N/A'}',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final newBooking = Booking(
                      id: uuid.v4(),
                      itemId: room!,
                      groupId: building!,
                      bookedBy: 'user@example.com', // Placeholder
                      title: _titleController.text,
                      date: selectedDate.toString().split(' ')[0],
                      startTime: selectedTime!,
                      endTime: '${(int.parse(selectedTime!.split(':')[0]) + 1).toString().padLeft(2, '0')}:00',
                      status: 'confirmed',
                      attendees: List.generate(people, (index) => Attendee(userId: 'person${index + 1}@example.com', rsvp: 'accepted')).toList(),
                      notificationSent: false,
                      createdAt: DateTime.now().toIso8601String(),
                    );

                    await BookingService().addBooking(newBooking);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Booking Confirmed!'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ViewBookingPage()),
                    );
                  },
                  child: const Text('Confirm Booking'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//Building selection

class BuildingSelectionPage extends StatelessWidget {
  const BuildingSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final buildings = [
      {'name': 'Building A', 'amenities': 'WiFi, Projector', 'spaces': '10 spaces'},
      {'name': 'Building B', 'amenities': 'Computers, AC', 'spaces': '5 spaces'},
      {'name': 'Building C', 'amenities': 'Quiet Area', 'spaces': '2 spaces'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Select Building')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: buildings.map((b) {
          return Card(
            child: ListTile(
              title: Text(b['name']!),
              subtitle: Text('${b['amenities']} • ${b['spaces']}'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${b['name']} selected')),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ROUGH room layout (to be changed a lot)

class RoomLayoutPage extends StatelessWidget {
  const RoomLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Room Layout')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seat ${index + 1} selected')),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class ViewBookingPage extends StatefulWidget {
  const ViewBookingPage({super.key});

  @override
  State<ViewBookingPage> createState() => _ViewBookingPageState();
}

class _ViewBookingPageState extends State<ViewBookingPage> {
  late Future<List<Booking>> _bookings;

  @override
  void initState() {
    super.initState();
    _bookings = BookingService().getBookings();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Bookings')),
      body: FutureBuilder<List<Booking>>(
        future: _bookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings yet.'));
          } else {
            return ListView(
              children: snapshot.data!
                  .map((b) => ListTile(
                        title: Text(b.title),
                        subtitle: Text('${b.date} at ${b.startTime} - ${b.endTime}'),
                        leading: const Icon(Icons.meeting_room),
                      ))
                  .toList(),
            );
          }
        },
      ),
    );
  }
}
