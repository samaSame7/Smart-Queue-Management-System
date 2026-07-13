import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../core/config/app_config.dart';

class SocketService {
  io.Socket? _socket;

  final _ticketUpdatedController = StreamController<Map<String, dynamic>>.broadcast();
  final _ticketCalledController = StreamController<Map<String, dynamic>>.broadcast();
  final _serviceStatsController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get ticketUpdatedStream => _ticketUpdatedController.stream;
  Stream<Map<String, dynamic>> get ticketCalledStream => _ticketCalledController.stream;
  Stream<Map<String, dynamic>> get serviceStatsStream => _serviceStatsController.stream;

  String? _subscribedServiceId;
  String? _subscribedTicketId;

  void connect({String? token}) {
    if (_socket?.connected == true) return;

    _socket = io.io(
      AppConfig.socketBaseUrl,
      io.OptionBuilder()
          .setPath(AppConfig.socketPath)
          .setTransports(['websocket'])
          .setAuth(token == null || token.trim().isEmpty ? {} : {'token': token.trim()})
          .enableReconnection()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(1000)
          .build(),
    );

    _socket!.on('connect', (_) {
      _sendSubscription();
    });

    _socket!.on('ticket:updated', (payload) {
      if (payload is Map) _ticketUpdatedController.add(Map<String, dynamic>.from(payload));
    });
    _socket!.on('ticket:called', (payload) {
      if (payload is Map) _ticketCalledController.add(Map<String, dynamic>.from(payload));
    });
    _socket!.on('service:stats', (payload) {
      if (payload is Map) _serviceStatsController.add(Map<String, dynamic>.from(payload));
    });
  }

  void _sendSubscription() {
    if (_socket?.connected == true) {
      _socket?.emit('subscribe', {
        if (_subscribedServiceId != null && _subscribedServiceId!.isNotEmpty) 'serviceId': _subscribedServiceId,
        if (_subscribedTicketId != null && _subscribedTicketId!.isNotEmpty) 'ticketId': _subscribedTicketId,
      });
    }
  }

  void subscribe({String? serviceId, String? ticketId}) {
    _subscribedServiceId = serviceId;
    _subscribedTicketId = ticketId;
    _sendSubscription();
  }

  void unsubscribe({String? serviceId, String? ticketId}) {
    _socket?.emit('unsubscribe', {
      if (serviceId != null && serviceId.isNotEmpty) 'serviceId': serviceId,
      if (ticketId != null && ticketId.isNotEmpty) 'ticketId': ticketId,
    });
    _subscribedServiceId = null;
    _subscribedTicketId = null;
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void dispose() {
    disconnect();
    _ticketUpdatedController.close();
    _ticketCalledController.close();
    _serviceStatsController.close();
  }
}
