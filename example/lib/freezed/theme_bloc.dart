import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_bloc.freezed.dart';
part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(_Light()) {
    on<_Load>(_loadThemeEvent);
    on<_Set>(_setThemeEvent);
  }

  FutureOr<void> _loadThemeEvent(
    _Load event,
    Emitter<ThemeState> emit,
  ) async {
    emit(_Light());
  }

  FutureOr<void> _setThemeEvent(
    _Set event,
    Emitter<ThemeState> emit,
  ) async {
    emit(_Light());
  }
}
