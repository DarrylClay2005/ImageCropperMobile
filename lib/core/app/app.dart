import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme/theme_bloc.dart';
import '../blocs/image_cropper/image_cropper_bloc.dart';
import '../blocs/image_upscaler/image_upscaler_bloc.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../services/simple_service_locator.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => SimpleServiceLocator.instance<ThemeBloc>(),
        ),
        BlocProvider<ImageCropperBloc>(
          create: (context) => SimpleServiceLocator.instance<ImageCropperBloc>(),
        ),
        BlocProvider<ImageUpscalerBloc>(
          create: (context) => SimpleServiceLocator.instance<ImageUpscalerBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Image Cropper Pro',
            debugShowCheckedModeBanner: false,
            theme: themeState.themeData,
            home: const SplashScreen(),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(
                    MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
                  ),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}