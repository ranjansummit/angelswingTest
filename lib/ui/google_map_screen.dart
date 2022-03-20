import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import '../essential/asi_icon.dart';
import '../blocs/user_essential_bloc.dart';
import '../networking/api_state.dart';
import '../model/location.dart';

typedef void onMarkedLocation(Location location);

class MapSample extends StatefulWidget {
  final onMarkedLocation locationclickCallback;


  List <Location> locationList=[];
  int selected =-1 ;
  MapSample({required this.locationclickCallback,required this.locationList, required this.selected });

  @override
  State<MapSample> createState() => MapSampleState(onLocationCallback: locationclickCallback,locations:locationList,selected:selected);
}

class MapSampleState extends State<MapSample> {
  late UserEssentialBloc bloc;
  late ApiState locationApiState;
  late String errormsg;
  late bool loader = false;
   Uint8List? blueicon;
   Uint8List? redIcon;
  Uint8List? current;
  LatLng initPosition = LatLng(0, 0);
  LatLng currentLatLng = LatLng(0.0, 0.0);
  Position? position;
  Position? markedPosition;
  Function onLocationCallback;
   CameraPosition? _kGooglePlex;
  int selected=-1;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapController? _controller ;

  List<Location> locations;
  MapSampleState({required this.onLocationCallback,required this.locations, required this.selected });
  @override
  void didChangeDependencies() {
    bloc = Provider.of<UserEssentialBloc>(context);
    setCustomMarker();
      super.didChangeDependencies();
  }





  void _currentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location Service is disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'You denied the permission');
      }
      Position currentposition = await Geolocator.getCurrentPosition();
      setState(() {
        position = currentposition;

        var markerIdVal = 4.toString();
        final MarkerId markerId = MarkerId(markerIdVal);

        Marker? marker;
        // creating a new MARKER
        if(position!=null) {
          marker = Marker(
          icon: BitmapDescriptor.fromBytes(current!),
          markerId: markerId,
          position: LatLng(position!.latitude, position!.longitude),
          infoWindow: InfoWindow(title: markerIdVal, snippet: 'Angleswing'),
        );
          var newPosition = CameraPosition(
              target: LatLng(position!.latitude, position!.longitude),
              zoom: 16);


          CameraUpdate cameraUpdate =CameraUpdate.newCameraPosition(newPosition);

          _controller!.moveCamera(cameraUpdate);

        }




        setState(() {

          // adding a new marker to map
          if(marker!=null) {
            markers[markerId] = marker;
          }
        });


      });
    }
    else
      {
        Position currentposition = await Geolocator.getCurrentPosition();
        setState(() {
          position = currentposition;

          var markerIdVal = 4.toString();
          final MarkerId markerId = MarkerId(markerIdVal);

          Marker? marker;
          // creating a new MARKER
          if(position!=null) {
            marker = Marker(
              icon: BitmapDescriptor.fromBytes(current!),
              markerId: markerId,
              position: LatLng(position!.latitude, position!.longitude),
              infoWindow: InfoWindow(title: markerIdVal, snippet: 'Angleswing'),
            );
            var newPosition = CameraPosition(
                target: LatLng(position!.latitude, position!.longitude),
                zoom: 16);


            CameraUpdate cameraUpdate =CameraUpdate.newCameraPosition(newPosition);

            _controller!.moveCamera(cameraUpdate);

          }




          setState(() {

            // adding a new marker to map
            if(marker!=null) {
              markers[markerId] = marker;
            }
          });


        });

      }

  }


  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec =
    await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
  }


  late BitmapDescriptor pinkMarker;
  late BitmapDescriptor bluemarker;

  void setCustomMarker() async {
    pinkMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/pinkpin.png');
    bluemarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/bluepin.png');

  }



  @override
  void initState() {
setState(() {
  _kGooglePlex = const CameraPosition(
    target: LatLng(37.56755685, 126.97328373),
    zoom: 16,
  );
});
super.initState();

  }

  @override
didUpdateWidget (covariant MapSample oldWidget)   {
    if(bloc.selected!=-1)
    {

      locations.asMap().forEach((i, location) async {



        var markerIdVal = i.toString();
        final MarkerId markerId = MarkerId(markerIdVal);


        // creating a new MARKER
        final Marker marker = Marker(
          icon: BitmapDescriptor.fromBytes(i==bloc.selected?blueicon!:redIcon!),
          markerId: markerId,
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: markerIdVal, snippet: 'Angleswing'),
        );

        setState(() {
          // adding a new marker to map
          if(bloc.selectedLocation !=null)
         {

           var newPosition = CameraPosition(
               target: LatLng(bloc.selectedLocation!.latitude, bloc.selectedLocation!.longitude),
               zoom: 16);
           CameraUpdate cameraUpdate =CameraUpdate.newCameraPosition(newPosition);

           _controller!.moveCamera(cameraUpdate);

         }
          markers[markerId] = marker;
        });

      });

    }

    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {

      locations.asMap().forEach((i, location) async {

       _controller = controller;


          var markerIdVal = i.toString();
          final MarkerId markerId = MarkerId(markerIdVal);
         redIcon= await getBytesFromAsset('images/pinkpin.png', 100);
        blueicon = await getBytesFromAsset('images/bluepin.png', 100);
          current = await getBytesFromAsset('images/gomap.png', 100);


          // creating a new MARKER
          final Marker marker = Marker(
            icon: BitmapDescriptor.fromBytes(redIcon!),
            markerId: markerId,
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(title: markerIdVal, snippet: 'Angleswing Branch'),
          );

          setState(() {
            // adding a new marker to map
            markers[markerId] = marker;
          });

      });

    });
  }



markLocation()
{
  if (position!=null) {

    var markerIdVal = 3.toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    Marker? marker;
    // creating a new MARKER
    if(position!=null) {
      marker = Marker(
        icon: BitmapDescriptor.fromBytes(redIcon!),
        markerId: markerId,
        position: LatLng(position!.latitude, position!.longitude),
        infoWindow: InfoWindow(title: markerIdVal, snippet: 'Angleswing'),

      );
    }

    setState(() {
      // adding a new marker to map
      if(marker!=null) {
        markers[markerId] = marker;
      }
    });
    onLocationCallback(Location(position!.latitude,position!.longitude));
    setState(() {
      bloc.selectedLocation = Location(position!.latitude,position!.longitude);
      bloc.selected = 3;
    });
  }
  else
  {
    Fluttertoast.showToast(msg: 'First set the currnt adress');

  }

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        markers: markers.values.toSet(),
        padding: EdgeInsets.only(bottom: 450),
        initialCameraPosition: _kGooglePlex!,
        onMapCreated: _onMapCreated,
      ),
      floatingActionButton: Stack(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            left: 195,
            bottom: 0,
            child: SizedBox(
              height: 45.0,
              width: 45.0,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: Color(0xff1F4782),
                  elevation: 0.0,
                  onPressed:() {

                    markLocation();
                  } ,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 1.0,
            bottom: 0,
            child: SizedBox(
              height: 45,
              width: 45,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: Color(0xff1F4782),
                  elevation: 0.0,
                  onPressed:_currentLocation,
                  child: Icon(
                    ASIcons.location_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

        ],
      ),

    );
  }

}