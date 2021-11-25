import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/place.dart';
import 'package:flutter_complete_guide/providers/great_places.dart';
import 'package:flutter_complete_guide/screens/map_screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const String routeName = '/PlaceDetailScreen';

  @override
  Widget build(BuildContext context) {
    final placeId = ModalRoute.of(context).settings.arguments;

    Place currentPlace =
        Provider.of<GreatPlaces>(context).findePlaceById(placeId);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentPlace.title),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            child: Image.file(
              currentPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 20),
          Text(
            currentPlace.location.address,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => MapScreen(
                    initialLocation: currentPlace.location,
                    isSelecting: false,
                  ),
                ),
              );
            },
            child: Text(
              'Show on map',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
