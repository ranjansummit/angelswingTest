import 'dart:convert';
import 'dart:io';

import '../exceptions/no_internet.dart';
import '../persistence/app_constants.dart';
import 'api_state.dart';
import 'network_utils.dart';



class ApiProvider {
  late ApiState apiState;
  Future<dynamic> getLocations() async {
    var response;
    Map<String, String> map = Map();

    try {
      response = await networkUtil.get(
          AppConstants.LOCATIONS, map);
    } on NoInternetException catch (e) {
      print("came in api provider throw");
      throw e;
    }
    if (response != null) {
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("sell publish api provider" + response.data.toString());
      }
    } else {
      throw Exception(" Something went wrong. Please try again");
    }
  }

}

