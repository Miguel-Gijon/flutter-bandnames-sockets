import 'package:band_names/services/bloc/socket_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class StatusPage extends StatelessWidget {
  const StatusPage({super.key});


  @override
  Widget build(BuildContext context) {
    context.read<SocketServiceBloc>().add(SocketServiceInitEvent());
    final bloc = context.watch<SocketServiceBloc>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Status: ${ bloc.state.status }'),
          ],
        ),
     ),
     floatingActionButton: FloatingActionButton(
       child: const Icon(Icons.message),
       onPressed: () {
         final map = {
           'nombre': 'Flutter',
           'mensaje': 'Hola desde Flutter',
         };
          context.read<SocketServiceBloc>().add(SocketEmmitMessageEvent(map));
       },
     ),
   );
  }
}