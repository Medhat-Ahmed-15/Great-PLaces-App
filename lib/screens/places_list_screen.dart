import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/great_places.dart';
import 'package:flutter_complete_guide/screens/add_place_screen.dart';
import 'package:flutter_complete_guide/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Places'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatPlaces>(
                  child: Center(
                    child: Text('Got no places yet, start adding some!'),
                  ),
                  builder: (ctx, objGreatPlaces, ch) => objGreatPlaces
                              .items.length <=
                          0
                      ? ch
                      : ListView.builder(
                          itemBuilder: (ctx, index) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  FileImage(objGreatPlaces.items[index].image),
                            ),
                            title: Text(objGreatPlaces.items[index].title),
                            subtitle: Text(
                                objGreatPlaces.items[index].location.address),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  PlaceDetailScreen.routeName,
                                  arguments: objGreatPlaces.items[index].id);
                            },
                          ),
                          itemCount: objGreatPlaces.items.length,
                        ),
                ),
        ));
  }
}
