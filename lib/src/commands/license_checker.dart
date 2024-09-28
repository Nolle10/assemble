import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:yaml/yaml.dart';

final List<String> acceptableLicenses = [
  'MIT',
  'Apache 2.0',
  'BSD',
  'GPL',
  'LGPL',
];

Future<void> getLicenses(String commercialFlag) async {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('pubspec.yaml not found in the current directory.');
    return;
  }

  final pubspecContent = await pubspecFile.readAsString();
  final pubspecYaml = loadYaml(pubspecContent);
  
  // Assuming dependencies are in 'dependencies' section
  final dependencies = pubspecYaml['dependencies'] as YamlMap;

  print('Checking licenses for dependencies:');
  for (var entry in dependencies.entries) {
    final packageName = entry.key;
    final currentVersion = entry.value.toString();
    
    String? license;
    if (commercialFlag.toLowerCase() == 'commercial') {
      license = await scrapeLicenseFromPubDev(packageName);
    } else {
      license = await getLicenseFromAPI(packageName);
    }

    if (license != null) {
      final isCommercial = acceptableLicenses.contains(license);
      print(' - $packageName: $currentVersion (License: $license) ${isCommercial ? '(Commercial Use Allowed)' : '(Commercial Use Not Allowed)'}');
    } else {
      print(' - $packageName: $currentVersion (License information not found)');
    }
  }
}

Future<String?> scrapeLicenseFromPubDev(String packageName) async {
  final url = 'https://pub.dev/packages/$packageName';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final document = htmlParser.parse(response.body);
    final licenseElement = document.querySelector('p:contains("License") + p');

    if (licenseElement != null) {
      return licenseElement.text.trim(); // Return the license text
    } else {
      print('License element not found for $packageName');
      return null;
    }
  } else {
    print('Failed to fetch page for $packageName. Status code: ${response.statusCode}');
    return null;
  }
}

Future<String?> getLicenseFromAPI(String packageName) async {
  final url = 'https://pub.dev/api/packages/$packageName';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['license'] ?? 'Unknown License';
  } else {
    print('Failed to fetch license for $packageName. Status code: ${response.statusCode}');
    return null;
  }
}