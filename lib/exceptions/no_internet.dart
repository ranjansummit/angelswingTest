class NoInternetException implements Exception {
  String cause;
  NoInternetException(this.cause);
}

void main() {
  try {
    throwException();
  } on NoInternetException {
    print("custom exception has been obtained");
  }
}

throwException() {
  throw new NoInternetException('Check the internet connectivity and try again.');
}