import 'dart:convert';

import 'package:fast_json/fast_json_big_int.dart' as big_int;
import 'package:fast_json/fast_json_web.dart' as web;
import 'package:fast_json/fast_json_handler.dart' as parser_handler;
import 'package:fast_json/fast_json_handler.dart'
    show JsonHandlerEvent, JsonParserHandler;
import 'package:fast_json/fast_json_selector.dart' as parser_selector;
import 'package:fast_json/fast_json_selector.dart' show JsonSelectorEvent;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main(List<String> args) {
  _testHandler();
  _testParserBigInt();
  _testParserWeb();
  _testSelector();
}

const _data =
    '''
[
  {
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "address": {
      "street": "Kulas Light",
      "suite": "Apt. 556",
      "city": "Gwenborough",
      "zipcode": "92998-3874",
      "geo": {
        "lat": "-37.3159",
        "lng": "81.1496"
      }
    },
    "phone": "1-770-736-8031 x56442",
    "website": "hildegard.org",
    "company": {
      "name": "Romaguera-Crona",
      "catchPhrase": "Multi-layered client-server neural-net",
      "bs": "harness real-time e-markets"
    }
  },
  {
    "id": 2,
    "name": "Ervin Howell",
    "username": "Antonette",
    "email": "Shanna@melissa.tv",
    "address": {
      "street": "Victor Plains",
      "suite": "Suite 879",
      "city": "Wisokyburgh",
      "zipcode": "90566-7771",
      "geo": {
        "lat": "-43.9509",
        "lng": "-34.4618"
      }
    },
    "phone": "010-692-6593 x09125",
    "website": "anastasia.net",
    "company": {
      "name": "Deckow-Crist",
      "catchPhrase": "Proactive didactic contingency",
      "bs": "synergize scalable supply-chains"
    }
  },
  {
    "id": 3,
    "name": "Clementine Bauch",
    "username": "Samantha",
    "email": "Nathan@yesenia.net",
    "address": {
      "street": "Douglas Extension",
      "suite": "Suite 847",
      "city": "McKenziehaven",
      "zipcode": "59590-4157",
      "geo": {
        "lat": "-68.6102",
        "lng": "-47.0653"
      }
    },
    "phone": "1-463-123-4447",
    "website": "ramiro.info",
    "company": {
      "name": "Romaguera-Jacobson",
      "catchPhrase": "Face to face bifurcated interface",
      "bs": "e-enable strategic applications"
    }
  },
  {
    "id": 4,
    "name": "Patricia Lebsack",
    "username": "Karianne",
    "email": "Julianne.OConner@kory.org",
    "address": {
      "street": "Hoeger Mall",
      "suite": "Apt. 692",
      "city": "South Elvis",
      "zipcode": "53919-4257",
      "geo": {
        "lat": "29.4572",
        "lng": "-164.2990"
      }
    },
    "phone": "493-170-9623 x156",
    "website": "kale.biz",
    "company": {
      "name": "Robel-Corkery",
      "catchPhrase": "Multi-tiered zero tolerance productivity",
      "bs": "transition cutting-edge web services"
    }
  },
  {
    "id": 5,
    "name": "Chelsey Dietrich",
    "username": "Kamren",
    "email": "Lucio_Hettinger@annie.ca",
    "address": {
      "street": "Skiles Walks",
      "suite": "Suite 351",
      "city": "Roscoeview",
      "zipcode": "33263",
      "geo": {
        "lat": "-31.8129",
        "lng": "62.5342"
      }
    },
    "phone": "(254)954-1289",
    "website": "demarco.info",
    "company": {
      "name": "Keebler LLC",
      "catchPhrase": "User-centric fault-tolerant solution",
      "bs": "revolutionize end-to-end systems"
    }
  },
  {
    "id": 6,
    "name": "Mrs. Dennis Schulist",
    "username": "Leopoldo_Corkery",
    "email": "Karley_Dach@jasper.info",
    "address": {
      "street": "Norberto Crossing",
      "suite": "Apt. 950",
      "city": "South Christy",
      "zipcode": "23505-1337",
      "geo": {
        "lat": "-71.4197",
        "lng": "71.7478"
      }
    },
    "phone": "1-477-935-8478 x6430",
    "website": "ola.org",
    "company": {
      "name": "Considine-Lockman",
      "catchPhrase": "Synchronised bottom-line interface",
      "bs": "e-enable innovative applications"
    }
  },
  {
    "id": 7,
    "name": "Kurtis Weissnat",
    "username": "Elwyn.Skiles",
    "email": "Telly.Hoeger@billy.biz",
    "address": {
      "street": "Rex Trail",
      "suite": "Suite 280",
      "city": "Howemouth",
      "zipcode": "58804-1099",
      "geo": {
        "lat": "24.8918",
        "lng": "21.8984"
      }
    },
    "phone": "210.067.6132",
    "website": "elvis.io",
    "company": {
      "name": "Johns Group",
      "catchPhrase": "Configurable multimedia task-force",
      "bs": "generate enterprise e-tailers"
    }
  },
  {
    "id": 8,
    "name": "Nicholas Runolfsdottir V",
    "username": "Maxime_Nienow",
    "email": "Sherwood@rosamond.me",
    "address": {
      "street": "Ellsworth Summit",
      "suite": "Suite 729",
      "city": "Aliyaview",
      "zipcode": "45169",
      "geo": {
        "lat": "-14.3990",
        "lng": "-120.7677"
      }
    },
    "phone": "586.493.6943 x140",
    "website": "jacynthe.com",
    "company": {
      "name": "Abernathy Group",
      "catchPhrase": "Implemented secondary concept",
      "bs": "e-enable extensible e-tailers"
    }
  },
  {
    "id": 9,
    "name": "Glenna Reichert",
    "username": "Delphine",
    "email": "Chaim_McDermott@dana.io",
    "address": {
      "street": "Dayna Park",
      "suite": "Suite 449",
      "city": "Bartholomebury",
      "zipcode": "76495-3109",
      "geo": {
        "lat": "24.6463",
        "lng": "-168.8889"
      }
    },
    "phone": "(775)976-6794 x41206",
    "website": "conrad.com",
    "company": {
      "name": "Yost and Sons",
      "catchPhrase": "Switchable contextually-based project",
      "bs": "aggregate real-time technologies"
    }
  },
  {
    "id": 10,
    "name": "Clementina DuBuque",
    "username": "Moriah.Stanton",
    "email": "Rey.Padberg@karina.biz",
    "address": {
      "street": "Kattie Turnpike",
      "suite": "Suite 198",
      "city": "Lebsackbury",
      "zipcode": "31428-2261",
      "geo": {
        "lat": "-38.2386",
        "lng": "57.2232"
      }
    },
    "phone": "024-648-3804",
    "website": "ambrose.net",
    "company": {
      "name": "Hoeger LLC",
      "catchPhrase": "Centralized empowering task-force",
      "bs": "target end-to-end models"
    }
  }
]''';

_testHandler() {
  test('JSON parser handler', () {
    {
      final handler = _JsonParserHandler();
      final matcher = {
        'list': [1, 2],
        'map': {'bool': true},
        'string': '1\\u00202'
      };
      final source = jsonEncode(matcher);
      parser_handler.parse(source, handler);
      expect(handler.lastValue, matcher);
    }
    {
      final handler = _JsonParserHandler();
      final matcher = [
        1,
        {
          'list': ['Hello\\n']
        },
        null
      ];
      final source = jsonEncode(matcher);
      parser_handler.parse(source, handler);
      expect(handler.lastValue, matcher);
    }
    {
      final matchers = [false, true, null, 'Hello', -1, 0, 1000E10];
      for (final matcher in matchers) {
        final handler = _JsonParserHandler();
        final source = jsonEncode(matcher);
        parser_handler.parse(source, handler);
        expect(handler.lastValue, matcher);
      }
    }
    {
      List buffer = [];
      dynamic lastValue;
      final keys = <String>[];
      var path = '';
      // This is a criteria
      final cities = ['Aliyaview', 'Wisokyburgh'];
      // Founds users
      final users = <Map<String, dynamic>>[];
      void handle(JsonHandlerEvent event, dynamic value) {
        switch (event) {
          case JsonHandlerEvent.beginArray:
            buffer.add([]);
            break;
          case JsonHandlerEvent.beginObject:
            buffer.add(<String, dynamic>{});
            break;
          case JsonHandlerEvent.endArray:
          case JsonHandlerEvent.endObject:
            lastValue = buffer.removeLast();
            break;
          case JsonHandlerEvent.element:
            buffer.last.add(lastValue);
            break;
          case JsonHandlerEvent.beginKey:
            keys.add(value as String);
            path = keys.join('.');
            break;
          case JsonHandlerEvent.endKey:
            buffer.last[value] = lastValue;
            if (path == 'address.city') {
              if (cities.contains(lastValue)) {
                final user = buffer[buffer.length - 2];
                users.add(user as Map<String, dynamic>);
              }
            }

            keys.removeLast();
            path = keys.join('.');
            break;
          case JsonHandlerEvent.value:
            lastValue = value;
            break;
        }
      }

      final handler = _JsonParserHandler2(handle);
      parser_handler.parse(_data, handler);
      final matcher = [
        {
          "id": 2,
          "name": "Ervin Howell",
          "username": "Antonette",
          "email": "Shanna@melissa.tv",
          "address": {
            "street": "Victor Plains",
            "suite": "Suite 879",
            "city": "Wisokyburgh",
            "zipcode": "90566-7771",
            "geo": {"lat": "-43.9509", "lng": "-34.4618"}
          },
          "phone": "010-692-6593 x09125",
          "website": "anastasia.net",
          "company": {
            "name": "Deckow-Crist",
            "catchPhrase": "Proactive didactic contingency",
            "bs": "synergize scalable supply-chains"
          }
        },
        {
          "id": 8,
          "name": "Nicholas Runolfsdottir V",
          "username": "Maxime_Nienow",
          "email": "Sherwood@rosamond.me",
          "address": {
            "street": "Ellsworth Summit",
            "suite": "Suite 729",
            "city": "Aliyaview",
            "zipcode": "45169",
            "geo": {"lat": "-14.3990", "lng": "-120.7677"}
          },
          "phone": "586.493.6943 x140",
          "website": "jacynthe.com",
          "company": {
            "name": "Abernathy Group",
            "catchPhrase": "Implemented secondary concept",
            "bs": "e-enable extensible e-tailers"
          }
        },
      ];

      expect(users, matcher);
    }
  });
}

_testParserBigInt() async {
  test('JSON parser with BigInt', () {
    {
      final source = ' -100000000000000000000000 ';
      final result = big_int.parse(source);
      expect('$result', BigInt.parse(source).toString());
    }
    {
      final source = ' 100000000000000000000000 ';
      final result = big_int.parse(source);
      expect('$result', BigInt.parse(source).toString());
    }
    {
      final source = ' -10 ';
      final result = big_int.parse(source);
      expect('$result', BigInt.parse(source).toString());
    }
    {
      final source = ' 10 ';
      final result = big_int.parse(source);
      expect('$result', BigInt.parse(source).toString());
    }
    {
      final source = ' 0 ';
      final result = big_int.parse(source);
      expect('$result', BigInt.parse(source).toString());
    }
    {
      final source = ' 1.0 ';
      final result = big_int.parse(source);
      expect(result, 1.0);
    }
    {
      final source = ' -1.0 ';
      final result = big_int.parse(source);
      expect(result, -1.0);
    }
    {
      final source = ' -123.456 ';
      final result = big_int.parse(source);
      expect(result, -123.456);
    }
    {
      final source = ' -123.456E2 ';
      final result = big_int.parse(source);
      expect(result, -123.456E2);
    }
    {
      final source = ' -123.456e2 ';
      final result = big_int.parse(source);
      expect(result, -123.456E2);
    }
    {
      final source = ' -123.456e+2 ';
      final result = big_int.parse(source);
      expect(result, -123.456E2);
    }
    {
      final source = ' -123.456e-2 ';
      final result = big_int.parse(source);
      expect(result, -123.456E-2);
    }
    {
      final source = ' -123E2 ';
      final result = big_int.parse(source);
      expect(result, -123E2);
    }
    {
      final source = ' -123e2 ';
      final result = big_int.parse(source);
      expect(result, -123E2);
    }
    {
      final source = ' -123e+2 ';
      final result = big_int.parse(source);
      expect(result, -123E2);
    }
    {
      final source = ' -123e-2 ';
      final result = big_int.parse(source);
      expect(result, -123E-2);
    }
  });
}

_testParserWeb() async {
  test('JSON parser for wev', () {
    {
      final source = ' -10 ';
      final result = web.parse(source);
      expect('$result', BigInt.parse(source).toString());
    }
    {
      final source = ' 10 ';
      final result = web.parse(source);
      expect('$result', BigInt.parse(source).toString());
    }
    {
      final source = ' 0 ';
      final result = web.parse(source);
      expect('$result', BigInt.parse(source).toString());
    }
    {
      final source = ' 1.0 ';
      final result = web.parse(source);
      expect(result, 1.0);
    }
    {
      final source = ' -1.0 ';
      final result = web.parse(source);
      expect(result, -1.0);
    }
    {
      final source = ' -123.456 ';
      final result = web.parse(source);
      expect(result, -123.456);
    }
    {
      final source = ' -123.456E2 ';
      final result = web.parse(source);
      expect(result, -123.456E2);
    }
    {
      final source = ' -123.456e2 ';
      final result = web.parse(source);
      expect(result, -123.456E2);
    }
    {
      final source = ' -123.456e+2 ';
      final result = web.parse(source);
      expect(result, -123.456E2);
    }
    {
      final source = ' -123.456e-2 ';
      final result = web.parse(source);
      expect(result, -123.456E-2);
    }
    {
      final source = ' -123E2 ';
      final result = web.parse(source);
      expect(result, -123E2);
    }
    {
      final source = ' -123e2 ';
      final result = web.parse(source);
      expect(result, -123E2);
    }
    {
      final source = ' -123e+2 ';
      final result = web.parse(source);
      expect(result, -123E2);
    }
    {
      final source = ' -123e-2 ';
      final result = web.parse(source);
      expect(result, -123E-2);
    }
  });
}

void _testSelector() {
  test('JSON parser selector', () {
    final cities = {'Wisokyburgh', 'Aliyaview'};
    final users = <User>[];
    final level = '[] 0 {}'.split(' ').length;
    void select(JsonSelectorEvent event) {
      if (event.levels.length == level) {
        final map = event.lastValue as Map;
        if (cities.contains(map['address']['city'])) {
          final user = User.fromJson(map);
          users.add(user);
        }

        // Free up memory
        event.lastValue = null;
      }
    }

    parser_selector.parse(_data, select: select);
    final matcher = [
      User(city: 'Wisokyburgh', name: 'Ervin Howell'),
      User(city: 'Aliyaview', name: 'Nicholas Runolfsdottir V'),
    ];
    expect(users, matcher);
  });
}

class User {
  final String city;

  final String name;

  User({required this.city, required this.name});

  @override
  int get hashCode => city.hashCode ^ name.hashCode;

  @override
  bool operator ==(other) {
    return other is User && other.city == city && other.name == name;
  }

  @override
  String toString() {
    return '$name from $city';
  }

  static User fromJson(Map json) {
    return User(
      city: json['address']['city'] as String,
      name: json['name'] as String,
    );
  }
}

class _JsonParserHandler extends JsonParserHandler {
  List buffer = [];
  dynamic lastValue;
  @override
  void handle(JsonHandlerEvent event, dynamic value) {
    switch (event) {
      case JsonHandlerEvent.beginArray:
        buffer.add([]);
        break;
      case JsonHandlerEvent.beginObject:
        buffer.add(<String, dynamic>{});
        break;
      case JsonHandlerEvent.endArray:
      case JsonHandlerEvent.endObject:
        lastValue = buffer.removeLast();
        break;
      case JsonHandlerEvent.element:
        buffer.last.add(lastValue);
        break;
      case JsonHandlerEvent.beginKey:
        // Not used here
        break;
      case JsonHandlerEvent.endKey:
        buffer.last[value] = lastValue;
        break;
      case JsonHandlerEvent.value:
        lastValue = value;
        break;
    }
  }
}

class _JsonParserHandler2 extends parser_handler.JsonParserHandler {
  final void Function(JsonHandlerEvent event, dynamic value) _handler;

  _JsonParserHandler2(this._handler);

  @override
  void handle(JsonHandlerEvent event, dynamic value) => _handler(event, value);
}
