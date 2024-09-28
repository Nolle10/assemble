import 'dart:convert'; // Add this for JSON handling
import 'package:http/http.dart' as http; // Import http for API requests

Future<String?> getLatestVersion(String packageName) async {
  final url = 'https://pub.dev/api/packages/$packageName';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['latest']['version'];
  } else {
    print('Failed to fetch latest version for $packageName. Status code: ${response.statusCode}');
    return null;
  }
}
