// ignore_for_file: prefer_const_constructors

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:super_auth/constants.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final String label;
  final bool isPassword;
  final TextEditingController controller;
  final Icon? icon;
  const CustomTextField({
    super.key,
    required this.hint,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.icon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObsecure = true;

  void toggleObsecure() {
    setState(() {
      isObsecure = !isObsecure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller,
        autocorrect: false,
        enableSuggestions: false,
        obscureText: widget.isPassword && isObsecure,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: appBarColor,
              ),
              borderRadius: BorderRadius.circular(10)),
          prefixIcon: widget.icon,
          prefixIconColor: appBarColor,
          suffixIconColor: appBarColor,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: isObsecure
                      ? Icon(EvaIcons.eyeOff2)
                      : Icon(
                          EvaIcons.eye,
                        ),
                  onPressed: () {
                    toggleObsecure();
                  },
                )
              : Text(""),
          label: Text(widget.label),
          labelStyle: TextStyle(
            color: appBarColor
          ),
          hintStyle: TextStyle(
            color: appBarColor
          ),
          focusColor: appBarColor,
          hintText: widget.hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: Color(0xFF96B6C5),
            ),
          ),
        ),
      ),
    );
  }
}
