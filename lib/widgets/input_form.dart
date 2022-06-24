import 'package:flutter/material.dart';
import 'package:shreddit/screens/colors.dart';

class InputForm extends StatelessWidget {
  const InputForm(this._controller,
      {Key? key,
      this.validation,
      this.hintText = '',
      this.padding = 10.0,
      this.onChanged})
      : super(key: key);

  final TextEditingController? _controller;
  final String? Function(String?)? validation;
  final String hintText;
  final double padding;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: TextFormField(
        onChanged: onChanged,
        controller: _controller,
        cursorColor: AppColor.black,
        decoration: InputDecoration(
          hintText: hintText,
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: AppColor.black)),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
        validator: validation,
      ),
    );
  }
}
