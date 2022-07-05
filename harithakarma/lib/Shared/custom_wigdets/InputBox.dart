import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  final Function(String) onChange;
  RegExp regexValue;
  IconData specifiedIcon;
  String label;
  String errorText;
  TextInputType keyboard;

  InputBox(
      {Key? key,
      required this.onChange,
      required this.regexValue,
      required this.specifiedIcon,
      required this.label,
      required this.errorText,
      required this.keyboard})
      : super(key: key);
  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  final TextEditingController formCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
                controller: formCtrl,
                keyboardType: widget.keyboard,
                // validates whether value entered is empty or according to regex
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !widget.regexValue.hasMatch(value)) {
                    return widget.errorText;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: widget.label,
                    suffixIcon: Icon(widget.specifiedIcon),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                onChanged: (val) =>
                    {_formKey.currentState!.validate(), widget.onChange(val)}),
          ],
        ));
  }
}
