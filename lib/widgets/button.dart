import 'package:flutter/material.dart';
import 'package:shreddit/screens/colors.dart';

class Button extends StatelessWidget {
  const Button({required this.text, required this.onClick, Key? key})
      : super(key: key);
  final String text;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColor.black, borderRadius: BorderRadius.circular(10)),
        child: Text(
          text,
          style: TextStyle(color: AppColor.white, fontSize: 20),
        ),
      ),
    );
  }
}
