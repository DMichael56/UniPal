import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/booking_model.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class BookingService {
  List<Booking>? _bookings;

  Future<List<Booking>> getBookings() async {
    if (_bookings == null) {
      final String response =
          await rootBundle.loadString('assets/data/bookings.json');
      final data = await json.decode(response) as List;
      _bookings = data.map((i) => Booking.fromJson(i)).toList();
    }
    return _bookings!;
  }

  Future<void> addBooking(Booking booking) async {
    await getBookings();

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

    _bookings!.add(newBooking);
  }
}
