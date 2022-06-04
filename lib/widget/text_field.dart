import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  String hinttext;
  ValueChanged<String>? onchange;
  TextEditingController? controller;
  FormFieldSetter<String>? onSaved;
  TextInputType? keyboardType;
  TextInputAction? inputAction;
  Icon? icon;
  String? predefine;

  DetailScreen({
    Key? key,
    required this.hinttext,
    this.onchange,
    this.controller,
    this.onSaved,
    this.keyboardType,
    this.inputAction,
    this.icon,
    this.predefine,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13.0, right: 13.0, top: 10.0),
      child: TextFormField(
        initialValue: widget.predefine,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            hintText: widget.hinttext,
            icon: widget.icon),
        onChanged: widget.onchange,
      ),
    );
  }
}
