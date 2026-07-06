import 'package:flutter_bloc/flutter_bloc.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState('en'));

  void toggle() {
    emit(LocaleState(state.isArabic ? 'en' : 'ar'));
  }
}
