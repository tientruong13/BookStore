abstract class BaseEvent {
  String type() {
    return this.runtimeType.toString();
  }
}
