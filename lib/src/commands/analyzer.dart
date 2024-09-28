import 'dart:io';

import 'package:assemble/src/commands/dependency_checker.dart';
import 'package:assemble/src/commands/dependency_graph.dart';
import 'package:assemble/src/commands/license_checker.dart'; // Import license_checker
import 'package:yaml/yaml.dart';

Future<void> analyzeDependencies(bool checkOutdated, bool showGraph, bool checkLicenses) async {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('pubspec.yaml not found in the current directory.');
    return;
  }

  final pubspecContent = pubspecFile.readAsStringSync();
  final pubspecYaml = loadYaml(pubspecContent);

  print('Dependencies:');
  final dependencies = pubspecYaml['dependencies'] as YamlMap;
  dependencies.forEach((key, value) {
    print(' - $key: $value');
  });

  if (checkOutdated) {
    final dependenciesMap = Map<String, dynamic>.from(dependencies);
    checkForOutdatedDependencies(dependenciesMap);
  }

  if (showGraph) {
    final graph = DependencyGraph.fromPubspec();
    graph.createGraphImage('dependency_graph.png'); // Create the graph image

  }
}