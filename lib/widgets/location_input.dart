import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  Location? _pickedLocation;
  var _isGettinglocation = false;
  void _getCurrentLocation()async{

    Location location =  Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }


    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettinglocation = true;
    });

    locationData = await location.getLocation();

    setState(() {
      _isGettinglocation = false;
    });

  }
  @override
  Widget build(BuildContext context) {
    Widget previwcontent = Text(
      "No Location Chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
    if(_isGettinglocation){
      previwcontent = CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(

          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.2), // Use the Theme's color
            ),
          ),
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: previwcontent
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: Icon(Icons.location_on),
              onPressed: _getCurrentLocation,
              label: Text("Get Current Location",style: TextStyle(
                fontSize: 12
              ),),
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              onPressed: () {},
              label: Text("Select on Map",style: TextStyle(
                fontSize: 12
              ),),
            ),
          ],
        )
      ],
    );
  }
}
