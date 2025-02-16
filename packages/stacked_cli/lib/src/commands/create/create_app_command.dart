import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:stacked_cli/src/constants/command_constants.dart';
import 'package:stacked_cli/src/constants/message_constants.dart';
import 'package:stacked_cli/src/locator.dart';
import 'package:stacked_cli/src/services/analytics_service.dart';
import 'package:stacked_cli/src/services/colorized_log_service.dart';
import 'package:stacked_cli/src/services/config_service.dart';
import 'package:stacked_cli/src/services/file_service.dart';
import 'package:stacked_cli/src/services/process_service.dart';
import 'package:stacked_cli/src/services/template_service.dart';

class CreateAppCommand extends Command {
  final _cLog = locator<ColorizedLogService>();
  final _configService = locator<ConfigService>();
  final _fileService = locator<FileService>();
  final _processService = locator<ProcessService>();
  final _templateService = locator<TemplateService>();
  final _analyticsService = locator<AnalyticsService>();

  @override
  String get description =>
      'Creates a stacked application with all the basics setup';

  @override
  String get name => 'app';

  CreateAppCommand() {
    argParser.addFlag(
      ksV1,
      aliases: [ksUseBuilder],
      defaultsTo: null,
      help: kCommandHelpV1,
    );
    argParser.addOption(
      ksLineLength,
      abbr: 'l',
      help: kCommandHelpLineLength,
      valueHelp: '80',
    );
  }

  @override
  Future<void> run() async {
    await _configService.loadConfig();
    final appName = argResults!.rest.first;
    final appNameWithoutPath = appName.split('/').last;
    unawaited(_analyticsService.createAppEvent(name: appNameWithoutPath));
    _processService.formattingLineLength = argResults![ksLineLength];
    await _processService.runCreateApp(appName: appName);

    _cLog.stackedOutput(message: 'Add Stacked Magic ... ', isBold: true);

    await _templateService.renderTemplate(
      templateName: name,
      name: appNameWithoutPath,
      verbose: true,
      outputPath: appName,
      useBuilder: argResults![ksV1] ?? _configService.v1,
    );

    await _processService.runPubGet(appName: appName);
    await _processService.runBuildRunner(appName: appName);
    await _processService.runFormat(appName: appName);
    await _clean(appName: appName);
  }

  /// Cleans the project.
  ///
  ///   - Deletes widget_test.dart file
  ///   - Removes unused imports
  Future<void> _clean({required String appName}) async {
    _cLog.stackedOutput(message: 'Cleaning project...');

    // Removes `widget_test` file to avoid failing unit tests on created app
    await _fileService.deleteFile(
      filePath: '$appName/test/widget_test.dart',
      verbose: false,
    );

    // Analyze the project and write the output into a log file
    await _processService.runAnalyzeAndWriteLogFile(appName: appName);

    final issues = await _fileService.readFileAsLines(
      filePath: '$appName/$ksLogFile',
    );

    for (var i in issues) {
      if (!i.startsWith('[info] Unused import')) continue;

      final log =
          i.split(' ').last.replaceAll('(', '').replaceAll(')', '').split(':');

      await _fileService.removeLinesOnFile(
        filePath: log[0],
        linesNumber: [int.parse(log[1])],
      );
    }

    // Delete log file to clean the project
    await _fileService.deleteFile(
      filePath: '$appName/$ksLogFile',
      verbose: false,
    );

    _cLog.stackedOutput(message: 'Project cleaned.');
  }
}
