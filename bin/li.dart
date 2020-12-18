import 'package:args/command_runner.dart';
import 'package:li/check_skia_shader.dart';
import 'package:li/count_name.dart';
import 'package:li/deflake.dart';
import 'package:li/engine_perf.dart';
import 'package:li/github.dart';
import 'package:li/remove_branch.dart';
import 'package:li/lock_timer.dart';

void main(List<String> args) {
  final CommandRunner<void> runner = CommandRunner<void>(
    'li',
    'Tools used by Yuqian Li.',
  );
  runner.addCommand(CheckSkiaShader());
  runner.addCommand(CountName());
  runner.addCommand(Deflake());
  runner.addCommand(EnginePerf());
  runner.addCommand(GithubCommand());
  runner.addCommand(RemoveBranch());
  runner.addCommand(LockTimer());
  runner.run(args);
}
