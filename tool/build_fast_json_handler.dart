import 'package:parser_builder/branch.dart';
import 'package:parser_builder/bytes.dart';
import 'package:parser_builder/char_class.dart';
import 'package:parser_builder/character.dart';
import 'package:parser_builder/combinator.dart';
import 'package:parser_builder/error.dart';
import 'package:parser_builder/fast_build.dart';
import 'package:parser_builder/multi.dart';
import 'package:parser_builder/parser_builder.dart';
import 'package:parser_builder/sequence.dart';
import 'package:parser_builder/string.dart';

import 'build_json_number_parser.dart' as _json_number;

Future<void> main(List<String> args) async {
  final context = Context();
  await fastBuild(context, [_json, _value_], 'lib/fast_json_handler.dart',
      footer: __footer, header: __header);
}

const __footer = r'''
abstract class JsonParserHandler {
  void handle(JsonHandlerEvent event, dynamic value);
}

enum JsonHandlerEvent {
  element,
  beginArray,
  beginKey,
  beginObject,
  endArray,
  endKey,
  endObject,
  value,
}
''';

const __header = r'''
dynamic parse(String source, JsonParserHandler handler) {
  final state = State(source);
  state.context = handler;
  final result = _json(state);
  if (!state.ok) {
    final message = _errorMessage(source, state.errors);
    throw FormatException('\n$message');
  }

  return result;
}

@pragma('vm:prefer-inline')
dynamic _handleBeginArray(State<String> state) =>
    _h(state, JsonHandlerEvent.beginArray, null, null);

@pragma('vm:prefer-inline')
String _handleBeginKey(State<String> state, String key) =>
    _h(state, JsonHandlerEvent.beginKey, key, key);

@pragma('vm:prefer-inline')
dynamic _handleBeginObject(State<String> state) =>
    _h(state, JsonHandlerEvent.beginObject, null, null);

@pragma('vm:prefer-inline')
dynamic _handleElement(State<String> state) =>
    _h(state, JsonHandlerEvent.element, null, null);

@pragma('vm:prefer-inline')
dynamic _handleEndArray(State<String> state) =>
    _h(state, JsonHandlerEvent.endArray, null, null);

@pragma('vm:prefer-inline')
MapEntry<String, dynamic> _handleEndKey(
        State<String> state, String key, dynamic value) =>
    _h(state, JsonHandlerEvent.endKey, key, const MapEntry('', null));

@pragma('vm:prefer-inline')
dynamic _handleEndObject(State<String> state) =>
    _h(state, JsonHandlerEvent.endObject, null, null);

@pragma('vm:prefer-inline')
T _handleValue<T>(State<String> state, T value) =>
    _h(state, JsonHandlerEvent.value, value, value);

@pragma('vm:prefer-inline')
T _h<T>(State<String> state, JsonHandlerEvent event, dynamic value, T returns,
    [dynamic unused]) {
  final handler = state.context as JsonParserHandler;
  handler.handle(event, value);
  return returns;
}

@pragma('vm:prefer-inline')
int _toHexValue(String s) {
  final l = s.codeUnits;
  var r = 0;
  for (var i = l.length - 1, j = 0; i >= 0; i--, j += 4) {
    final c = l[i];
    var v = 0;
    if (c >= 0x30 && c <= 0x39) {
      v = c - 0x30;
    } else if (c >= 0x41 && c <= 0x46) {
      v = c - 0x41 + 10;
    } else if (c >= 0x61 && c <= 0x66) {
      v = c - 0x61 + 10;
    } else {
      throw StateError('Internal error');
    }

    r += v * (1 << j);
  }

  return r;
}

@pragma('vm:prefer-inline')
T _toValue<T>(dynamic unused, T value) => value;

''';

const _array = Named(
    '_array',
    Delimited(
      _FastHandle(
          _openBracket, ExpressionAction([], '_handleBeginArray(state)')),
      Map1(_values, ExpressionAction(['x'], '_toValue({{x}}, const [])')),
      _FastHandle(
          _closeBracket, ExpressionAction([], '_handleEndArray(state)')),
    ));

const _closeBrace =
    Named('_closeBrace', Fast(Terminated(Tag('}'), _ws)), [_inline]);

const _closeBracket =
    Named('_closeBracket', Fast(Terminated(Tag(']'), _ws)), [_inline]);

const _colon = Fast(Terminated(Tag(':'), _ws));

const _comma = Terminated(Tag(','), _ws);

const _eof = Eof<String>();

const _escaped = Named('_escaped', Alt2(_escapeSeq, _escapeHex));

const _escapeHex = Named(
    '_escapeHex',
    Map2(
        Fast(Satisfy(CharClass('[u]'))),
        Indicate(
            "An escape sequence starting with '\\u' must be followed by 4 hexadecimal digits",
            TakeWhileMN(4, 4, CharClass('[0-9a-fA-F]'))),
        ExpressionAction<int>(['s'], '_toHexValue({{s}})')),
    [_inline]);

const _escapeSeq = EscapeSequence({
  0x22: 0x22,
  0x2f: 0x2f,
  0x5c: 0x5c,
  0x62: 0x08,
  0x66: 0x0c,
  0x6e: 0x0a,
  0x72: 0x0d,
  0x74: 0x09
});

const _inline = '@pragma(\'vm:prefer-inline\')';

const _isNormalChar = CharClass('[#x20-#x21] | [#x23-#x5b] | [#x5d-#x10ffff]');

const _isWhitespace = CharClass('#x9 | #xA | #xD | #x20');

const _json = Named<String, dynamic>('_json', Delimited(_ws, _value, _eof));

const _keyValue = Named(
    '_keyValue',
    Map3(
        Map1(_string, ExpressionAction(['x'], '_handleBeginKey(state, {{x}})')),
        _colon,
        _value,
        ExpressionAction<MapEntry<String, dynamic>>(
            ['k', 'v'], '_handleEndKey(state, {{k}} as String, {{v}})')));

const _keyValues = Named('_keyValues', SeparatedList0(_keyValue, _comma));

const _number = Named(
    '_number',
    Expected(
        'number',
        Map1(_json_number.parser,
            ExpressionAction<num>(['x'], '_handleValue(state, {{x}})'))));

const _object = Named(
    '_object',
    Map3(
      _FastHandle(
          _openBrace, ExpressionAction([], '_handleBeginObject(state)')),
      _keyValues,
      _FastHandle(_closeBrace, ExpressionAction([], '_handleEndObject(state)')),
      ExpressionAction(['kv'], '_toValue({{kv}}, const {})'),
    ));

const _openBrace =
    Named('_openBrace', Fast(Terminated(Tag('{'), _ws)), [_inline]);

const _openBracket =
    Named('_openBracket', Fast(Terminated(Tag('['), _ws)), [_inline]);

const _primitives = Named(
    '_primitives',
    Map1(
        TagValues({
          'false': false,
          'true': true,
          'null': null as dynamic,
        }),
        ExpressionAction<dynamic>(['x'], '_handleValue(state, {{x}})')));

const _quote = Named('_quote', Fast(Terminated(Tag('"'), _ws)), [_inline]);

const _string = Named<String, String>(
    '_string',
    Nested(
        'string',
        WithStartAndLastErrorPos(Delimited(
            Tag('"'),
            Map1(_stringValue,
                ExpressionAction<String>(['x'], '_handleValue(state, {{x}})')),
            Alt2(
              _quote,
              FailMessage(
                  StatePos.lastErrorPos, 'Unterminated string', StatePos.start),
            )))));

const _stringValue = StringValue(_isNormalChar, 0x5c, _escaped);

const _value = Ref<String, dynamic>('_value');

const _value_ = Named(
    '_value',
    Terminated(
        Alt5(
          _string,
          _number,
          _array,
          _object,
          _primitives,
        ),
        _ws));

const _values = Named(
    '_values',
    _Handle(
      Fast(SeparatedList0(
          _FastHandle(_value, ExpressionAction([], '_handleElement(state)')),
          _comma)),
    ));

const _ws = Named('_ws', SkipWhile(_isWhitespace));

class _FastHandle<I> extends ParserBuilder<I, void> {
  final SemanticAction<void> handle;

  final ParserBuilder<I, dynamic> parser;

  const _FastHandle(this.parser, this.handle);

  @override
  String build(Context context, ParserResult? result) {
    return Fast2(parser, Slow(Calculate(handle))).build(context, result);
  }
}

class _Handle<I> extends ParserBuilder<I, dynamic> {
  final ParserBuilder<I, dynamic> parser;

  const _Handle(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    return Fast2(parser, Slow(Calculate(ExpressionAction([], 'null'))))
        .build(context, result);
  }
}
