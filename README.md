# fast_json

Collection of JSON parsers. Classic parser, event-based parser. Pretty quick parsing.

Version: 0.1.0

## Information

Collection of JSON parsers.  
All parsers are recursive parsers.  
Currently contains the following parsers:

- Classic parser. Slightly slower than Dart SDK but with better error reporting system
- Event-based parser. A synchronous parser that does not store the results of the parsing, but instead invokes an event handler. Useful for reading data with filtering
