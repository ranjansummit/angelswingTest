class HttpException implements Exception {
  String cause;
  HttpException(this.cause);
}

void main() {
  try {
    throwException();
  } on HttpException {
    print("custom  http exception has been obtained");
  }
}

throwException() {
  throw new HttpException('Check the internet connectivity and try again.');
}