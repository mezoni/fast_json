## 0.1.5

- After updates to the `parser builder`, changes were made to the parser builders so that the generated parsers better display errors in case of an `unterminated` string. Now there are two errors, one at the beginning of the string (new feature) and one at the end of the file

## 0.1.4

- Added an example of how to terminate selection without waiting for parsing to the end of the entire file

## 0.1.3

- Implemented and tested parser-selector
- Breaking change. The class `JsonEvent` has been renamed to `JsonHandlerEvent`. This is done to be symmetrical with the new `JsonSelectorEvent` class

## 0.1.2

- Changes have been made to the `build_fast_json_handler.dart` parser builder so that unused variables are not generated

## 0.1.1

- Changes have been made to the example script `example/example.dart`. It now correctly discards any data other than those that match the criteria. Data that does not meet the criteria is not added to the result array

## 0.1.0

- Initial release