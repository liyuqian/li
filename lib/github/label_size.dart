import 'package:li/github/apply_label.dart' show ApplyLabelHandler;
import 'package:li/github/base.dart';

class LabelSizeCommand extends GithubClientCommand {
  LabelSizeCommand() {
    argParser.addOption(
      _kOptionMaxCount,
      defaultsTo: '1',
      help: 'max number of issues to be labeled',
    );
  }

  @override
  String get description =>
      'add label "$_kLabelPerfAppSize" to all issues with label "$_kLabelPerfAppSize"';

  @override
  String get name => 'label_size';

  @override
  Future<void> runWithClientReady() async {
    final int maxCount = int.parse(argResults[_kOptionMaxCount]);
    final handler = ApplyLabelHandler(client, maxCount, isVerbose);
    await handler.apply(_kLabelASize, _kLabelPerfAppSize);
  }

  static const String _kOptionMaxCount = 'max-count';
  static const String _kLabelASize = 'a: size';
  static const String _kLabelPerfAppSize = 'perf: app size';
}
