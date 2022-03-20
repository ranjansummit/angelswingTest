

import 'package:angel_swing/model/areas.dart';
import 'package:angel_swing/networking/api_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../exceptions/no_internet.dart';
import '../model/location.dart';
import '../networking/api_response.dart';




class UserEssentialBloc {

  final repository = LocationRepo();
  int selected =-1;
  Location? selectedLocation;
  final areasUpdateStream = PublishSubject<ApiResponse<List<Location>>>();



  @mustCallSuper
dispose() async {


     print("login bloc is disposed");


    }

  getAreas() async {

    areasUpdateStream.sink.add(
      ApiResponse.loading('Profile Response'),
    );
    try {
      List<Location> locations = await repository.getLocations();
      areasUpdateStream.sink.add(
        ApiResponse.completed(locations),
      );
    } on NoInternetException catch (e) {
      areasUpdateStream.sink.add(
        ApiResponse.error(e.cause),
      );
      print(e.cause);
    }

    catch (e) {
      print("http exception");
      areasUpdateStream.sink.add(
        ApiResponse.error(kDebugMode?e.toString():"Something went wrong. Try again."),
      );
    }
  }





}


