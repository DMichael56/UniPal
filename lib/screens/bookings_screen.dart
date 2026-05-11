import 'package:flutter/material.dart';
import 'package:myapp/models/booking_model.dart';
import 'package:myapp/models/building_model.dart';
import 'package:myapp/services/booking_service.dart';
import 'package:myapp/services/building_service.dart';
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

  String? buildingId;
  String? roomId;
  int people = 1;
  DateTime? selectedDate;
  String? selectedTime;
  final TextEditingController _titleController = TextEditingController();

  final List<String> timeSlots = List.generate(10, (index) {
    return '${(index + 9).toString().padLeft(2, '0')}:00'; // 09:00 to 18:00
  });

  late Future<List<Building>> _buildings;
  late Future<List<Room>> _rooms;

  @override
  void initState() {
    super.initState();
    _buildings = BuildingService().getBuildings();
    _rooms = Future.value([]); // Initially empty
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_currentStep == 0 && buildingId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a building.')),
      );
      return;
    }
    if (_currentStep == 1 && roomId == null) {
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
            content: FutureBuilder<List<Building>>(
              future: _buildings,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return DropdownButton<String>(
                  hint: const Text('Select building'),
                  value: buildingId,
                  items: snapshot.data!.map((b) => DropdownMenuItem(
                        value: b.id,
                        child: Text(b.name),
                      ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      buildingId = val;
                      roomId = null; // Reset room selection
                      _rooms = BuildingService().getRooms(val!);
                    });
                  },
                );
              },
            ),
          ),
          Step(
            title: const Text('Room'),
            content: FutureBuilder<List<Room>>(
              future: _rooms,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return DropdownButton<String>(
                  hint: const Text('Select room'),
                  value: roomId,
                  items: snapshot.data!.map((r) => DropdownMenuItem(
                        value: r.id,
                        child: Text(r.roomNumber),
                      ))
                      .toList(),
                  onChanged: (val) => setState(() => roomId = val),
                );
              },
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
                  'Title: ${_titleController.text}\nBuilding: $buildingId\nRoom: $roomId\nPeople: $people\nDate: ${selectedDate?.toString().split(' ')[0] ?? 'N/A'}\nTime: ${selectedTime ?? 'N/A'}',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final newBooking = Booking(
                      id: uuid.v4(),
                      itemId: roomId!,
                      groupId: buildingId!,
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
    return Scaffold(
      appBar: AppBar(title: const Text('Select Building')),
      body: FutureBuilder<List<Building>>(
        future: BuildingService().getBuildings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Unable to load buildings.'));
          }

          final buildings = snapshot.data ?? [];
          if (buildings.isEmpty) {
            return const Center(child: Text('No buildings found.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: buildings.map((building) {
              final facilities = [
                if (building.hasCafe) 'Cafe',
                if (building.hasElevator) 'Elevator',
                if (building.hasHelpdesk) 'Helpdesk',
              ];

              return Card(
                child: ListTile(
                  title: Text(building.name),
                  subtitle: Text(
                    facilities.isEmpty
                        ? 'No listed facilities'
                        : facilities.join(', '),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${building.name} selected')),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
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

  void _refreshBookings() {
    setState(() {
      _bookings = BookingService().getBookings();
    });
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
              children: snapshot.data!.map((booking) {
                return ListTile(
                  title: Text(booking.title),
                  subtitle: Text('${booking.date} at ${booking.startTime} - ${booking.endTime}'),
                  leading: const Icon(Icons.meeting_room),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await BookingService().removeBooking(booking.id);
                      _refreshBookings();
                    },
                  ),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBookingPage(booking: booking),
                      ),
                    );
                    if (result == true) {
                      _refreshBookings();
                    }
                  },
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}

class EditBookingPage extends StatefulWidget {
  final Booking booking;

  const EditBookingPage({super.key, required this.booking});

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  late TextEditingController _titleController;
  late DateTime _selectedDate;
  late String _selectedTime;
  late int _people;
  late String _buildingId;
  late String _roomId;

  final List<String> timeSlots = List.generate(10, (index) {
    return '${(index + 9).toString().padLeft(2, '0')}:00'; // 09:00 to 18:00
  });

  late Future<List<Building>> _buildings;
  late Future<List<Room>> _rooms;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.booking.title);
    _selectedDate = DateTime.parse(widget.booking.date);
    _selectedTime = widget.booking.startTime;
    _people = widget.booking.attendees.length;
    _buildingId = widget.booking.groupId;
    _roomId = widget.booking.itemId;

    _buildings = BuildingService().getBuildings();
    _rooms = BuildingService().getRooms(_buildingId);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Booking Title',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                FutureBuilder<List<Building>>(
                  future: _buildings,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    return DropdownButton<String>(
                      value: _buildingId,
                      items: snapshot.data!.map((b) {
                        return DropdownMenuItem(
                          value: b.id,
                          child: Text(b.name),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _buildingId = newValue!;
                          _roomId = ''; // Reset room selection
                          _rooms = BuildingService().getRooms(newValue);
                        });
                      },
                    );
                  },
                ),
                const SizedBox(width: 16),
                FutureBuilder<List<Room>>(
                  future: _rooms,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    return DropdownButton<String>(
                      value: _roomId.isNotEmpty ? _roomId : null,
                      hint: const Text('Select Room'),
                      items: snapshot.data!.map((r) {
                        return DropdownMenuItem(
                          value: r.id,
                          child: Text(r.roomNumber),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _roomId = newValue!;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickDate,
                  child: Text(_selectedDate.toString().split(' ')[0]),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedTime,
                  items: timeSlots.map((time) {
                    return DropdownMenuItem(
                      value: time,
                      child: Text(time),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedTime = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Number of People:'),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (_people > 1) {
                      setState(() => _people--);
                    }
                  },
                ),
                Text('$_people', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_people < 20) {
                      setState(() => _people++);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedBooking = widget.booking.copyWith(
                  title: _titleController.text,
                  date: _selectedDate.toString().split(' ')[0],
                  startTime: _selectedTime,
                  endTime: '${(int.parse(_selectedTime.split(':')[0]) + 1).toString().padLeft(2, '0')}:00',
                  attendees: List.generate(_people, (index) => Attendee(userId: 'person${index + 1}@example.com', rsvp: 'accepted')).toList(),
                  groupId: _buildingId,
                  itemId: _roomId,
                );
                await BookingService().updateBooking(updatedBooking);
                Navigator.pop(context, true);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
