import 'package:event_bus/event_bus.dart';

class EventBusManager {
  final EventBus _eventBus = new EventBus();

  // 工厂模式
  factory EventBusManager() => _getInstance();

  static EventBusManager get instance => _getInstance();
  static EventBusManager _instance;
  EventBusManager._internal();
  static EventBusManager _getInstance() {
    if (_instance == null) {
      _instance = new EventBusManager._internal();
    }
    return _instance;
  }

  EventBus get eventBus => _eventBus;
}
