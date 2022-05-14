import 'fast_json_handler.dart' as parser;
import 'fast_json_handler.dart' show JsonEvent, JsonParserHandler;

class FastJsonSelector {
  void parse(String source,
      {required void Function(FastJsonSelectorEvent context) select}) {
    final handler = _JsonParserHandler(select);
    parser.parse(source, handler);
  }
}

class FastJsonSelectorEvent {
  final List buffer = [];

  dynamic lastValue;

  final List levels = [];
}

class _JsonParserHandler<T> extends JsonParserHandler {
  final void Function(FastJsonSelectorEvent context) _select;

  final FastJsonSelectorEvent context = FastJsonSelectorEvent();

  _JsonParserHandler(this._select);

  @override
  void handle(JsonEvent event, dynamic value) {
    switch (event) {
      case JsonEvent.beginArray:
        context.buffer.add([]);
        context.levels.add('[]');
        context.levels.add(0);
        break;
      case JsonEvent.beginObject:
        context.buffer.add(<String, dynamic>{});
        context.levels.add('{}');
        break;
      case JsonEvent.endArray:
        context.levels.removeLast();
        context.lastValue = context.buffer.removeLast();
        _select(context);
        context.levels.removeLast();
        break;
      case JsonEvent.endObject:
        context.lastValue = context.buffer.removeLast();
        _select(context);
        context.levels.removeLast();
        break;
      case JsonEvent.element:
        _select(context);
        context.buffer.last.add(context.lastValue);
        context.levels.last++;
        break;
      case JsonEvent.beginKey:
        context.levels.add(context.lastValue as String);
        break;
      case JsonEvent.endKey:
        _select(context);
        context.buffer.last[value] = context.lastValue;
        context.levels.removeLast();

        break;
      case JsonEvent.value:
        context.lastValue = value;
        break;
    }
  }
}
