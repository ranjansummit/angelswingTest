
import 'package:angel_swing/blocs/user_essential_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/location.dart';

typedef void LocationclickCallback(Location location,int index);

class LocationCard extends StatefulWidget {
  final LocationclickCallback locationclickCallback;
  final int selectedIndex;
  final Location location;
  LocationCard({ required this.locationclickCallback, required this.location,required this.selectedIndex });
  @override
  CustomPropertyState createState() =>
      CustomPropertyState(locationclickCallback: this.locationclickCallback , location:this.location,selected_index: this.selectedIndex);
}

class CustomPropertyState extends State<LocationCard> {
  Function locationclickCallback;
 Location location;
 int selected_index;
 late UserEssentialBloc userEssentialBloc;
  CustomPropertyState({required this.locationclickCallback,required this.location,required this.selected_index});
  @override
  void initState() {


    // TODO: implement initState
    super.initState();

  }

@override
  void didChangeDependencies() {
  userEssentialBloc = Provider.of<UserEssentialBloc>(context);

  print ("came here");
  // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return
      ListTile(
        title: GestureDetector(
          onTap: () {

            locationclickCallback(location,selected_index);
            // initState();

          },
          child: Container(
            color: userEssentialBloc.selected== selected_index ?  Color(0xffC6DFFC) : Colors.white,
            width: MediaQuery.of(context).size.width * 100,
            child:
            Padding(
              padding: EdgeInsets.all(5.0),
              child:
              RichText(
                maxLines: 6,
                text:  TextSpan(
                    text: 'Location ${selected_index+1}',
                    style: TextStyle(
                        fontSize: 15, color: Colors.black54),
                    children: <TextSpan>[
                      TextSpan(
                        text: '\n\nLat:  ${location.latitude}'   ,
                        style: TextStyle(
                            fontSize: 20, color: Colors.black),
                      ),
                      TextSpan(
                        text:  '\n\nLong:  ${location.longitude}',
                        style: TextStyle(
                            fontSize: 20, color: Colors.black),
                      ),
                    ]),
              ),
            ),

          ),
        ),
      );


  }



}