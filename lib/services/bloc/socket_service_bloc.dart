import 'dart:async';

import 'package:band_names/models/band.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'socket_service_event.dart';
part 'socket_service_state.dart';

enum SocketServiceStatus { online, offline, connecting }

class SocketServiceBloc extends Bloc<SocketServiceEvent, SocketServiceState> {
  SocketServiceBloc() : super(const SocketServiceState()) {
    on<SocketServiceInitEvent>(_onInit);
    on<SocketEmmitMessageEvent>(_onEmmitMessage);
    on<SocketServiceEmmitVoteEvent>(_onEmmitVote);
    on<SocketServiceAddBandEvent>(_onAddBand);
    on<SocketServiceRemoveBandEvent>(_onRemoveBand);
  }

  Future<void> _onInit(
      SocketServiceInitEvent event, Emitter<SocketServiceState> emit) async {
    IO.Socket socket = IO.io('http://192.168.1.240:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    final Completer<void> completer = Completer<void>();

    socket
      ..on('connect', (_) {
        if (!completer.isCompleted) {
          emit(state.copyWith(status: SocketServiceStatus.online, socket: socket));
        }
      })
      ..on('disconnect', (_) {
        if (!completer.isCompleted) {
          emit(state.copyWith(status: SocketServiceStatus.offline, socket: socket));
        }
      })
      ..on('active-bands', (payload) {
        if (!completer.isCompleted){
          final List<Band> bands = (payload as List).map((band) => Band.fromMap(band)).toList();
          emit(state.copyWith(bands: bands));
        }
      });

    await completer.future;
  }

  Future<void> _onEmmitMessage(SocketEmmitMessageEvent event, 
    Emitter<SocketServiceState> emit) async {
      state.socket?.emit('emitir-mensaje', event.map);  
  }

  Future<void> _onEmmitVote(SocketServiceEmmitVoteEvent event, 
    Emitter<SocketServiceState> emit) async {
      state.socket?.emit('vote-band', {'id': event.id});
  }

  Future<void> _onAddBand(SocketServiceAddBandEvent event, 
    Emitter<SocketServiceState> emit) async {
      state.socket?.emit('add-band', {'name': event.name});
  }

  Future<void> _onRemoveBand(SocketServiceRemoveBandEvent event, 
    Emitter<SocketServiceState> emit) async {
      state.socket?.emit('delete-band', {'id': event.id});
  }
}
