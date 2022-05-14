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

```