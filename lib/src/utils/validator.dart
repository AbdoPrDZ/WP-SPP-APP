import 'dart:convert';

import 'package:get/get.dart';

import 'm_datetime.dart';
import 'm_list.dart';
import 'm_string.dart';

/// A class that contains a list of validation functions.
///
/// The `Validator` class provides a set of predefined validation functions
/// that can be used to validate various types of input data. Each validator
/// is represented by a factory constructor that returns an instance of
/// `Validator` with specific validation logic.
///
/// The class supports various types of validations such as required fields,
/// email format, phone number format, password strength, minimum and maximum
/// length, and more. It also allows combining multiple validators and creating
/// custom validators.
///
/// Example usage:
/// ```dart
/// final validator = Validator.required();
/// final result1 = validator.validate('value');
/// final result2 = validator.validate('');
///
/// print("1: " + result1.firstOrNull?.message);
/// print("2: " + result2.firstOrNull?.message);
/// ```
///
/// Output:
/// ```log
/// 1: null
/// 2: validator.required
/// ```
class Validator {
  /// The name of the validator.
  final String name;

  /// The list of validation functions.
  final List<ValidateResult Function(String value)> validates;

  /// The arguments of the validator.
  final List<String> args;

  const Validator({
    required this.name,
    required this.validates,
    this.args = const [],
  });

  /// Validate the given value.
  /// Returns a list of [ValidateResult]s.
  /// If the value is valid, the list will be empty.
  /// If the value is invalid, the list will contain the error message.
  ///
  /// Usage:
  /// ```dart
  /// final validator = Validator.required();
  /// final result1 = validator.validate('value');
  /// final result2 = validator.validate('');
  ///
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: validator.required
  /// ```
  ValidateResults validate(String value) {
    final results = <ValidateResult>[];

    for (final validate in validates) {
      final result = validate(value);
      if (!result.isValid) {
        results.add(result);
        break;
      }
    }

    return ValidateResults(results);
  }

  /// A validator that requires the value to be non-empty.
  ///
  /// Usage:
  ///   ```dart
  ///   final validator = Validator.required();
  ///   final result1 = validator.validate('value');
  ///   final result2 = validator.validate('');
  ///   print("1: " + result1.firstOrNull?.message);
  ///   print("2: " + result2.firstOrNull?.message);
  ///   ```
  ///
  /// Output:
  ///   ```log
  ///   1: null
  ///   2: validator.required
  ///   ```
  factory Validator.required([String? attribute]) => Validator(
        name: 'required',
        validates: [
          (text) => ValidateResult(
                isValid: text.isNotEmpty,
                message: 'validator.required'.trParams({
                  'attribute': attribute ?? 'attribute',
                }),
              )
        ],
      );

  /// A validator that requires the value to be a valid email address.
  ///
  /// Usage:
  ///   ```dart
  ///   final validator = Validator.email();
  ///   final result1 = validator.validate('value');
  ///   final result2 = validator.validate('value@');
  ///   print("1: " + result1.firstOrNull?.message);
  ///   print("2: " + result2.firstOrNull?.message);
  ///   ```
  ///
  /// Output:
  ///   ```log
  ///   1: null
  ///   2: validator.email
  ///   ```
  factory Validator.email([String? attribute]) => Validator(
        name: 'email',
        validates: [
          (text) => ValidateResult(
                isValid: text.isNotEmpty && GetUtils.isEmail(text),
                message: 'validator.email'.trParams({
                  'attribute': attribute ?? 'attribute',
                }),
              )
        ],
      );

  /// A validator that requires the value to be a valid phone number.
  ///
  /// Usage:
  /// ```dart
  /// final validator = Validator.phone();
  /// final result1 = validator.validate('1234567890');
  /// final result2 = validator.validate('123456789');
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: validator.phone
  /// ```
  factory Validator.phone([String? attribute]) => Validator(
        name: 'phone',
        validates: [
          (text) => ValidateResult(
                isValid: text.isNotEmpty && text.isPhoneNumber,
                message: 'validator.phone'.trParams({
                  'attribute': attribute ?? 'attribute',
                }),
              )
        ],
      );

  /// A validator that requires the value to be a valid password.
  ///
  /// Usage:
  ///  ```dart
  /// final validator = Validator.password();
  /// final result1 = validator.validate('123456');
  /// final result2 = validator.validate('12345');
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: validator.password
  /// ```
  factory Validator.password([String? attribute]) => Validator(
        name: 'password',
        validates: [
          (text) => ValidateResult(
                isValid: text.isNotEmpty && text.length >= 6,
                message: 'validator.password'.trParams({
                  'attribute': attribute ?? 'attribute',
                }),
              )
        ],
      );

  /// A validator that validates the value is at least [value] characters long when [type] is 'length' or at least [length] when [type] is 'number'.
  ///
  /// Usage:
  /// ```dart
  /// // When type is 'length'
  /// final validator1 = Validator.min('length', 8);
  /// final result1 = validator.validate('12345678');
  /// final result2 = validator.validate('1234567');
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  ///
  /// // When type is 'number'
  /// final validator2 = Validator.min('number', 8);
  /// final result3 = validator.validate('8');
  /// final result4 = validator.validate('7');
  /// print("3: " + result3.firstOrNull?.message);
  /// print("4: " + result4.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: validator.min_length
  /// 3: null
  /// 4: validator.min_number
  /// ```
  factory Validator.min(String type, double value, [String? attribute]) {
    if (!['length', 'number'].contains(type)) {
      throw 'Invalid type $type';
    }
    return Validator(
      name: 'min',
      validates: [
        (text) => ValidateResult(
              isValid: type == 'length'
                  ? text.length >= value
                  : text.isNotEmpty && text.toDouble >= value,
              message: 'validator.min_$type'.trParams({
                'attribute': attribute ?? 'attribute',
                'value': '$value',
              }),
            )
      ],
    );
  }

  /// A validator that validates the value is at most [value] characters long when [type] is 'length' or at most [length] when [type] is 'number'.
  ///
  /// Usage:
  /// ```dart
  /// // When type is 'length'
  /// final validator1 = Validator.max('length', 8);
  /// final result1 = validator.validate('12345678');
  /// final result2 = validator.validate('123456789');
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  ///
  /// // When type is 'number'
  /// final validator2 = Validator.max('number', 8);
  /// final result3 = validator.validate('8');
  /// final result4 = validator.validate('9');
  /// print("3: " + result3.firstOrNull?.message);
  /// print("4: " + result4.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: validator.max_length
  /// 3: null
  /// 4: validator.max_number
  /// ```
  factory Validator.max(String type, double value, [String? attribute]) {
    if (!['length', 'number'].contains(type)) {
      throw 'Invalid type $type';
    }
    return Validator(
      name: 'max',
      validates: [
        (text) => ValidateResult(
              isValid: type == 'length'
                  ? text.length <= value
                  : text.isNotEmpty && text.toDouble <= value,
              message: 'validator.max'.trParams({'value': '$value'}),
            )
      ],
    );
  }

  /// A validator that validates the value is between [min] and [max] characters long when [type] is 'length' or between [min] and [max] when [type] is 'number'.
  ///
  /// Usage:
  /// ```dart
  /// // When type is 'length'
  /// final validator1 = Validator.between('length', 8, 10);
  /// final result1 = validator.validate('12345678');
  /// final result2 = validator.validate('123456789');
  /// final result3 = validator.validate('1234567890');
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// print("3: " + result3.firstOrNull?.message);
  ///
  /// // When type is 'number'
  /// final validator2 = Validator.between('number', 8, 10);
  /// final result4 = validator.validate('8');
  /// final result5 = validator.validate('9');
  /// final result6 = validator.validate('10');
  /// print("4: " + result4.firstOrNull?.message);
  /// print("5: " + result5.firstOrNull?.message);
  /// print("6: " + result6.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: null
  /// 3: validator.between_length
  /// 4: null
  /// 5: null
  /// 6: validator.between_number
  /// ```
  factory Validator.between(
    String type,
    int min,
    int max, [
    String? attribute,
  ]) {
    if (!['length', 'number'].contains(type)) {
      throw 'Invalid type $type';
    }
    return Validator(
      name: 'between',
      validates: [
        (text) => ValidateResult(
              isValid: type == 'length'
                  ? text.length >= min && text.length <= max
                  : text.isNotEmpty &&
                      (text.toDouble >= min && text.toDouble <= max),
              message: 'validator.between_$type'.trParams({
                'attribute': attribute ?? 'attribute',
                'min': '$min',
                'max': '$max',
              }),
            ),
      ],
    );
  }

  /// A validator that requires the value to be an integer.
  ///
  /// Usage:
  /// ```dart
  /// final validator = Validator.integer();
  /// final result1 = validator.validate('123');
  /// final result2 = validator.validate('123.45');
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: validator.integer
  /// ```
  factory Validator.integer([String? attribute]) => Validator(
        name: 'integer',
        validates: [
          (text) => ValidateResult(
                isValid: text.isNotEmpty && int.tryParse(text) != null,
                message: 'validator.integer'.trParams({
                  'attribute': attribute ?? 'attribute',
                }),
              )
        ],
      );

  /// A validator that requires the value to be a double.
  ///
  /// Usage:
  /// ```dart
  /// final validator = Validator.double();
  /// final result1 = validator.validate('123');
  /// final result2 = validator.validate('123.45');
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: validator.double
  /// ```
  factory Validator.double([String? attribute]) => Validator(
        name: 'double',
        validates: [
          (text) => ValidateResult(
                isValid: text.isNotEmpty && double.tryParse(text) != null,
                message: 'validator.double'.trParams({
                  'attribute': attribute ?? 'attribute',
                }),
              )
        ],
      );

  /// A validator that requires the value to be a boolean.
  ///
  /// Usage:
  /// ```dart
  /// final validator = Validator.boolean();
  /// final result1 = validator.validate('true');
  /// final result2 = validator.validate('false');
  /// final result3 = validator.validate('123');
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// print("3: " + result3.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: null
  /// 3: validator.boolean
  /// ```
  factory Validator.boolean([String? attribute]) => Validator(
        name: 'boolean',
        validates: [
          (text) => ValidateResult(
                isValid: text.isNotEmpty && text.isBool,
                message: 'validator.boolean'.trParams({
                  'attribute': attribute ?? 'attribute',
                }),
              )
        ],
      );

  /// A validator that requires the value to be in the given list of [values].
  ///
  /// Usage:
  /// ```dart
  /// final validator = Validator.inArray(['value1', 'value2']);
  /// final result1 = validator.validate('value1');
  /// final result2 = validator.validate('value3');
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: validator.in
  /// ```
  factory Validator.inArray(List<String> values, [String? attribute]) =>
      Validator(
        name: 'in',
        validates: [
          (text) => ValidateResult(
                isValid: text.isNotEmpty && values.contains(text),
                message: 'validator.in'.trParams({
                  'attribute': attribute ?? 'attribute',
                  'values': values.join(', '),
                }),
              )
        ],
      );

  /// A validator that requires the value to be a valid URL.
  ///
  /// Usage:
  /// ```dart
  /// final validator = Validator.url();
  /// final result1 = validator.validate('https://example.com');
  /// final result2 = validator.validate('example.com');
  ///
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: validator.url
  /// ```
  factory Validator.url([String? attribute]) => Validator(
        name: 'url',
        validates: [
          (text) => ValidateResult(
                isValid: text.isNotEmpty && GetUtils.isURL(text),
                message: 'validator.url'.trParams({
                  'attribute': attribute ?? 'attribute',
                }),
              )
        ],
      );

  /// A validator that requires the value to be in the given list of [values].
  ///
  /// Usage:
  /// ```dart
  /// final serverErrors = {'field': 'error message'};
  /// final validator = Validator.inServerError(serverErrors, 'field');
  /// final result1 = validator.validate('value1');
  /// final result2 = validator.validate('value3');
  ///
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: error message
  /// ```
  factory Validator.inServerError(Map<String, String> serverErors, String field,
          [String? attribute]) =>
      Validator(
        name: 'in_server_errors',
        validates: [
          (text) => ValidateResult(
                isValid: !serverErors.containsKey(field),
                message: serverErors[field],
              )
        ],
      );

  /// A validator that requires the value to be equal to [value].
  ///
  /// Usage:
  /// ```dart
  /// final validator = Validator.equals('value');
  /// final result1 = validator.validate('value');
  /// final result2 = validator.validate('value1');
  ///
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: validator.equals
  /// ```
  factory Validator.equals(String value, String eAttribute,
          [String? attribute]) =>
      Validator(
        name: 'equals',
        validates: [
          (text) => ValidateResult(
                isValid: text.isNotEmpty && text == value,
                message: 'validator.equals'.trParams({
                  'attribute': attribute ?? 'attribute',
                  'eAttribute': eAttribute,
                }),
              )
        ],
      );

  /// A validator that requires the value to be different from [value].
  ///
  /// Usage:
  /// ```dart
  /// final validator = Validator.different('value');
  /// final result1 = validator.validate('value');
  /// final result2 = validator.validate('value1');
  ///
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: validator.not_equals
  /// 2: null
  /// ```
  factory Validator.different(String value, String dAttribute,
          [String? attribute]) =>
      Validator(
        name: 'different',
        validates: [
          (text) => ValidateResult(
                isValid: text.isNotEmpty && text != value,
                message: 'validator.different'.trParams({
                  'attribute': attribute ?? 'attribute',
                  'dAttribute': dAttribute,
                }),
              )
        ],
      );

  /// A validator that requires the value to be a valid date.
  ///
  /// Usage:
  /// ```dart
  /// final validator = Validator.date();
  /// final result1 = validator.validate('2021-01-01');
  /// final result2 = validator.validate('2021-01-32');
  /// final result3 = validator.validate('2021-01-30 string');
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// print("3: " + result3.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: validator.datetime
  /// 3: validator.datetime
  /// ```
  factory Validator.datetime([
    String format = 'yyyy-MM-dd HH:mm:ss',
    String? attribute,
  ]) =>
      Validator(
        name: 'datetime',
        validates: [
          (text) => ValidateResult(
                isValid: text.isNotEmpty &&
                    MDateTime.fromString(text, format: format) != null,
                message: 'validator.datetime'.trParams({
                  'attribute': attribute ?? 'attribute',
                  'format': format,
                }),
              )
        ],
      );

  /// A list of custom validators.
  static List<Validator> appends = [];

  /// Merge two validators.
  ///
  /// The name of the new validator will be the concatenation of the two names separated by '|'.
  ///
  /// The list of validation functions will be the concatenation of the two lists.
  Validator operator +(Validator other) => Validator(
        name: '$name|${other.name}',
        validates: validates + other.validates,
      );

  /// Create a validator from a string of rules.
  /// The string is a list of rules separated by '|'.
  /// Each rule can have arguments separated by ':'.
  /// Example: 'required|email|min:8|max:16'
  /// The above example will create a validator that requires the value to be non-empty, a valid email address, and between 8 and 16 characters long.
  /// The available rules are:
  /// - required @see [Validator.required]
  /// - email @see [email]
  /// - phone @see [phone]
  /// - password @see [password]
  /// - integer @see [integer]
  /// - double @see [double]
  /// - boolean @see [boolean]
  /// - min @see [min]
  /// - max @see [max]
  /// - between @see [between]
  /// - in @see [inArray]
  /// - in_server_errors @see [inServerError]
  /// - url @see [url]
  /// - equals @see [equals]
  /// - different @see [different]
  /// - datetime @see [datetime]
  /// - date @see [datetime]
  /// - time @see [datetime]
  /// - any custom validator added to [Validator.appends]
  ///
  /// Usage:
  /// ```dart
  /// final validator = Validator.make('required|email|min:8|max:16');
  /// final result1 = validator.validate('value');
  /// final result2 = validator.validate('value@');
  /// final result3 = validator.validate('1234567');
  ///
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// print("3: " + result3.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: validator.email
  /// 3: validator.min_length
  /// ```
  factory Validator.make(String rules, String attribute) {
    List<Validator> validators = [];

    for (var rule in rules.split('|')) {
      List<String> args = [];

      if (rule.contains(":")) {
        final parts = rule.split(':');
        rule = parts[0];
        args = parts[1].split(',');
      }

      switch (rule) {
        case 'required':
          validators.add(Validator.required(attribute));
          break;
        case 'email':
          validators.add(Validator.email(attribute));
          break;
        case 'phone':
          validators.add(Validator.phone(attribute));
          break;
        case 'password':
          validators.add(Validator.password(attribute));
          break;
        case 'integer':
          validators.add(Validator.integer(attribute));
          break;
        case 'double':
          validators.add(Validator.double(attribute));
          break;
        case 'boolean':
          validators.add(Validator.boolean(attribute));
          break;
        case 'min':
          validators.add(Validator.min(
            args.getOrNull(1) ?? 'length',
            double.parse(args[0]),
            attribute,
          ));
          break;
        case 'max':
          validators.add(Validator.max(
            args.getOrNull(1) ?? 'length',
            double.parse(args[0]),
            attribute,
          ));
          break;
        case 'between':
          validators.add(Validator.between(
            args.getOrNull(2) ?? 'length',
            int.parse(args[0]),
            int.parse(args[1]),
            attribute,
          ));
          break;
        case 'in':
          validators.add(Validator.inArray(args, attribute));
          break;
        case 'in_server_errors':
          validators.add(Validator.inServerError(
            Map<String, String>.from(jsonDecode(args[0])),
            args[1],
            attribute,
          ));
          break;
        case 'url':
          validators.add(Validator.url(attribute));
          break;
        case 'equals':
          validators.add(Validator.equals(args[0], args[1], attribute));
          break;
        case 'different':
          validators.add(Validator.different(args[0], args[1], attribute));
          break;
        case 'datetime':
          validators.add(Validator.datetime(
            args.firstOrNull ?? 'yyyy-MM-dd HH:mm:ss',
            attribute,
          ));
          break;
        case 'date':
          validators.add(Validator.datetime(
            args.firstOrNull ?? 'yyyy-MM-dd',
            attribute,
          ));
          break;
        case 'time':
          validators.add(Validator.datetime(
            args.firstOrNull ?? 'HH:mm:ss',
            attribute,
          ));
          break;
        default:
          validators.add(appends.firstWhere(
            (v) => v.name == rule,
            orElse: () => throw 'Validator $rule not found',
          ));
      }
    }

    return validators.reduce((value, element) => value + element);
  }
}

/// A class that contains the result of a validation.
///
/// The class is used to validate a value.
///
/// If the value is valid, [isValid] will be true.
///
/// If the value is invalid, [isValid] will be false and [message] will contain the error message.
class ValidateResult {
  /// Whether the value is valid.
  final bool isValid;

  /// The error message if the value is invalid.
  final String? message;

  const ValidateResult({
    required this.isValid,
    this.message,
  }) : assert(isValid || message != null,
            'message must not be null when isValid is false');
}

/// A class that contains the results of a validation.
///
/// The class is used to validate a value.
///
/// The class contains a list of [ValidateResult]s.
class ValidateResults {
  /// The list of validation results.
  final List<ValidateResult> results;

  const ValidateResults(this.results);

  /// Whether the value is valid.
  ///
  /// If all the results are valid, this will be true.
  ///
  /// If any of the results are invalid, this will be false.
  bool get isValid => results.every((element) => element.isValid);

  /// The error message if the value is invalid.
  ///
  /// If any of the results are invalid, this will contain the error message.
  ///
  /// If all the results are valid, this will be null.
  String? get firstOrNull => results.firstOrNull?.message;
}

/// A extension that adds a [validate] method to [String].
extension ValidatorStringExtension on String {
  /// Validate the value using the given rules.
  /// Returns a list of [ValidateResult]s.
  ///
  /// Usage:
  /// ```dart
  /// final result1 = 'value'.validate('required|email|min:8|max:16');
  /// final result2 = 'value@'.validate('required|email|min:8|max:16');
  /// final result3 = '1234567'.validate('required|email|min:8|max:16');
  ///
  /// print("1: " + result1.firstOrNull?.message);
  /// print("2: " + result2.firstOrNull?.message);
  /// print("3: " + result3.firstOrNull?.message);
  /// ```
  ///
  /// Output:
  /// ```log
  /// 1: null
  /// 2: validator.email
  /// 3: validator.min_length
  /// ```
  ValidateResults validate(String rules, String attribute) =>
      Validator.make(rules, attribute).validate(this);
}
