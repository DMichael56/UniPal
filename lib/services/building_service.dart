import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/building_model.dart';

class BuildingService {
  Future<List<Building>> getBuildings() async {
    final String response = await rootBundle.loadString('assets/data/building.json');
    final data = await json.decode(response);
    return (data['buildings'] as List).map((i) => Building.fromJson(i)).toList();
  }

  Future<List<Room>> getRooms(String buildingId) async {
    final String response = await rootBundle.loadString('assets/data/building.json');
    final data = await json.decode(response);
    return (data['rooms'] as List)
        .map((i) => Room.fromJson(i))
        .where((room) => room.buildingId == buildingId)
        .toList();
  }
}
