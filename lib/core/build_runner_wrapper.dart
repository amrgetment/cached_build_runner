import 'dart:io';

import 'package:cached_build_runner/model/code_file.dart';
import 'package:cached_build_runner/utils/logger.dart';
import 'package:cached_build_runner/utils/utils.dart';

class BuildRunnerWrapper {
  const BuildRunnerWrapper();

  Future<bool> runBuild(List<CodeFile> files) async {
    if (files.isEmpty) return true;
    Logger.header(
      'Generating Codes for non-cached files, found ${files.length} files',
    );

    Logger.v('Running build_runner build...', showPrefix: false);

    final filterList = _getBuildFilterList(files);

    Logger.d(
      'Run: "flutter pub run build_runner build --build-filter $filterList"',
    );
    final process = await Process.start(
      'flutter',
      [
        'pub',
        'run',
        'build_runner',
        'build',
        '--delete-conflicting-outputs',
        '--build-filter',
        filterList,
      ],
      workingDirectory: Utils.projectDirectory,
      runInShell: true,
    );

    /// Listen to the standard output (stdout) of the process.
    /// - If the log is an elapsed-time `[INFO]` log (e.g., `[INFO] 2m 10s elapsed, 946/1016 actions completed.`),
    ///   it updates the same line instead of printing a new one.
    /// - All other logs are printed normally.
    process.stdout.transform(const SystemEncoding().decoder).listen((data) {
      // Regex pattern to match only elapsed-time logs
      final elapsedTimeLogPattern =
          RegExp(r'\[INFO\] \d+m \d+s elapsed, \d+/\d+ actions completed\.');

      if (elapsedTimeLogPattern.hasMatch(data)) {
        stdout.write(
          '\r$data',
        ); // Overwrites the previous line with the latest progress
      } else {
        print(data); // Prints normally for other logs
      }
    });

    process.stderr.transform(const SystemEncoding().decoder).listen((data) {
      if (data.trim().isNotEmpty) {
        Logger.e('Error: $data');
      }
    });

    final exitCode = await process.exitCode;
    Logger.d('Process exited with code: $exitCode');

    return exitCode == 0;
  }

  /// Returns a comma-separated string of the file paths from the given list of [CodeFile]s
  /// formatted for use as the argument for the --build-filter flag in the build_runner build command.
  ///
  /// The method maps the list of [CodeFile]s to a list of generated file paths, and then
  /// returns a comma-separated string of the generated file paths.
  ///
  /// For example:
  ///
  /// final files = [CodeFile(path: 'lib/foo.dart', digest: 'abc123')];
  /// final buildFilter = _getBuildFilterList(files);
  /// print(buildFilter); // 'lib/foo.g.dart'.
  String _getBuildFilterList(List<CodeFile> files) {
    final paths = files.map<String>((x) => x.getGeneratedFilePath()).toList();

    return paths.join(',');
  }
}
