/// Stores all the commands used throughout the app that

const String ksDart = 'dart';
const String ksFlutter = 'flutter';
const String ksCreate = 'create';
const String ksRun = 'run';
const String ksPub = 'pub';
const String ksGet = 'get';
const String ksFormat = 'format';
const String ksBuild = 'build';
const String ksBuildRunner = 'build_runner';
const String ksDeleteConflictingOutputs = '--delete-conflicting-outputs';
const String ksExcludeRoute = 'exclude-route';
const String ksV1 = 'v1';
const String ksUseBuilder = 'use-builder';
const String ksLineLength = 'line-length';
const String ksExcludeDependency = 'exclude-dependency';
const String ksCurrentDirectory = '.';
const String ksGlobal = 'global';
const String ksActivate = 'activate';
const String ksStackedCli = 'stacked_cli';
const String ksAnalyze = 'analyze';
const String ksWrite = '--write';
const String ksLogFile = '.stacked.analyze.log';

/// A list of strings that are used to run the pub run build runner build --delete-conflicting-outputs command.
const List<String> buildRunnerArguments = [
  ksPub,
  ksRun,
  ksBuildRunner,
  ksBuild,
  ksDeleteConflictingOutputs,
];

/// A list of strings that are used to run the pub get command.
const List<String> pubGetArguments = [ksPub, ksGet];

/// A list of strings that are used to run the pub global command.
const List<String> pubGlobalArguments = [
  ksPub,
  ksGlobal,
  ksActivate,
  ksStackedCli
];

/// A list of strings that are used to run the analyze command.
const List<String> analyzeArguments = [ksAnalyze, ksWrite, ksLogFile];
