part of 'theme_bloc.dart';

@freezed
sealed class ThemeEvent with _$ThemeEvent {
  const factory ThemeEvent.load() = _Load;

  const factory ThemeEvent.set({
    required ThemeMode themeMode,
  }) = _Set;
}
