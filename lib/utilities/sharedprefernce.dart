import 'package:shared_preferences/shared_preferences.dart';

String _userkey = "userkey";
String _acctkey = "acctkey";

class UserPreference {
  static late SharedPreferences _prefs;

  static Future init() async => _prefs = await SharedPreferences.getInstance();

  static Future saveuser(list) async => _prefs.setStringList(_userkey, list);

  static List<String>? getuser() => _prefs.getStringList(_userkey);

  static Future saveacct(ewallet) async => _prefs.setString(_acctkey, ewallet);

  static String? getacct() => _prefs.getString(_acctkey);
}

String? sessionid;
Future<String?> loaddata() async {
  SharedPreferences perfs = await SharedPreferences.getInstance();
  sessionid = perfs.getString("name") ?? "";
  return sessionid;
}

Future removedata(name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(name);
}

savedata(String name) async {
  SharedPreferences perfs = await SharedPreferences.getInstance();
  perfs.setString("name", name);
}

List<String>? chatid = [];
Future<List<String>?> loadchat() async {
  SharedPreferences perfs = await SharedPreferences.getInstance();
  chatid = perfs.getStringList("list") ?? [];
  return chatid;
}

meetdetails(List<String> meet) async {
  SharedPreferences perfs = await SharedPreferences.getInstance();
  perfs.setStringList("list", meet);
}
