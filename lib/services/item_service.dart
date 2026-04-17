import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/item_model.dart';

class ItemService {
  Future<List<Item>> getItems() async {
    final String response = await rootBundle.loadString('assets/data/ items.json');
    final data = await json.decode(response);
    return (data['items'] as List).map((i) => Item.fromJson(i)).toList();
  }
}
