import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../theme/app_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);
    on<LoadThemeEvent>(_onLoadTheme);
    
    add(LoadThemeEvent());
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    final newThemeMode = state.themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    
    emit(state.copyWith(
      themeMode: newThemeMode,
      themeData: newThemeMode == ThemeMode.light 
          ? AppTheme.lightTheme 
          : AppTheme.darkTheme,
    ));
  }

  void _onSetTheme(SetThemeEvent event, Emitter<ThemeState> emit) {
    emit(state.copyWith(
      themeMode: event.themeMode,
      themeData: event.themeMode == ThemeMode.light 
          ? AppTheme.lightTheme 
          : AppTheme.darkTheme,
    ));
  }

  void _onLoadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) {
    // Default to dark theme
    emit(state.copyWith(
      themeMode: ThemeMode.dark,
      themeData: AppTheme.darkTheme,
    ));
  }
}