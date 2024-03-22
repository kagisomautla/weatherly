import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as Http;

dynamic httpGet({
  required String endpoint,
}) async {
  final Uri url = Uri.parse("${dotenv.env["API_URL"]}/$endpoint");

  final response = await Http.get(
    url,
    headers: {
      "content-type": "application/json",
    },
  );
  return response.body;
}
