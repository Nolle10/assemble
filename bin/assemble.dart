import 'package:args/args.dart';
import '../lib/analyzer.dart';

void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addCommand('analyze');
  parser.commands['analyze']!.addFlag('outdated', defaultsTo: false, help: 'Check for outdated dependencies');
  parser.commands['analyze']!.addFlag('graph', defaultsTo: false, help: 'Show dependency graph');

  final argResults = parser.parse(arguments);

  if (argResults.command?.name == 'analyze') {
    analyzeDependencies(argResults.command!['outdated'], argResults.command!['graph']);
  } else {
    print('Available commands:');
    print('  analyze - Analyze Flutter project dependencies');
  }
}
