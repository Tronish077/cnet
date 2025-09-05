import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../CustomWidgets/customeWidget.dart';

class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false); // Initial state is not loading
  final CustomWidgets custom = CustomWidgets();

  void startLoading(context) {
    custom.LoaderSpinner(context);
  }

  void awaitMini(context){
    custom.awaitSpinner(context);
  }

    void stopLoading(context){
      Navigator.of(context, rootNavigator: true).pop();
    }

  }

final loadingProvider = StateNotifierProvider<LoadingNotifier, bool>((ref) {
  return LoadingNotifier();
});
