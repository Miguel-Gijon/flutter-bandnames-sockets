import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';

import '../services/bloc/socket_service_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<SocketServiceBloc>().add(SocketServiceInitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BandNames',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          BlocBuilder<SocketServiceBloc, SocketServiceState>(
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: state.status == SocketServiceStatus.online
                    ? Icon(Icons.check_circle, color: Colors.blue[300])
                    : const Icon(Icons.offline_bolt, color: Colors.red),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          BlocBuilder<SocketServiceBloc, SocketServiceState>(
            builder: (context, state) {
              if (state.bands.isEmpty) {
                return const Center(child: Text('No bands available'));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: state.bands.length,
                  itemBuilder: (context, i) => _bandTile(state.bands[i]),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => context
          .read<SocketServiceBloc>()
          .add(SocketServiceRemoveBandEvent(band.id)),
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Delete band',
              style:
                  TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
            )),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          foregroundColor: Colors.blue[600],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () => context
            .read<SocketServiceBloc>()
            .add(SocketServiceEmmitVoteEvent(band.id)),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('New band name:'),
                content: TextField(
                  controller: textController,
                ),
                actions: [
                  MaterialButton(
                    elevation: 5,
                    onPressed: () => addBandToList(textController.text),
                    child: const Text('Add'),
                  )
                ],
              ));
    }

    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('New band name'),
        content: CupertinoTextField(
          controller: textController,
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Add'),
            onPressed: () => addBandToList(textController.text),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Dismiss'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      context.read<SocketServiceBloc>().add(SocketServiceAddBandEvent(name));
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    final Map<String, double> dataMap = {};
    final bands = context.watch<SocketServiceBloc>().state.bands;
    if (bands.isEmpty) {
      return const Center(child: Text('No bands available'));
    }
    for (var band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }

    return Container(
        padding: const EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 200,
        child: PieChart(
          dataMap: dataMap,
          chartType: ChartType.ring,
        ));
  }
}
