import 'package:flutter/material.dart';

class FollowButtom extends StatelessWidget {
  final Color backgroundcolor;
  final VoidCallback? function;
  final Color borderColor;
  final String text;
  final Color textColor;
  const FollowButtom({
    super.key,
    required this.backgroundcolor,
    this.function,
    required this.borderColor,
    required this.text,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: function,
        child: Container(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          decoration: BoxDecoration(
            color: backgroundcolor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 1.8,
          height: MediaQuery.of(context).size.height * 0.05,
        ),
      ),
    );
  }
}
