import 'dart:convert';
import 'package:http/http.dart' as http;

class CatApiService {
  static const String _baseUrl = 'https://api.thecatapi.com/v1/images/search';
  
  // Fungsi untuk mendapatkan gambar kucing dari API
  Future<List<String>> fetchCatImages({int limit = 5}) async {
    final response = await http.get(Uri.parse('$_baseUrl?limit=$limit'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      List<String> images = data.map((cat) => cat['url'] as String).toList();
      return images;
    } else {
      throw Exception('Failed to load cat images');
    }
  }
}
