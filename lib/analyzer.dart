import 'dart:io';

import 'package:assemble/dependency_checker.dart';
import 'package:assemble/dependency_graph.dart';
import 'package:yaml/yaml.dart';

void analyzeDependencies(bool checkOutdated, bool showGraph) {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('pubspec.yaml not found in the current directory.');
    return;
  }

  final pubspecContent = pubspecFile.readAsStringSync();
  final pubspecYaml = loadYaml(pubspecContent);

  print('Dependencies:');
  final dependencies = pubspecYaml['dependencies'] as YamlMap;
  if (dependencies != null) {
    dependencies.forEach((key, value) {
      print(' - $key: $value');
    });
  }

  if (checkOutdated) {
    final dependenciesMap = Map<String, dynamic>.from(dependencies);
    checkForOutdatedDependencies(dependenciesMap);
  }

  if (showGraph) {
    final graph = DependencyGraph.fromPubspec();
    graph.createGraphImage('dependency_graph.png'); // Create the graph image
  }
}
