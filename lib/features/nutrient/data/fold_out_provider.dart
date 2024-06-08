import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fold_out_provider.g.dart';

@riverpod
class FoldOut extends _$FoldOut {
  @override
  bool build() {
    return false;
  }

  void minimizeChart() {
    state = false;
  }

  void toggleState() {
    state = !state;
  }
}
