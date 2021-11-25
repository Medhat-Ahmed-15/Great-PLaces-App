import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/place.dart';
import 'package:flutter_complete_guide/providers/great_places.dart';
import 'package:flutter_complete_guide/widgets/image_input.dart';
import 'package:flutter_complete_guide/widgets/location_input.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/AddPlaceScreen';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;

  void _selectedImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectedLocation(PlaceLocation pickedLocation) {
    _pickedLocation = pickedLocation;
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      return;
    }

    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage, _pickedLocation);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(_selectedImage),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(_selectedLocation)
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            onPressed: _savePlace,
            icon: Icon(Icons.add),
            label: Text('Add Place'),
            materialTapTargetSize: MaterialTapTargetSize
                .shrinkWrap, //el line dah mofeed fa 2n msln ana hatat button fa bottom el page bs bayb2 lesa fee sabsoob fady ma5alee el button msh laz2 100% fa bottom el page dah ba2 bay5aleeh yalz2 fal bottom
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
    );
  }
}
