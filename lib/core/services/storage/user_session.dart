

//PROVIDER
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


//shared prefs provider
final sharedPreferencesProvider = Provider<SharedPreferences> ((ref){
  throw UnimplementedError("shared prefs lai hamle main.dart ma initialize garinxa,so tmi dhukka basa sir dinu hunxa hai");
});

final userSessionServiceProvider =Provider <UserSessionServices>((ref) {
  return UserSessionServices(prefs: ref.read(sharedPreferencesProvider));
});

class UserSessionServices{
  final SharedPreferences _prefs;

  UserSessionServices({required SharedPreferences prefs}) : _prefs = prefs;

  //keys for stroing data
  static const String _keysIsLoggedIn='is_logged_in';
  static const String _keyUserId='user_id';
  static const String _keyUserEmail='user_email';
  static const String _keyUserName='user_name';
  static const String _keyUserRole='user_role';

// Store user session data

Future<void> saveUserSession({
required String userId,
required String email,
required String username,
String role = 'user'


}) async {
await _prefs.setBool(_keysIsLoggedIn, true);
await _prefs.setString(_keyUserId, userId);
await _prefs.setString(_keyUserEmail, email);
await _prefs.setString(_keyUserName, username);
await _prefs.setString(_keyUserRole, role);

}

  Future<void> clearUserSession() async{
    await _prefs.remove(_keysIsLoggedIn);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserName);
    await _prefs.remove(_keyUserRole);
 
  }

  bool isLoggedIn(){
    return _prefs.getBool(_keysIsLoggedIn) ?? false;
  }
  String? getUserId(){
    return _prefs.getString(_keyUserId);
  }

  String? getUserEmail() {
  return _prefs.getString(_keyUserEmail);
  }

  String? getFullName() {
  return _prefs.getString(_keyUserName);
  }

  String? getUserRole() {
    return _prefs.getString(_keyUserRole);
  }

}