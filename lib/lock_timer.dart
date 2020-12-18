import 'dart:async';
import 'dart:io';

import 'package:li/single_arg.dart';

class LockTimer extends SinglePositionalArgCommand {
  @override
  String get argName => 'minutes';

  @override
  String get description =>
      'Lock the screen after a timeout (even with active use)';

  @override
  String get name => 'lock_timer';

  @override
  FutureOr<void> runWithSingleArg(String arg) async {
    final minutes = int.parse(arg);
    if (minutes < 3) {
      throw 'We only support a timeout of at least 3 minutes.';
    }
    final duration = Duration(minutes: int.parse(arg));
    final durationMinus3 = duration - Duration(minutes: 3);
    await Future<void>.delayed(durationMinus3);
    await _beep();
    await _seconds(60);
    await _beep(2);
    await _seconds(60);
    await _beep(3);
    await _seconds(50);
    for (int i = 0; i < 10; i += 1) {
      print('Countdown ${10 - i}');
      await _beep();
      await Future<void>.delayed(Duration(seconds: 1));
    }
    if (Platform.isMacOS) {
      final result = Process.runSync('pmset', ['displaysleepnow']);
      if (result.exitCode != 0) {
        throw 'Unexpected result $result';
      }
    } else {
      throw 'We don\'t support screenlock in this platform yet.';
    }
  }

  Future<void> _seconds(int seconds) {
    return Future<void>.delayed(Duration(seconds: seconds));
  }

  Future<void> _beep([int times = 1]) async {
    for (int i = 0; i < times; i += 1) {
      print('beep' + String.fromCharCodes([0x07]));
      await Future<void>.delayed(Duration(milliseconds: 200));
    }
  }
}
