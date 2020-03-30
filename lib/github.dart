import 'package:args/command_runner.dart';
import 'package:li/github/apply_label.dart';
import 'package:li/github/label_size.dart';

class GithubCommand extends Command {
  GithubCommand() {
    addSubcommand(LabelSizeCommand());
    addSubcommand(ApplyLabelCommand());
  }

  @override
  String get description => 'github related commands';

  @override
  String get name => 'github';
}
