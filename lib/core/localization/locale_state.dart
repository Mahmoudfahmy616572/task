import 'package:equatable/equatable.dart';

class LocaleState extends Equatable {
  final String locale;

  const LocaleState(this.locale);

  bool get isArabic => locale == 'ar';

  LocaleState copyWith({String? locale}) {
    return LocaleState(locale ?? this.locale);
  }

  @override
  List<Object?> get props => [locale];
}
