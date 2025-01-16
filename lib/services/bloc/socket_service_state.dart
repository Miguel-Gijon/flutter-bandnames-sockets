part of 'socket_service_bloc.dart';

@immutable
class SocketServiceState extends Equatable {

  final SocketServiceStatus status;
  final IO.Socket? socket;
  final List<Band> bands;

  const SocketServiceState({
    this.status = SocketServiceStatus.connecting,
    this.socket,
    this.bands = const [],
  });


  @override
  List<Object?> get props => [status, socket, bands];

  SocketServiceState copyWith(
    {
      SocketServiceStatus? status,
      IO.Socket? socket,
      List<Band>? bands,
    }
  ) {
    return SocketServiceState(
      status: status ?? this.status,
      socket: socket ?? this.socket,
      bands: bands ?? this.bands,
    );
  }
}
