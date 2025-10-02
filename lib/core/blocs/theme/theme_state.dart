part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final ThemeData themeData;

  const ThemeState({
    required this.themeMode,
    required this.themeData,
  });

  factory ThemeState.initial() {
    return ThemeState(
      themeMode: ThemeMode.system,
      themeData: AppTheme.darkTheme,
    );
  }

  ThemeState copyWith({
    ThemeMode? themeMode,
    ThemeData? themeData,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      themeData: themeData ?? this.themeData,
    );
  }

  @override
  List<Object?> get props => [themeMode, themeData];
}