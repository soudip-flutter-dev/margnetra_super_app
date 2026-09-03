class AppExceptionHandler implements Exception{
  String exTitle, exMsg;
  AppExceptionHandler({required this.exTitle, required this.exMsg});

  @override
  String toString() {
    return "$exTitle : $exMsg";
  }
}

class NoInternetException extends AppExceptionHandler {
  NoInternetException({required String msg})
      : super(exTitle: "No Internet", exMsg: msg);
}

class ServerException extends AppExceptionHandler {
  ServerException({required String msg})
      : super(exTitle: "Server Error", exMsg: msg);
}

class BadRequestException extends AppExceptionHandler {
  BadRequestException({required String msg})
      : super(exTitle: "Bad Request", exMsg: msg);
}


class UnauthorizedException extends AppExceptionHandler {
  UnauthorizedException({required String msg})
      : super(exTitle: "Unauthorized", exMsg: msg);
}


class NotFoundException extends AppExceptionHandler {
  NotFoundException({required String msg})
      : super(exTitle: "Not Found", exMsg: msg);
}


class InvalidInputException extends AppExceptionHandler {
  InvalidInputException({required String msg})
      : super(exTitle: "Invalid Input", exMsg: msg);
}


class FetchDataException extends AppExceptionHandler {
  FetchDataException({required String msg})
      : super(exTitle: "Error During Communication", exMsg: msg);
}