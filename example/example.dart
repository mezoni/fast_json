import 'package:fast_json/fast_json_handler.dart' as parser;
import 'package:fast_json/fast_json_handler.dart'
    show JsonHandlerEvent, JsonParserHandler;

/// An example of filtering JSON data without reading parsing results into
/// memory.
void main(List<String> args) {
  List buffer = [];
  dynamic lastValue;
  final keys = <String>[];
  var path = '';
  // This is a search criteria
  final cities = {'McKenziehaven', 'Wisokyburgh'};
  var isSatisfies = false;
  var level = 0;
  void handle(JsonHandlerEvent event, dynamic value) {
    switch (event) {
      case JsonHandlerEvent.beginArray:
        buffer.add([]);
        break;
      case JsonHandlerEvent.beginObject:
        level++;
        buffer.add(<String, dynamic>{});
        break;
      case JsonHandlerEvent.endArray:
        lastValue = buffer.removeLast();
        break;
      case JsonHandlerEvent.endObject:
        level--;
        lastValue = buffer.removeLast();
        break;
      case JsonHandlerEvent.element:
        if (level > 0) {
          buffer.last.add(lastValue);
        } else if (isSatisfies) {
          buffer.last.add(lastValue);
        }

        break;
      case JsonHandlerEvent.beginKey:
        keys.add(value as String);
        path = keys.join('.');
        break;
      case JsonHandlerEvent.endKey:
        buffer.last[value] = lastValue;
        if (path == 'address.city') {
          isSatisfies = cities.contains(lastValue);
        }

        keys.removeLast();
        path = keys.join('.');
        break;
      case JsonHandlerEvent.value:
        // Handle values not allowed here
        lastValue = value;
        break;
    }
  }

  final handler = _JsonParserHandler(handle);
  parser.parse(_data, handler);
  final users = (lastValue as List).cast<Map<String, dynamic>>();
  print('Search criteria: cities ${cities.join(', ')}');
  print('Found ${users.length} user(s)');
  for (final user in users) {
    print('${user['name']} from ${user['address']['city']}');
  }
}

const _data = '''
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
  }
]''';

class _JsonParserHandler extends JsonParserHandler {
  final void Function(JsonHandlerEvent event, dynamic value) _handler;

  _JsonParserHandler(this._handler);

  @override
  void handle(JsonHandlerEvent event, dynamic value) => _handler(event, value);
}
