import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../theme/app_theme.dart';
import '../../storage/storage_service.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  final StorageService _storageService;

  ThemeBloc(this._storageService) : super(ThemeState.initial()) {
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
    
    _saveThemeMode(newThemeMode);
  }

  void _onSetTheme(SetThemeEvent event, Emitter<ThemeState> emit) {
    emit(state.copyWith(
      themeMode: event.themeMode,
      themeData: event.themeMode == ThemeMode.light 
          ? AppTheme.lightTheme 
          : AppTheme.darkTheme,
    ));
    
    _saveThemeMode(event.themeMode);
  }

  void _onLoadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) {
    final savedThemeMode = _loadThemeMode();
    
    emit(state.copyWith(
      themeMode: savedThemeMode,
      themeData: savedThemeMode == ThemeMode.light 
          ? AppTheme.lightTheme 
          : AppTheme.darkTheme,
    ));
  }

  void _saveThemeMode(ThemeMode themeMode) {
    _storageService.saveBool(
      'is_dark_theme', 
      themeMode == ThemeMode.dark,
    );
  }

  ThemeMode _loadThemeMode() {
    final isDarkTheme = _storageService.getBool('is_dark_theme') ?? false;
    return isDarkTheme ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    try {
      final themeMode = json['themeMode'] as String;
      final parsedThemeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeMode,
        orElse: () => ThemeMode.system,
      );
      
      return ThemeState(
        themeMode: parsedThemeMode,
        themeData: parsedThemeMode == ThemeMode.light 
            ? AppTheme.lightTheme 
            : AppTheme.darkTheme,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    try {
      return {
        'themeMode': state.themeMode.toString(),
      };
    } catch (e) {
      return null;
    }
  }
}