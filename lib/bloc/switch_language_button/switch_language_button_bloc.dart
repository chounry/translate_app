import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translateapp/bloc/switch_language_button/switch_language_button_event.dart';
import 'package:translateapp/bloc/switch_language_button/switch_language_button_state.dart';

class SwitchLanguageButtonBloc
    extends Bloc<SwitchLanguageButtonEvent, SwitchLanguageButtonState> {
  String fromImage = '';
  String toImage = '';
  bool _isSwap = false;

  @override
  SwitchLanguageButtonState get initialState => SwitchLanguageButtonState(false);

  @override
  Stream<SwitchLanguageButtonState> mapEventToState(
      SwitchLanguageButtonEvent event) async* {
    if (event is OnDisableSwitchButtonEvent) {
      yield SwitchLanguageButtonState(false);
    }

    if (event is OnEnableSwitchButtonEvent) {
      String imageToShow = _isSwap ? toImage : fromImage;
      yield SwitchLanguageButtonState(true);
    }
  }
}
