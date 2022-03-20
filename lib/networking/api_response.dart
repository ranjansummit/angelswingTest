
import 'api_state.dart';

class ApiResponse<T> {
 late ApiState status;

 late T data;

  late String message;

    ApiResponse.loading(this.message) : status = ApiState.Loading;

  ApiResponse.completed(this.data) : status = ApiState.Success;

  ApiResponse.error(this.message) : status = ApiState.Error;


  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}