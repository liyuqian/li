import 'package:args/command_runner.dart';
import 'package:li/check_skia_shader.dart';
import 'package:li/remove_branch.dart';

void main(List<String> args) {
  final CommandRunner<void> runner = CommandRunner<void>(
    'li',
    'Tools used by Yuqian Li.',
  );
  runner.addCommand(CheckSkiaShader());
  runner.addCommand(RemoveBranch());
  runner.run(args);
}
