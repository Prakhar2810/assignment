import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'inventory_model.g.dart';

@HiveType()
class Inventory {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final DateTime date;

  @HiveField(2)
  Uint8List image;

  Inventory({this.date, this.name, this.description,this.image});
}
