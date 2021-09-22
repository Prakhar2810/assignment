
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_reminder_app/core/models/inventory_model.dart';
import 'package:image_picker/image_picker.dart';

import 'imageHelper.dart';

class HomeModel with ChangeNotifier {
  String _inventoryBox = 'inventory';
  File _image;
  Uint8List imageByteArray;

  List _inventoryList = <Inventory>[];

  List get inventoryList => _inventoryList;

  addItem(Inventory inventory) async {
    var box = await Hive.openBox<Inventory>(_inventoryBox);

    box.add(inventory);

    print('added');

    notifyListeners();
  }

  getItem() async {
    final box = await Hive.openBox<Inventory>(_inventoryBox);

    _inventoryList = box.values.toList();

    notifyListeners();
  }

  updateItem(int index, Inventory inventory) {
    final box = Hive.box<Inventory>(_inventoryBox);

    box.putAt(index, inventory);

    notifyListeners();
  }

  deleteItem(int index) {
    final box = Hive.box<Inventory>(_inventoryBox);

    box.deleteAt(index);

    getItem();

    notifyListeners();
  }

  File get image => _image;

  Future<void> selectImage() async {
    // TODO: Remove the deprecations
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
  }
 Future<void> onPress () async{
    imageByteArray = await ImageHelper.compressImage(_image);
notifyListeners();
  }
}
