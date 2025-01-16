part of 'socket_service_bloc.dart';

@immutable
sealed class SocketServiceEvent {}

class SocketServiceInitEvent extends SocketServiceEvent {}

class SocketEmmitMessageEvent extends SocketServiceEvent {
  final Map map;

  SocketEmmitMessageEvent(this.map);
}

class SocketServiceEmmitVoteEvent extends SocketServiceEvent {
  final String id;

  SocketServiceEmmitVoteEvent(this.id);
}

class SocketServiceAddBandEvent extends SocketServiceEvent {
  final String name;

  SocketServiceAddBandEvent(this.name);
}

class SocketServiceRemoveBandEvent extends SocketServiceEvent {
  final String id;

  SocketServiceRemoveBandEvent(this.id);
}
