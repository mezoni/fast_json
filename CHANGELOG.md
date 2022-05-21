## 0.1.10

- Implemented and tested parser with `JavaScript` support. It parses very slowly in a web browser and quite fast in a non-browser. Not optimized for parsing numbers

## 0.1.9

- Implemented and tested parser with `BigInt` support
- `Unterminated string` error generation has been refactored

## 0.1.8

- Fixed bug in `parser-selector`

## 0.1.7

- Breaking change. The changes concern `parser-selector`. Array indexes are now specified in the list of levels always with the same value `0`. This allows to uniquely identify the full path (if necessary) from the list of `levels`. Also added an `index` field to get the index of the current array

## 0.1.6

- After the release of the new version of `parser_builder`, the implemented `BinarySearchBuilder` generates highly efficient predicates for character testing. The handwritten predicate for string character testing has been replaced with `CharClass`. Now the predicate code has become even more correct and no less fast

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