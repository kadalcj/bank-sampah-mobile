import 'dart:convert';
import 'package:bank_sampah_mobile/model/trash.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TrashRepository {
  final uri = 'http://bank-sampah-api.herokuapp.com/api/';

  // Get User Trash
  Future<Trash> getTrash() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final userId = _prefs.getString('_id');

    final response = await http.Client().get(uri + 'trash/' + userId);

    if (response.statusCode != 200) {
      throw Exception();
    }

    return Trash.fromJson(json.decode(response.body));
  }
}
