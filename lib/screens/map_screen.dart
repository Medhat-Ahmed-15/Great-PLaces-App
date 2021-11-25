import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation
      initialLocation; //since I want to use this maps screen here also to show the picked location and not just to pick a new location. So therefore on the maps screen widget, I expect to get an initial location and the type for that should actually be of type place location which we set up in our models folder
  final bool
      isSelecting; //information whether we are selecting a place, so that's a boolean or whether we're maybe just showing up already in selected place.So whether I want to let the user tap on the map and select a new place or whether it's a read-only map so to say.

  MapScreen(
      {this.initialLocation = const PlaceLocation(
          latitude: 40.730610, longitude: -73.935242, address: 'New York city'),
      this.isSelecting =
          false}); //the curly brackets to set it optional and set deafult values

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selecctLocation(LatLng position) {
    //So we get this position parameter by Google upon such a tap, so by the Google Maps plugin, it gives us this position of the tap automatically, the coordinates of the tap
    setState(() {
      //here in select location, I just want to call set state because of course, I want to rebuild this, I want to add a marker after all and that marker should be visible, so we need to re-render or rebuild that widget
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
        actions: widget.isSelecting == false
            ? []
            : [
                IconButton(
                    onPressed: _pickedLocation == null
                        ? null
                        : () {
                            Navigator.of(context).pop(_pickedLocation);
                          },
                    icon: Icon(Icons.check))
              ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialLocation.latitude,
              widget.initialLocation.longitude),
          zoom: 16,
        ),
        onTap: widget.isSelecting == true
            ? _selecctLocation //hna automatic 2wl ma ba tap fee location bayatba3t bal makan el hatat fee marker lal method dee el bata5od asln location
            : null, //since i tapped here it will rebuild because this function contains setState so it will go to this function Know if there is pickedLocation and rebuild to also show the marker

        markers: _pickedLocation == null && widget.isSelecting == true
            //here i used new feature which is (Set) see the notes I made in this video which is 308 to remember it
            ? {}
            : {
                Marker(
                    markerId: MarkerId('m1'),
                    position: widget.isSelecting == false
                        ? LatLng(widget.initialLocation.latitude,
                            widget.initialLocation.longitude)
                        : _pickedLocation)
              },
      ),
    );
  }
}
