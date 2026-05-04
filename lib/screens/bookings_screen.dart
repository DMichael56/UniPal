import 'package:flutter/material.dart';
import 'package:myapp/models/booking_model.dart';
import 'package:myapp/services/booking_service.dart';

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
          _tile(context, 'Start Booking (Step Flow)', const BookingStepperPage()),
          _tile(context, 'Building Selection', const BuildingSelectionPage()),
          _tile(context, 'Room Layout', const RoomLayoutPage()),
          _tile(context, 'Booking Details', const BookingDetailsPage()),
          _tile(context, 'Confirm Booking', const ConfirmBookingPage()),
          _tile(context, 'View Booking', const ViewBookingPage()),
          _tile(context, 'Cancel Booking', const CancelBookingPage()),
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

  final List<String> timeSlots = List.generate(10, (index) {
    return '${(index + 9).toString().padLeft(2, '0')}:00'; // 09:00 to 18:00
  });

  void _continue() {
    if (_currentStep < 5) {
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
            content: Text(
              'Building: $building\nRoom: $room\nPeople: $people\nDate: ${selectedDate?.toString().split(' ')[0] ?? 'N/A'}\nTime: ${selectedTime ?? 'N/A'}',
            ),
          ),
          const Step(
            title: Text('Booked'),
            content: Text('Your booking is confirmed!'),
          ),
          const Step(
            title: Text('Manage'),
            content: Text('View or cancel bookings here (future feature)'),
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

///booking details

class BookingDetailsPage extends StatefulWidget {
  const BookingDetailsPage({super.key});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  int people = 1;
  DateTime? selectedDate;
  String? selectedTime;

  final List<String> timeSlots = List.generate(10, (index) {
    return '${(index + 9).toString().padLeft(2, '0')}:00'; // 09:00 to 18:00
  });

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
      appBar: AppBar(title: const Text('Booking Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Number of People'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (people > 1) {
                      setState(() => people--);
                    }
                  },
                ),
                Text('$people', style: Theme.of(context).textTheme.headlineMedium),
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
              mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}

//Confirm bookings
class ConfirmBookingPage extends StatelessWidget {
  const ConfirmBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Booking Confirmed!')),
            );
          },
          child: const Text('Confirm Booking'),
        ),
      ),
    );
  }
}

// View bookings

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

//Cancel bookings

class CancelBookingPage extends StatelessWidget {
  const CancelBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = ['Room 101 - Tomorrow', 'Room 202 - Friday'];

    return Scaffold(
      appBar: AppBar(title: const Text('Cancel Booking')),
      body: ListView(
        children: bookings
            .map((b) => ListTile(
                  title: Text(b),
                  trailing: const Icon(Icons.cancel),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$b cancelled')),
                    );
                  },
                ))
            .toList(),
      ),
    );
  }
}
