import 'package:parser_builder/branch.dart';
import 'package:parser_builder/bytes.dart';
import 'package:parser_builder/char_class.dart';
import 'package:parser_builder/character.dart';
import 'package:parser_builder/combinator.dart';
import 'package:parser_builder/error.dart';
import 'package:parser_builder/fast_build.dart';
import 'package:parser_builder/multi.dart';
import 'package:parser_builder/parser_builder.dart';
import 'package:parser_builder/semantic_value.dart';
import 'package:parser_builder/sequence.dart';
import 'package:parser_builder/string.dart';

Future<void> main(List<String> args) async {
  final context = Context();
  await fastBuild(context, [_json, _value_], 'lib/fast_json_big_int.dart',
      footer: __footer, publish: {'parse': _json});
}

const __footer = r'''
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
}''';

const _array = Named('_array', Delimited(_openBracket, _values, _closeBracket));

const _bigInt = Named(
    '_bigInt',
    Map1(
      Recognize(Fast2(
        Opt(Tag('-')),
        Fast2(Digit1(), Not(Tags(['.', 'e', 'E']))),
      )),
      ExpressionAction(['x'], 'BigInt.parse({{x}})'),
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
        _string,
        _colon,
        _value,
        ExpressionAction<MapEntry<String, dynamic>>(
            ['k', 'v'], 'MapEntry({{k}}, {{v}})')));

const _keyValues = Named('_keyValues', SeparatedList0(_keyValue, _comma));

///  '-'?('0'|[1-9][0-9]*)('.'[0-9]+)?([eE][+-]?[0-9]+)?
const _number = Named(
    '_number',
    Expected(
        'number',
        Map1(
          Recognize(Fast4(
            Opt(Tag('-')),
            Alt2(Tag('0'), Fast2(Satisfy(CharClass('[1-9]')), Digit0())),
            Opt(Fast2(Tag('.'), Digit1())),
            Opt(Fast3(Tags(['e', 'E']), Opt(Tags(['+', '-'])), Digit1())),
          )),
          ExpressionAction(['x'], 'num.parse({{x}})'),
        )));

const _numeric = Named('_numeric', Alt2(_bigInt, _number));

const _object = Named(
    '_object',
    Map3(_openBrace, _keyValues, _closeBrace,
        ExpressionAction(['kv'], 'Map.fromEntries({{kv}})')));

const _openBrace =
    Named('_openBrace', Fast(Terminated(Tag('{'), _ws)), [_inline]);

const _openBracket =
    Named('_openBracket', Fast(Terminated(Tag('['), _ws)), [_inline]);

const _primitives = Named(
    '_primitives',
    TagValues({
      'false': false,
      'true': true,
      'null': null as dynamic,
    }));

const _quote = Named('_quote', Fast(Terminated(Tag('"'), _ws)), [_inline]);

const _string = Named<String, String>(
    '_string',
    Nested(
        'string',
        HandleLastErrorPos(Delimited(
            StartPositionToValue('start', Tag('"')),
            _stringValue,
            Alt2(
              _quote,
              FailMessage(
                LastErrorPositionAction(),
                'Unterminated string',
                FromValueAction('start'),
              ),
            )))));

const _stringValue = StringValue(_isNormalChar, 0x5c, _escaped);

const _value = Ref<String, dynamic>('_value');

const _value_ = Named(
    '_value',
    Terminated(
        Alt5(
          _string,
          _numeric,
          _array,
          _object,
          _primitives,
        ),
        _ws));

const _values = Named('_values', SeparatedList0(_value, _comma));

const _ws = Named('_ws', SkipWhile(_isWhitespace));
