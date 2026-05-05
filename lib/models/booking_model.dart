class Booking {
  final String id;
  final String itemId;
  final String groupId;
  final String bookedBy;
  final String title;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final List<Attendee> attendees;
  final bool notificationSent;
  final String createdAt;

  Booking({
    required this.id,
    required this.itemId,
    required this.groupId,
    required this.bookedBy,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.attendees,
    required this.notificationSent,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      itemId: json['itemId'],
      groupId: json['groupId'],
      bookedBy: json['bookedBy'],
      title: json['title'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'],
      attendees: (json['attendees'] as List)
          .map((i) => Attendee.fromJson(i))
          .toList(),
      notificationSent: json['notificationSent'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'groupId': groupId,
      'bookedBy': bookedBy,
      'title': title,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'attendees': attendees.map((i) => i.toJson()).toList(),
      'notificationSent': notificationSent,
      'createdAt': createdAt,
    };
  }
}

class Attendee {
  final String userId;
  final String rsvp;

  Attendee({required this.userId, required this.rsvp});

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      userId: json['userId'],
      rsvp: json['rsvp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'rsvp': rsvp,
    };
  }
}
