import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/booking_model.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class BookingService {
  // Private constructor
  BookingService._privateConstructor();

  // Static instance
  static final BookingService _instance = BookingService._privateConstructor();

  // Factory constructor
  factory BookingService() {
    return _instance;
  }

  static const String _fileName = 'bookings.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  Future<List<Booking>> getBookings() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        // If the file doesn't exist, load from assets and create it
        final String response = await rootBundle.loadString('assets/data/bookings.json');
        await file.writeAsString(response);
      }
      final contents = await file.readAsString();
      final data = json.decode(contents) as List;
      return data.map((i) => Booking.fromJson(i)).toList();
    } catch (e) {
      // If there are any errors, return an empty list
      return [];
    }
  }

  Future<void> _writeBookings(List<Booking> bookings) async {
    final file = await _localFile;
    final jsonList = bookings.map((b) => b.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  Future<void> addBooking(Booking booking) async {
    final bookings = await getBookings();

    // Validation
    final bookingDate = DateTime.parse(booking.date);
    final now = DateTime.now();
    // Normalize to compare dates only, ignoring time
    final today = DateTime(now.year, now.month, now.day);

    if (bookingDate.isBefore(today)) {
      throw Exception('Booking date cannot be in the past.');
    }

    if (booking.attendees.isEmpty) {
      throw Exception('A booking must have at least one attendee.');
    }

    final newBooking = Booking(
      id: uuid.v4(),
      itemId: booking.itemId,
      groupId: booking.groupId,
      bookedBy: booking.bookedBy,
      title: booking.title,
      date: booking.date,
      startTime: booking.startTime,
      endTime: booking.endTime,
      status: booking.status,
      attendees: booking.attendees,
      notificationSent: false,
      createdAt: DateTime.now().toIso8601String(),
    );

    bookings.add(newBooking);
    await _writeBookings(bookings);
  }

  Future<void> updateBooking(Booking updatedBooking) async {
    final bookings = await getBookings();
    final index = bookings.indexWhere((b) => b.id == updatedBooking.id);
    if (index != -1) {
      bookings[index] = updatedBooking;
      await _writeBookings(bookings);
    }
  }

  Future<void> removeBooking(String bookingId) async {
    final bookings = await getBookings();
    bookings.removeWhere((booking) => booking.id == bookingId);
    await _writeBookings(bookings);
  }
}
