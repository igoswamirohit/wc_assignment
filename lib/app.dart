import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wc_assignment/data/blocs/user_bloc/user_bloc.dart';
import 'package:wc_assignment/repositories/user_repository.dart';
import 'package:wc_assignment/utils/route_manager.dart';

import 'data/blocs/home_bloc/home_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => UserRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => UserBloc(context.read<UserRepository>())),
          BlocProvider(
              create: (context) => HomeBloc(context.read<UserRepository>())),
        ],
        child: MaterialApp(
          restorationScopeId: 'app',
          onGenerateRoute: RouteManager.onGenerateRoute,
          theme: ThemeData(
            fontFamily: 'Exo',
          ),
        ),
      ),
    );
  }
}
