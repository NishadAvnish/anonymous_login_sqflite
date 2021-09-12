import 'package:flutter/material.dart';
import 'package:task/Constants/const_value.dart';

extension CapExtension on String {
  String get firstinCaps =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.firstinCaps)
      .join(" ");
}

Widget TextFieldHelperWidget(
    {TextEditingController controller,
    @required String labelText,
    Function validator,
    TextInputAction inputAction,
    int min = 1,
    int max = 1,
    int maxLength,
    Function onChanged,
    Function onFieldSubmitted,
    bool isDense,
    bool isEnable,
    bool obscureText,
    String initialValue,
    Widget suffixIcon,
    TextInputType keyboardType,
    bool applyBoundary = true}) {
  // FocusNode myFocusNode = new FocusNode();

  return TextFormField(
      controller: controller ?? null,
      style: TextStyle(color: Colors.black),
      initialValue: initialValue,
      obscureText: obscureText ?? false,
      minLines: min,
      maxLines: max,
      maxLength: maxLength ?? null,
      enabled: isEnable ?? true,
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: inputAction ?? TextInputAction.done,
      onChanged: onChanged ?? (value) {},
      onFieldSubmitted: onFieldSubmitted ?? (value) {},
      decoration: InputDecoration(
          isDense: isDense ?? false,
          suffix: suffixIcon ?? null,
          labelText: labelText == null ? "" : labelText.capitalizeFirstofEach,

          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  applyBoundary ? ConstValue.TEXT_FIELD_BORDER_RADIUS : 0.0),
              borderSide: BorderSide()),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  applyBoundary ? ConstValue.TEXT_FIELD_BORDER_RADIUS : 0.0),
              borderSide: BorderSide(color: Colors.grey)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  applyBoundary ? ConstValue.TEXT_FIELD_BORDER_RADIUS : 0.0),
              borderSide: BorderSide(color: Colors.red)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  applyBoundary ? ConstValue.TEXT_FIELD_BORDER_RADIUS : 0.0),
              borderSide: BorderSide(color: Colors.grey))),
      validator: validator ??
          (value) {
            return null;
          });
}
