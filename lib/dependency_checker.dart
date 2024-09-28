import 'dart:async';
import 'version_fetcher.dart';

Future<void> checkForOutdatedDependencies(Map<String, dynamic> dependencies) async {
  print('Checking for outdated dependencies...');

  if (dependencies.isEmpty) {
    print('No dependencies found.');
    return;
  }

  for (var entry in dependencies.entries) {
    final packageName = entry.key;
    final currentVersion = entry.value.toString().split('^')[1];

    // Fetch the latest version from pub.dev
    final latestVersion = await getLatestVersion(packageName);

    if (latestVersion != null && currentVersion != latestVersion) {
      print(' - $packageName: $currentVersion (latest: $latestVersion)');
    }
  }
}
