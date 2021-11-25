import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/helpers/db_helper.dart';
import 'package:flutter_complete_guide/helpers/location_helper.dart';
import 'package:flutter_complete_guide/models/place.dart';

//I could have done all the logic of the database here in this file But I want to keep that file focused on creating and storing places and the database access will be out into a sperate folder which is in folder helpers
class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [
      ..._items
    ]; //again so that we can always get access to the items from anywhere in the app but we get access to a copy of the items, so if we change that list from the place where we're getting access to it, then we won't change the list here in this class which is certainly something we want to avoid,
  }

  Future<void> addPlace(String pickedTitle, File pickedImage,
      PlaceLocation pickedLocation) async {
    final locationAddress = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);

    PlaceLocation updatedPickedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: locationAddress);

    final newPlace = Place(
      id: DateTime.now().toString(),
      image: pickedImage,
      title: pickedTitle,
      location: updatedPickedLocation,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image
          .path, //.path of course is important because you want to store the path to the image on your local hard drive in the device so to say and not the image file, you can't store the image file in the database.
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');

    _items = dataList
        .map(
          //we can call map on it to transform every element in there into a different element and call to list in the end to get back a list and then set items equal to that mapped list. So in map, we get every element, so here we get our item or whatever you want to call it and now we have to return a place object in the end.
          (item) => Place(
            id: item['id'],
            title: item['title'],
            location: PlaceLocation(
                address: item['address'],
                latitude: item['loc_lat'],
                longitude: item['loc_lng']),
            image: File(
              item['image'],
            ), //since I don't need the path, I need the full image instead, the file..then taht's why i converted it to File
          ),
        )
        .toList();

    notifyListeners();
  }

  Place findePlaceById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }
}
