import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_model.dart';

class UserService {
  Future<User> getUser() async {
    final String response = await rootBundle.loadString('assets/data/users.json');
    final data = await json.decode(response);
    return User.fromJson(data[0]);
  }
}
