import 'dart:convert';
import 'package:flutter/services.dart';
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

  List<Booking>? _bookings;

  Future<List<Booking>> getBookings() async {
    if (_bookings == null) {
      try {
        final String response =
            await rootBundle.loadString('assets/data/bookings.json');
        final data = await json.decode(response) as List;
        _bookings = data.map((i) => Booking.fromJson(i)).toList();
      } catch (e) {
        // If the file doesn't exist or is empty, start with an empty list
        _bookings = [];
      }
    }
    return _bookings!;
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
  }

  Future<void> updateBooking(Booking updatedBooking) async {
    final bookings = await getBookings();
    final index = bookings.indexWhere((b) => b.id == updatedBooking.id);
    if (index != -1) {
      bookings[index] = updatedBooking;
    }
  }

  Future<void> removeBooking(String id) async {}
}
