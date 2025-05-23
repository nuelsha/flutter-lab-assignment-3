import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation/app_router.dart';
import 'business_logic/blocs/album_bloc.dart';
import 'data/repositories/album_repository.dart';
import 'data/providers/api_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AlbumRepository(ApiProvider()),
      child: BlocProvider(
        create:
            (context) => AlbumBloc(
              albumRepository: RepositoryProvider.of<AlbumRepository>(context),
            ),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Album App',
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              elevation: 2,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            useMaterial3: true,
          ),
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
