import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_reminder_app/core/models/inventory_model.dart';
import 'package:provider/provider.dart';
import '../../../app/extensions/size_extension.dart';
import '../../../app/size_config.dart';
import 'home_model.dart';
import 'imagePicker.dart';

class HomeView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    context.watch<HomeModel>().getItem();

    return Consumer<HomeModel>(
      builder: (context, model, child) {

        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: Padding(
            padding: EdgeInsets.only(top: 6.height),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    'Movies List',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Lato',
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Add, Delete and update movies list',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Lato',
                        color: Colors.grey),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: model.inventoryList.length > 0? CarouselSlider.builder(
                      itemCount: model.inventoryList.length,
                      itemBuilder: (context, index, pindex) {
                        Inventory inv = model.inventoryList[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.4,
                                    margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                        image: model.imageByteArray != null
                                            ? MemoryImage(
                                            model.imageByteArray)
                                            : AssetImage('images/clapboard.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        nameController.text = inv.name;
                                        descriptionController.text =
                                            inv.description;

                                        inputItemDialog(
                                            context, 'update', index);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 10, right: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        model.deleteItem(index);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 10, right: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Text(
                              "Movie Name : " + inv.name,
                              style: TextStyle(
                                color: Colors.green[600],
                                fontWeight: FontWeight.w600,
                                fontSize: 4.5.text,
                              ),
                            ),
                            SizedBox(
                              height: 1.height,
                            ),
                            Text(
                              "Director Name : " + inv.description,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 4.text,
                              ),
                            )
                          ],
                        );
                      },
                      options: CarouselOptions(
                        height:
                        MediaQuery.of(context).size.height * 0.6,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        viewportFraction: 0.8,
                      ),
                    ): Center(child: Text('NO RECORD FOUND',style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),)),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.yellow,
            onPressed: () {
              inputItemDialog(context, 'add');
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 8.width,
            ),
          ),
        );
      },
    );
  }

  inputItemDialog(BuildContext context, String action, [int index]) {
    var inventoryDb = Provider.of<HomeModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 40,
                ),
                height: 45.height,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child:
                        Consumer<HomeModel>(builder: (context, model, child) {
                      return Column(
                        children: <Widget>[
                          Text(
                            action == 'add' ? 'Add Movie' : 'Update ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Movie name cannot be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Movie name',
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            controller: descriptionController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Movie description cannot be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Director Name',
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ImagePickerWidget(
                              onPressed: () async {
                                model.selectImage();
                              },
                              image: model.image),
                          SizedBox(
                            height: 40,
                          ),
                          RaisedButton(
                            onPressed: () async {
                             await model.onPress();
                              if (_formKey.currentState.validate()) {
                                if (action == 'add') {
                                  await inventoryDb.addItem(Inventory(
                                      name: nameController.text,
                                      description: descriptionController.text,
                                      image: model.imageByteArray));
                                } else {
                                  await inventoryDb.updateItem(
                                      index,
                                      Inventory(
                                          name: nameController.text,
                                          description:
                                              descriptionController.text,
                                          image: model.imageByteArray));
                                }

                                nameController.clear();
                                descriptionController.clear();
                                inventoryDb.getItem();

                                Navigator.pop(context);
                              }
                            },
                            color: Colors.green[600],
                            child: Text(
                              action == 'add' ? 'Add' : 'update',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      );
                    }),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
/*Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 2.width),
                                width: 16.width,
                                decoration: BoxDecoration(
                                  color: Colors.green[600],
                                  shape: BoxShape.circle,
                                ),
                               child:  Image(
                        image:
                       model.image!= null ? MemoryImage(model.imageByteArray):
                       MemoryImage(inv.image),
                                 height: 80,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        ),
                                                             ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 3.height,
                                  horizontal: 3.width,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      inv.name,
                                      style: TextStyle(
                                        color: Colors.green[600],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 4.5.text,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.height,
                                    ),
                                    Text(
                                      inv.description,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 4.text,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.width),
                                child: PopupMenuButton(
                                  onSelected: (item) {
                                    switch (item) {
                                      case 'update':
                                        nameController.text = inv.name;
                                        descriptionController.text =
                                            inv.description;

                                        inputItemDialog(context, 'update', index);
                                        break;
                                      case 'delete':
                                        model.deleteItem(index);
                                    }
                                  },
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        value: 'update',
                                        child: Text('Update'),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ];
                                  },
                                ),
                              ),
                            ],
                          ),*/