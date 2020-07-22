class Result<T> {
  bool _isOk = false;

  String _error = '';

  String _message = '';

  T _data;

  Result({bool isOk, String error, String message , T data}) {
    this._isOk = isOk;
    this._error = error;
    this._data = data;
    this._message = message;
  }

  bool get isOk => _isOk;

  String get error => _error;

  T get data => _data;

  String get message => _message;
}
