class ResponseModel {
  final bool _isSuccess;
  final String _message;
  //Private variables can't be wrapped around curly braces like we did in other models
  ResponseModel(this._isSuccess, this._message);

  //Privaet variables need a getter just like C++
  String get message => _message;
  bool get isSuccess => _isSuccess;
}
