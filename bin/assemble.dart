import 'package:args/args.dart';
import 'package:assemble/src/commands/analyzer.dart';

void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addCommand('analyze');
  parser.commands['analyze']!.addFlag('outdated', defaultsTo: false, help: 'Check for outdated dependencies');
  parser.commands['analyze']!.addFlag('graph', defaultsTo: false, help: 'Show dependency graph');
  parser.commands['analyze']!.addFlag('licenses', defaultsTo: false, help: 'Show licenses for dependencies');

  final argResults = parser.parse(arguments);

  if (argResults.command?.name == 'analyze') {
    analyzeDependencies(argResults.command!['outdated'], argResults.command!['graph'], argResults.command!['licenses']);
  } else {
    print('Available commands:');
    print('  analyze - Analyze Flutter project dependencies');
  }
}
