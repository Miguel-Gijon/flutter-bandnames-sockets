import 'package:band_names/services/bloc/socket_service_bloc.dart';
import 'package:flutter/material.dart';

import 'package:band_names/pages/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/status.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SocketServiceBloc>(
      create: (context) => SocketServiceBloc(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          initialRoute: 'home',
          routes: {
            'home': (_) => HomePage(),
            'status': (_) => StatusPage(),
          }),
    );
  }
}
