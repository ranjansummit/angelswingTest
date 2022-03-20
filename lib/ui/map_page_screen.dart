import 'dart:async';

import 'package:angel_swing/blocs/user_essential_bloc.dart';
import 'package:angel_swing/ui/custom_location_card.dart';
import 'package:angel_swing/model/location.dart';
import 'package:angel_swing/essential/notification_service.dart';
import 'package:angel_swing/persistence/angleswing_sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'google_map_screen.dart';
import '../networking/api_state.dart';

class MapPageScreen extends StatefulWidget {

  @override
  _MapPageScreenState createState() =>
      _MapPageScreenState( );
}

class _MapPageScreenState extends State<MapPageScreen> {
 late UserEssentialBloc bloc;
 late ApiState locationApiState;
 late String errormsg;
 int selected = -1;
 late bool loader = false;
   late List<Location> locations;
 // List<Marker> markers = [];
 //BitmapDescriptor pinLocationIcon;
 LatLng initPosition = LatLng(0, 0);
 LatLng currentLatLng = LatLng(0.0, 0.0);
 //LocationPermission permission = LocationPermission.denied;
 Position? position;

 @override
  void initState() {
   locations = [];
   SystemChrome.setPreferredOrientations([
     DeviceOrientation.portraitUp,
     DeviceOrientation.portraitDown,
   ]);
    super.initState();
  }
  void setLocation(index) {
   setState(() {
     bloc.selected = index;
     selected = index;
     bloc.selectedLocation=locations[index];
   });
 Navigator.pop(context);
  }
 void addLocation(location) {
   setState(() {
     locations.add(location);
     bloc.selected =3;
     selected = 3;
   });
 }

  @override
  void didChangeDependencies() {
    bloc = Provider.of<UserEssentialBloc>(context);
    bloc.getAreas();
    setState(() {
      loader = true;
    });



      bloc.areasUpdateStream.listen((value) {

        switch (value.status) {
          case ApiState.Loading:
            debugPrint("sabinTest loading");
            break;
          case ApiState.Success:
            if (value.data.isNotEmpty) {
              print("end of the data");
                setState(() {
                loader  = false;
                  locations = value.data;
                  preferences.setLocations( Location.encode(locations));

                });

            }

            break;
          case ApiState.Error:
            setState(() {
              locationApiState = ApiState.Error;
              errormsg = value.message;
              loader = false;
            });
            print("error message in loading" + value.message);
        }
      });


        print ("dipendency changed in parent");

      super.didChangeDependencies();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1F4782),
          title: Text('AngelSwing Demo'),
        ),
        drawer: Container(
          height: MediaQuery.of(context).size.height * 1,
          //height: 100,
          child:
          Drawer(
            backgroundColor: Color(0xffDFE0E2),
            child:  Container(
              child:
              ListView(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.135,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color(0xff1F4782),
                      ),
                      child:
                          Row (children: [  IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);

                      }),Text('AngelSwing'), ],)
                    ),
                  ),
                  locations.isEmpty? const Center():
                  SingleChildScrollView(
                    // Setting floatHeaderSlivers to true is required in order to float
                    // the outer slivers over the inner scrollable.
                    child:
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: locations.length,
                    itemBuilder: (contexts, index) {
                      return
                          LocationCard( locationclickCallback:(location, index) { setLocation(index);}, location: locations[index], selectedIndex: index);

                    },
                  ),

                  ),
                ],
              ),
            ),

        )),
        body:
        Stack(children:  [
          locations.isEmpty?
              Center():
          MapSample(locationclickCallback:(location){addLocation(location);},locationList: locations,selected: selected, ),
          loader == true
              ?
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  // backgroundColor: AppColor.yellow,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Loading',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
              : const Center(),

        ])
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   static const String _title = 'Flutter Code Sample';
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: _title,
//       home: MyStatelessWidget(),
//     );
//   }
// }
//
