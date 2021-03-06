import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translateapp/bloc/switch_language_button/switch_language_button_event.dart';
import 'package:translateapp/bloc/switch_language_button/switch_language_button_state.dart';

class SwitchLanguageButtonBloc
    extends Bloc<SwitchLanguageButtonEvent, SwitchLanguageButtonState> {
  @override
  SwitchLanguageButtonState get initialState =>
      SwitchLanguageButtonState(true);

  @override
  Stream<SwitchLanguageButtonState> mapEventToState(
      SwitchLanguageButtonEvent event) async* {
    if (event is OnDisableSwitchButtonEvent) {
      yield SwitchLanguageButtonState(false);
    }

    if (event is OnEnableSwitchButtonEvent) {
      yield SwitchLanguageButtonState(true);
    }
  }
}
