# fast_json

Collection of JSON parsers. Classic parser, event-based parser. Pretty quick parsing.

Version: 0.1.3

## Information

Collection of JSON parsers.  
All parsers are recursive parsers.  
Currently contains the following parsers:

- Classic parser. Slightly slower than Dart SDK but with better error reporting system
- Event-based parser. A synchronous parser that does not store the results of the parsing, but instead invokes an event handler. Useful for reading data with filtering
- Selector implemented on top of an event-based parser. Simplifies data selection with just one event

## Example using FastJsonSelector

Part of `example\example_select.dart`

```dart
import 'package:fast_json/fast_json_selector.dart';

void main(List<String> args) {
  {
    // Show how levels are organized
    void handle(FastJsonSelectorEvent event) {
      print('${event.levels.length}: ${event.levels.join(' ')}');
    }

    FastJsonSelector().parse(_data, select: handle);
  }

  {
    // Find users from these cities
    final cities = {'McKenziehaven', 'Wisokyburgh'};
    final users = <User>[];
    final level = '{} data [] 0 {}'.split(' ').length;
    void select(FastJsonSelectorEvent event) {
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

    FastJsonSelector().parse(_data, select: select);
    print(users.join(', '));
  }

  {
    // Select all websites
    final websites = <String>[];
    final level = '{} data [] 0 {}'.split(' ').length;
    void select(FastJsonSelectorEvent event) {
      if (event.levels.length == level) {
        final map = event.lastValue as Map;
        final website = map['website'] as String;
        websites.add(website);
        // Free up memory
        event.lastValue = null;
      }
    }

    FastJsonSelector().parse(_data, select: select);
    print(websites.join(', '));
  }

  {
    // Select all companies
    final companies = <Company>[];
    final level = '{} data [] 0 {}'.split(' ').length;
    void select(FastJsonSelectorEvent event) {
      // 5:  . data [] 0 .
      if (event.levels.length == level) {
        final map = event.lastValue as Map;
        final company = Company.fromJson(map['company'] as Map);
        companies.add(company);
        // Free up memory
        event.lastValue = null;
      }
    }

    FastJsonSelector().parse(_data, select: select);
    print(companies.join(', '));
  }

  {
    // Select all companies for users from South Elvis
    final companies = <Company>[];
    final level = '{} data [] 0 {}'.split(' ').length;
    void select(FastJsonSelectorEvent event) {
      if (event.levels.length == level) {
        final map = event.lastValue as Map;
        if (map['address']['city'] == 'South Elvis') {
          final company = Company.fromJson(map['company'] as Map);
          companies.add(company);
        }

        // Free up memory
        event.lastValue = null;
      }
    }

    FastJsonSelector().parse(_data, select: select);
    print(companies.join(', '));
  }

  {
    // Select users [2..4]
    final users = <User>[];
    final level = '{} data [] 0 {}'.split(' ').length;
    void select(FastJsonSelectorEvent event) {
      final levels = event.levels;
      // 5:  . data [] 0 .
      if (levels.length == level) {
        // 4: . data [] 0
        final index = event.levels[levels.length - 2] as int;
        if (index >= 2 && index <= 4) {
          final map = event.lastValue as Map;
          final user = User.fromJson(map);
          users.add(user);
        }

        // Free up memory
        event.lastValue = null;
      }
    }

    FastJsonSelector().parse(_data, select: select);
    print(users.join(', '));
  }
}

const _data = '''
{
   "success":true,
   "data":[
      {
         "id":1,
         "name":"Leanne Graham",
         "username":"Bret",
         "email":"Sincere@april.biz",
         "address":{
            "street":"Kulas Light",
            "suite":"Apt. 556",
            "city":"Gwenborough",
            "zipcode":"92998-3874",
            "geo":{
               "lat":"-37.3159",
               "lng":"81.1496"
            }
         },
         "phone":"1-770-736-8031 x56442",
         "website":"hildegard.org",
         "company":{
            "name":"Romaguera-Crona",
            "catchPhrase":"Multi-layered client-server neural-net",
            "bs":"harness real-time e-markets"
         }
      },
      {
         "id":2,
         "name":"Ervin Howell",
         "username":"Antonette",
         "email":"Shanna@melissa.tv",
         "address":{
            "street":"Victor Plains",
            "suite":"Suite 879",
            "city":"Wisokyburgh",
            "zipcode":"90566-7771",
            "geo":{
               "lat":"-43.9509",
               "lng":"-34.4618"
            }
         },
         "phone":"010-692-6593 x09125",
         "website":"anastasia.net",
         "company":{
            "name":"Deckow-Crist",
            "catchPhrase":"Proactive didactic contingency",
            "bs":"synergize scalable supply-chains"
         }
      },
      {
         "id":3,
         "name":"Clementine Bauch",
         "username":"Samantha",
         "email":"Nathan@yesenia.net",
         "address":{
            "street":"Douglas Extension",
            "suite":"Suite 847",
            "city":"McKenziehaven",
            "zipcode":"59590-4157",
            "geo":{
               "lat":"-68.6102",
               "lng":"-47.0653"
            }
         },
         "phone":"1-463-123-4447",
         "website":"ramiro.info",
         "company":{
            "name":"Romaguera-Jacobson",
            "catchPhrase":"Face to face bifurcated interface",
            "bs":"e-enable strategic applications"
         }
      },
      {
         "id":4,
         "name":"Patricia Lebsack",
         "username":"Karianne",
         "email":"Julianne.OConner@kory.org",
         "address":{
            "street":"Hoeger Mall",
            "suite":"Apt. 692",
            "city":"South Elvis",
            "zipcode":"53919-4257",
            "geo":{
               "lat":"29.4572",
               "lng":"-164.2990"
            }
         },
         "phone":"493-170-9623 x156",
         "website":"kale.biz",
         "company":{
            "name":"Robel-Corkery",
            "catchPhrase":"Multi-tiered zero tolerance productivity",
            "bs":"transition cutting-edge web services"
         }
      },
      {
         "id":5,
         "name":"Chelsey Dietrich",
         "username":"Kamren",
         "email":"Lucio_Hettinger@annie.ca",
         "address":{
            "street":"Skiles Walks",
            "suite":"Suite 351",
            "city":"Roscoeview",
            "zipcode":"33263",
            "geo":{
               "lat":"-31.8129",
               "lng":"62.5342"
            }
         },
         "phone":"(254)954-1289",
         "website":"demarco.info",
         "company":{
            "name":"Keebler LLC",
            "catchPhrase":"User-centric fault-tolerant solution",
            "bs":"revolutionize end-to-end systems"
         }
      }
   ]
}''';

class Company {
  final String name;

  Company({required this.name});

  @override
  String toString() {
    return name;
  }

  static Company fromJson(Map json) {
    return Company(
      name: json['name'] as String,
    );
  }
}

class User {
  final String city;
  final int id;
  final String name;

  User({required this.city, required this.id, required this.name});

  @override
  String toString() {
    return '$id:$name from $city';
  }

  static User fromJson(Map json) {
    return User(
      city: json['address']['city'] as String,
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

```