
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/room_box.dart';

Future<List<RoomBox>> loadRoomBoxes() async {
  final String jsonStr = await rootBundle.loadString('assets/data/room_boxes.json');
  final List<dynamic> jsonData = jsonDecode(jsonStr);
  return jsonData.map((e) => RoomBox.fromJson(e)).toList();
}
