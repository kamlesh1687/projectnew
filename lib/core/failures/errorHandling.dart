enum ErrorState { NoError, OnError }

class ErrorHandle<DataType> {
  ErrorState errorState;
  DataType data;
  String error;

  ErrorHandle({this.errorState, this.data, this.error});

  static ErrorHandle<DataType> noError<DataType>(DataType data) {
    return ErrorHandle(errorState: ErrorState.NoError, data: data);
  }

  static ErrorHandle<DataType> onError<DataType>(String error) {
    return ErrorHandle(errorState: ErrorState.OnError, error: error);
  }
}
