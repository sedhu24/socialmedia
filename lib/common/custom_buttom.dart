import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? backgroundcolor;
  final Color? textColor;
  final VoidCallback onTap;
  final FontWeight? fontWeight;
  final double fontsize;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.backgroundcolor,
    this.fontWeight,
    this.fontsize = 16,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ElevatedButton(
    //   onPressed: onTap,
    //   style: ElevatedButton.styleFrom(
    //     minimumSize: const Size(double.infinity, 50),
    //     backgroundColor: backgroundcolor,
    //   ),
    //   child: Text(
    //     text,
    //     style: TextStyle(
    //       color: textColor,
    //     ),
    //   ),
    // );

    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        decoration: ShapeDecoration(
          color: backgroundcolor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
        ),
        width: double.infinity,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: fontWeight,
            fontSize: fontsize,
          ),
        ),
      ),
    );
  }
}
