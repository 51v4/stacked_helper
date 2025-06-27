import 'package:flutter/material.dart';

typedef FormFieldStringValidator = String? Function(String? val);

class CustomValidator {
  final bool optional;

  CustomValidator({
    this.optional = false,
  });

  final List<FormFieldStringValidator> _validations = [];

  void _createValidation(FormFieldStringValidator validator) {
    _validations.add(validator);
  }

  FormFieldStringValidator validate() => _validate;

  String? _validate(String? val) {
    if (optional && (val == null || val.isEmpty)) {
      return null;
    }

    for (int idx = 0; idx < _validations.length; idx++) {
      String? res = _validations[idx].call(val);
      if (res != null) {
        return res;
      }
    }
    return null;
  }

  /// field required
  CustomValidator required({
    String message = 'Required',
  }) {
    _createValidation((val) {
      if (val == null || val.isEmpty) {
        return message;
      }
      return null;
    });
    return this;
  }

  /// range validation
  CustomValidator range({
    required int min,
    required int max,
    String? message,
  }) {
    _createValidation((val) {
      int? value = int.tryParse(val!);
      if (value == null) {
        return message ?? 'Invalid Number';
      }
      if (value < min) return message ?? 'Should be between $min and $max';
      if (value > max) return message ?? 'Should be between $min and $max';

      return null;
    });
    return this;
  }

  // minimum length required
  CustomValidator minLength(
    int len, {
    String? message,
  }) {
    _createValidation((val) {
      if (val!.length < len) return message ?? 'Minimum Length : $len';
      return null;
    });
    return this;
  }

  // maximum lenght required
  CustomValidator maxLength(
    int len, {
    String? message,
  }) {
    _createValidation((val) {
      if (val!.length > len) return message ?? 'Maximum Length : $len';

      return null;
    });
    return this;
  }

  // matching the values of two controllers
  CustomValidator matchControllers(
    TextEditingController a, {
    String message = 'Does not match',
  }) {
    _createValidation((val) {
      if (a.text != val) return message;

      return null;
    });

    return this;
  }

  // length
  CustomValidator length(
    int len, {
    String? message,
  }) {
    _createValidation((val) {
      if (val!.length != len) {
        return message ?? 'Length should be $len';
      }

      return null;
    });
    return this;
  }

  // validate PAN INDIA
  CustomValidator validPanIND({
    String message = 'Invalid PAN',
  }) {
    String pattern = r'^(([a-zA-Z]{5})([0-9]{4})([a-zA-Z]{1})$)';
    RegExp regex = RegExp(pattern);
    return matchRegex(regex, message);
  }

  // validate PAN INDIA
  CustomValidator validIFSC({
    String message = 'Invalid IFSC',
  }) {
    String pattern = r'^[A-Z]{4}0[A-Z0-9]{6}$';
    RegExp regex = RegExp(pattern);
    return matchRegex(regex, message);
  }

  // validate Email
  CustomValidator validEmail({
    String message = 'Invalid Email',
  }) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(pattern);
    return matchRegex(regex, message);
  }

  // validate regex
  CustomValidator matchRegex(RegExp regex, String errorMessage) {
    _createValidation((val) {
      if (!regex.hasMatch(val!)) {
        return errorMessage;
      }
      return null;
    });
    return this;
  }

  // validte strong passwords
  CustomValidator strongPassword({
    String message =
        'Your password should contain atleast 8 characters, 1 uppercase, 1 lowercase, 1 number and 1 special character',
  }) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);
    return matchRegex(regex, message);
  }

  // validate account number
  CustomValidator validAccountNumber({
    String message = 'Invalid Account Number',
  }) {
    String pattern = r'^[0-9]{9,18}$';
    RegExp regex = RegExp(pattern);
    return matchRegex(regex, message);
  }

  // validate UPI ID
  CustomValidator validUpiID({
    String message = 'Invalid UPI ID',
  }) {
    String pattern = r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$';
    RegExp regex = RegExp(pattern);
    return matchRegex(regex, message);
  }

  // validate Indian Zip code
  CustomValidator validIndianZipCode({
    String message = 'Invalid Zip Code',
  }) {
    String pattern = r'^[1-9]{1}[0-9]{2}\s{0,1}[0-9]{3}$';
    RegExp regex = RegExp(pattern);
    return matchRegex(regex, message);
  }

  // validate credit card number
  CustomValidator validCreditCardNumber({
    String message = 'Invalid Credit Card Number',
  }) {
    String pattern = r'^[0-9]{16}$';
    RegExp regex = RegExp(pattern);
    return matchRegex(regex, message);
  }

  String? requiredObjectValidator<T>(
    T? value, {
    String message = 'Required',
  }) {
    if (value == null) {
      return message;
    }
    return null;
  }
}
