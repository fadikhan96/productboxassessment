import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:productboxassessment/bloc/movie/movie_bloc.dart';
import 'package:productboxassessment/bloc/search/search_cubit.dart';
import 'package:productboxassessment/repository/movie_repository.dart';
import 'package:productboxassessment/screens/home_screen.dart';
import 'package:productboxassessment/services/firebase_services.dart';
import 'bloc/fovorite/favorite_cubit.dart';
import 'bloc/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final movieRepository = MovieRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchCubit(),
        ),
        BlocProvider(
          create: (context) => MovieBloc(movieRepository),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<FavoriteCubit>(
          create: (context) => FavoriteCubit()..loadFavorites(),
        ),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                title: 'ProductBox Assessment App',
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                themeMode: themeMode,
                home: const HomeScreen(),
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
