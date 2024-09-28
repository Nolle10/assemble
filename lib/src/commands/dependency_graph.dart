import 'dart:io';
import 'package:yaml/yaml.dart';

class DependencyGraph {
  final Map<String, List<String>> _graph = {};

  void addDependency(String package, List<String> dependencies) {
    _graph[package] = dependencies;
  }

  // Method to create a PNG image of the dependency graph
  void createGraphImage(String outputPath) {
    final graph = StringBuffer();

    // Create the DOT representation of the graph
    graph.writeln('strict graph {');

    _graph.forEach((package, dependencies) {
      for (var dependency in dependencies) {
        graph.writeln('  "$package" -- "$dependency";');
      }
    });

    graph.writeln('}');

    // Write the DOT representation to a temporary file
    final dotFile = File('temp_graph.dot');
    dotFile.writeAsStringSync(graph.toString());

    // Use the dot command to generate a PNG image
    final result = Process.runSync('dot', ['-Tpng', 'temp_graph.dot', '-o', outputPath]);

    if (result.exitCode != 0) {
      print('Error generating PNG: ${result.stderr}');
    } else {
      print('Graph image created at: $outputPath');
    }

    // Optionally, remove the temporary DOT file
    dotFile.deleteSync();
  }

  // Function to create a dependency graph from pubspec.yaml
  static DependencyGraph fromPubspec() {
    final pubspecFile = File('pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      throw Exception('pubspec.yaml not found in the current directory.');
    }

    final pubspecContent = pubspecFile.readAsStringSync();
    final pubspecYaml = loadYaml(pubspecContent);

    final graph = DependencyGraph();
    final dependencies = pubspecYaml['dependencies'] as YamlMap;

    dependencies.forEach((package, value) {
      // For simplicity, we'll just use a placeholder for dependencies
      // You can extend this logic to include transitive dependencies as needed
      graph.addDependency(package, []); // Add actual dependencies if available
    });

    return graph;
  }
}
