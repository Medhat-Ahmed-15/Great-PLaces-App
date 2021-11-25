import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/location_helper.dart';
import 'package:flutter_complete_guide/models/place.dart';
import 'package:flutter_complete_guide/screens/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function _selectedLocation;
  LocationInput(this._selectedLocation);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String
      _previewImageUrl; //here, we'll store a link a URL pointing at a preview image of that location we chose so a peview image of the map snapshot we chose and google has an api that creates such images on the fly

  bool loadingSpinner = false;

  void _showImageMap(double lat, double lng) {
    final previewImageUrl =
        LocationHelper.generateLocationPreview(latitude: lat, longitude: lng);

    setState(() {
      _previewImageUrl = previewImageUrl;
      loadingSpinner = false;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    setState(() {
      loadingSpinner = true;
    });
    try {
      final locData = await Location().getLocation();
      _showImageMap(locData.latitude, locData.longitude);
      widget._selectedLocation(PlaceLocation(
          latitude: locData.latitude,
          longitude: locData.longitude,
          address: ''));
    } catch (error) {
      loadingSpinner = true;
    }
  }

  Future<void> _selectOnMap() async {
    /*Now why do I return a future here and use async? Because you might remember that when we push a screen,

once that screen is popped, we can return data with pop and then listen to that here with a then method

or since I use async, simply with await.

So I wait for this map screen to be popped and I expect to get the selected location back or at least

that is what might happen,*/
    final LatLng selectedLocation = await Navigator.of(context).push(
      //here I should add the type annotation 'LatLng' infront of this because Dart is not able to infer it because I could be returning anything here , an alternative to adding it here after .push with angled brackets<> because this will then aslo tell dart that push in the end once that page you're loading is popped will give a you a latlng object
      MaterialPageRoute(
        fullscreenDialog:
            true, //add the full screen dialog argument and set this to true and then you'll get a different open animation and instead of the back button you have across, totally optional, just a different look
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showImageMap(selectedLocation.latitude, selectedLocation.longitude);
    widget._selectedLocation(PlaceLocation(
        latitude: selectedLocation.latitude,
        longitude: selectedLocation.longitude,
        address: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          child: _previewImageUrl == null
              ? loadingSpinner == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      'No location chosen',
                      textAlign: TextAlign.center,
                    )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
    );
  }
}
