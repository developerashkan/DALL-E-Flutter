import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class OpenAIService {
  static const String _apiKey = "YourApiKey";
  static const String _url = "https://api.openai.com/v1/images/generations";

  Future<String> generateImage(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "prompt": prompt,
          "n": 1,
          "size": "256x256",
        }),
      ).timeout(const Duration(seconds: 30));

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonResponse["data"][0]["url"];
      } else {
        final errorMessage = jsonResponse["error"]?["message"] ?? "Unknown API Error";
        throw Exception(errorMessage);
      }
    } catch (e) {
      developer.log("DALL-E API Error", error: e);
      throw Exception("Failed to generate image: $e");
    }
  }
}
