import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/booking_model.dart';

class BookingService {
  Future<List<Booking>> getBookings() async {
    final String response = await rootBundle.loadString('assets/data/ bookings.json');
    final data = await json.decode(response) as List;
    return data.map((i) => Booking.fromJson(i)).toList();
  }
}
