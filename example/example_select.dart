import 'package:fast_json/fast_json_selector.dart' as parser;
import 'package:fast_json/fast_json_selector.dart' show JsonSelectorEvent;

void main(List<String> args) {
  {
    // Show how levels are organized
    void select(JsonSelectorEvent event) {
      print('Level: ${event.levels.length}: ${event.levels.join(' ')}');
      print('Index: ${event.index}');
    }

    parser.parse(_data, select: select);
  }

  {
    // Find users from these cities
    final cities = {'McKenziehaven', 'Wisokyburgh'};
    final users = <User>[];
    final level = '{} data [] 0 {}'.split(' ').length;
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

    parser.parse(_data, select: select);
    print(users.join(', '));
  }

  {
    // Select users from the list by indexes [2..3] and terminate selection
    final users = <User>[];
    final level = '{} data [] 0 {}'.split(' ').length;
    void select(JsonSelectorEvent event) {
      final levels = event.levels;
      if (levels.length == level) {
        final index = event.index;
        if (index >= 2 && index <= 3) {
          final map = event.lastValue as Map;
          final user = User.fromJson(map);
          users.add(user);
        }

        // Free up memory
        event.lastValue = null;
        if (users.length == 2) {
          throw const _TerminateException();
        }
      }
    }

    try {
      parser.parse(_data, select: select);
    } on _TerminateException {
      //
    }

    print(users.join(', '));
  }

  {
    // Select all websites
    final websites = <String>[];
    final level = '{} data [] 0 {}'.split(' ').length;
    void select(JsonSelectorEvent event) {
      if (event.levels.length == level) {
        final map = event.lastValue as Map;
        final website = map['website'] as String;
        websites.add(website);
        // Free up memory
        event.lastValue = null;
      }
    }

    parser.parse(_data, select: select);
    print(websites.join(', '));
  }

  {
    // Select all companies
    final companies = <Company>[];
    final level = '{} data [] 0 {}'.split(' ').length;
    void select(JsonSelectorEvent event) {
      if (event.levels.length == level) {
        final map = event.lastValue as Map;
        final company = Company.fromJson(map['company'] as Map);
        companies.add(company);
        // Free up memory
        event.lastValue = null;
      }
    }

    parser.parse(_data, select: select);
    print(companies.join(', '));
  }

  {
    // Select all companies for users from South Elvis
    final companies = <Company>[];
    final level = '{} data [] 0 {}'.split(' ').length;
    void select(JsonSelectorEvent event) {
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

    parser.parse(_data, select: select);
    print(companies.join(', '));
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

class _TerminateException {
  const _TerminateException();
}
