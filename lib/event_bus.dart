import 'dart:async';

class EventBus {
  static final EventBus _instance = EventBus._internal();

  factory EventBus() => _instance;

  EventBus._internal();

  final Map<String, StreamController<dynamic>> _events = {};

  void publish(String eventType, [dynamic data]) {
    if (!_events.containsKey(eventType)) return;
    _events[eventType]?.add(data);
  }

  Stream<dynamic>? subscribe(String eventType) {
    _events[eventType] ??= StreamController<dynamic>.broadcast();
    return _events[eventType]?.stream;
  }

  void unsubscribe(String eventType) {
    _events[eventType]?.close();
    _events.remove(eventType);
  }
}
