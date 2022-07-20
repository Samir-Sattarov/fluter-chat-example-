import 'package:flutter/material.dart';

class FormValidator {
  static String? empty(
    String? value,
    String errorMessage,
  ) {
    if (value == null || value.length <= 3) {
      return 'Required';
    }
    return null;
  }

  static String? validateEmail(value) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value ?? '');
    if (value == null || value.isEmpty || !emailValid) {
      return 'Please enter email';
    }
    return null;
  }

  static String? password(String? value) {
    if (empty(value, 'Required') != null) {
      return empty(value, 'Required');
    }
    RegExp regEx = RegExp(r"(?=.*[A-Z])\w+");
    if (value!.length < 8 || !regEx.hasMatch(value)) {
      return 'Please enter password';
    }
    return null;
  }

  static String? passwordConfirm(value, TextEditingController controller) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }
    if (value.toString() != controller.text) {
      return 'Required';
    }
    return null;
  }
}
