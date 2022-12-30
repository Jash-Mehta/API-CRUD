import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class DetailScreen extends StatefulWidget {
  String hinttext;
  ValueChanged<String>? onchange;
  TextEditingController? controller;
  FormFieldSetter<String>? onSaved;
  TextInputType? keyboardType;
  TextInputAction? inputAction;
  Icon? icon;
  String? predefine;
  double? height;

  DetailScreen(
      {Key? key,
      required this.hinttext,
      this.onchange,
      this.controller,
      this.onSaved,
      this.keyboardType,
      this.inputAction,
      this.icon,
      this.predefine,
      this.height})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13.0, right: 13.0, top: 10.0),
      child: Neumorphic(
        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
        style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            depth: -5,
            intensity: 0.86,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            lightSource: LightSource.topLeft,
            shadowDarkColorEmboss: Colors.black87,
            color: Colors.white),
        child: TextFormField(
          initialValue: widget.predefine,
          decoration: InputDecoration(
              hintStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              border: InputBorder.none,
              hintText: widget.hinttext,
              prefixIcon: widget.icon),
          onChanged: widget.onchange,
        ),
      ),
    );
  }
}
