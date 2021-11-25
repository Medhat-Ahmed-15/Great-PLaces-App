//this file should then be responsible for making all these requests to Google APIs.

import 'dart:convert';

import 'package:http/http.dart' as http;

const GOOGLE_API_KEY =
    'AIzaSyATU6aBpWtbICW95boR1fYJre0iUFHq4EU'; //responsible for making requests

class LocationHelper {
  static String generateLocationPreview({double latitude, double longitude}) {
    //I got this url from site 'maps static api' but I removed some parts from it and it's responsible for previewing image urland its just this url nothing else I need
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    //It'll be a async function because in here, I'll now actually send a HTTP request to Google's servers because Google has another API which doesn't give us such an on the fly URL though but which actually gives us a URL to which we can send such a coordinate pair to get back a human readable address.
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(Uri.parse(url));
    Map responseData = json.decode(response.body);
    return responseData['results'][0][
        'formatted_address']; //on this map 'responseData map', you'll have a results key and you can always print this here if you want to look into it or place a breakpoint here and start this in debugging mode. So we'll have a results key in there and there, we'll have multiple results, at least one, so we'll access the first entry Google returns us because it might find multiple addresses but it will order them by relevance. So the first one should be the most relevant one and then here we want to get the formatted address field and make sure you have no typo in there because that is a field you'll have in the response data and this should be the human readable address we want.
  }
}
