import 'fast_json_handler.dart' as parser;
import 'fast_json_handler.dart' show JsonHandlerEvent, JsonParserHandler;

void parse(String source,
    {required void Function(JsonSelectorEvent context) select}) {
  final handler = _JsonParserHandler(select);
  parser.parse(source, handler);
}

class JsonSelectorEvent {
  final List buffer = [];

  dynamic lastValue;

  final List levels = [];
}

class _JsonParserHandler<T> extends JsonParserHandler {
  final void Function(JsonSelectorEvent context) _select;

  final JsonSelectorEvent context = JsonSelectorEvent();

  _JsonParserHandler(this._select);

  @override
  void handle(JsonHandlerEvent event, dynamic value) {
    switch (event) {
      case JsonHandlerEvent.beginArray:
        context.buffer.add([]);
        context.levels.add('[]');
        context.levels.add(0);
        break;
      case JsonHandlerEvent.beginObject:
        context.buffer.add(<String, dynamic>{});
        context.levels.add('{}');
        break;
      case JsonHandlerEvent.endArray:
        context.levels.removeLast();
        context.lastValue = context.buffer.removeLast();
        _select(context);
        context.levels.removeLast();
        break;
      case JsonHandlerEvent.endObject:
        context.lastValue = context.buffer.removeLast();
        _select(context);
        context.levels.removeLast();
        break;
      case JsonHandlerEvent.element:
        _select(context);
        context.buffer.last.add(context.lastValue);
        context.levels.last++;
        break;
      case JsonHandlerEvent.beginKey:
        context.levels.add(context.lastValue as String);
        break;
      case JsonHandlerEvent.endKey:
        _select(context);
        context.buffer.last[value] = context.lastValue;
        context.levels.removeLast();
        break;
      case JsonHandlerEvent.value:
        context.lastValue = value;
        break;
    }
  }
}
