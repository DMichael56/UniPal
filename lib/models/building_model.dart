import 'dart:convert';

class Building {
  final String id;
  final String name;
  final String address;
  final String w3w;
  final int floors;
  final bool hasCafe;
  final bool hasElevator;
  final bool hasHelpdesk;

  Building({
    required this.id,
    required this.name,
    required this.address,
    required this.w3w,
    required this.floors,
    required this.hasCafe,
    required this.hasElevator,
    required this.hasHelpdesk,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      w3w: json['W3W'],
      floors: json['floors'],
      hasCafe: json['has_cafe'],
      hasElevator: json['has_elevator'],
      hasHelpdesk: json['has_helpdesk'],
    );
  }
}

class Room {
  final String id;
  final String buildingId;
  final String roomNumber;
  final int floor;
  final bool hasProjector;
  final bool hasComputers;
  final int capacity;

  Room({
    required this.id,
    required this.buildingId,
    required this.roomNumber,
    required this.floor,
    required this.hasProjector,
    required this.hasComputers,
    required this.capacity,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      buildingId: json['building_id'],
      roomNumber: json['room_number'],
      floor: json['floor'],
      hasProjector: json['has_projector'],
      hasComputers: json['has_computers'],
      capacity: json['capacity'],
    );
  }
}
