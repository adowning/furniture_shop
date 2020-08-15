import 'dart:convert';

import 'package:app/global.dart';
import 'package:app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

enum LoginStatus { loading, idle, loggedIn, error }

class AuthService with ChangeNotifier {
  String _error = "";
  LoginStatus _status = LoginStatus.idle;
  String _token;
  User _user;
  String get token => _token;
  String get error => _error;
  LoginStatus get status => _status;
  User get user => _user;

  clear() {
    _error = "";
    _status = LoginStatus.idle;
    _token = "";
    _user = null;
    notifyListeners();
  }

  Future<bool> login({username, password}) async {
    _status = LoginStatus.loading;
    notifyListeners();
    final response = await http.post(
      "$baseServerUrl/auth/local",
      body: jsonEncode({
        'identifier': '$username',
        'password': '$password',
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['jwt'];
      final user = jsonDecode(response.body)['user'];
      await saveToken(token);
      await saveUser(user);
      return true;
    } else {
      _status = LoginStatus.error;
      _error = response.body;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup({email, password, username}) async {
    _status = LoginStatus.loading;
    notifyListeners();
    final response = await http.post(
      "$baseServerUrl/auth/local/register",
      body: jsonEncode({
        "username": "$username",
        'email': '$email',
        'password': '$password',
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['jwt'];
      await saveToken(token);
      return true;
    } else {
      _status = LoginStatus.idle;
      notifyListeners();
      return false;
    }
  }

  Future saveToken(token) async {
    final _storage = FlutterSecureStorage();
    await _storage.write(key: "token", value: token);
    _status = LoginStatus.loggedIn;
    _token = token;
    notifyListeners();
    return;
  }

  Future saveUser(user) async {
    final _storage = FlutterSecureStorage();
    await _storage.write(key: "user", value: jsonEncode(user));
    _user = User.fromJson(user);
    notifyListeners();
    return;
  }

  Future getSavedUser() async {
    final _storage = FlutterSecureStorage();
    String user = await _storage.read(key: "user");

    if (_user != null) {
      _user = jsonDecode(user);
      notifyListeners();
    } else {
      _user = null;
      notifyListeners();
    }
  }

  Future getSavedToken() async {
    final _storage = FlutterSecureStorage();
    _token = await _storage.read(key: "token");
    if (_token != null) {
      _status = LoginStatus.loggedIn;
      notifyListeners();
    } else {
      _status = LoginStatus.idle;
      notifyListeners();
    }
  }

  logout() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: "token");
    _status = LoginStatus.idle;
    notifyListeners();
  }
}
