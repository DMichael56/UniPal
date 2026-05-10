import 'package:myapp/models/booking_model.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();


class BookingService {
  static final List<Booking> _bookings = [];

  Future<List<Booking>> getBookings() async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _bookings;
  }

  Future<void> addBooking(Booking booking) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _bookings.add(booking);
  }

  Future<void> updateBooking(Booking updatedBooking) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _bookings.indexWhere((b) => b.id == updatedBooking.id);
    if (index != -1) {
      _bookings[index] = updatedBooking;
    }
  }

  Future<void> removeBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _bookings.removeWhere((booking) => booking.id == bookingId);
  }

  Future<void> clearAllBookings() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _bookings.clear();
  }
}
