import 'package:flutter/material.dart';
import 'package:lab_3/presentation/utils/colors.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final bool disabled;
  final Color? color;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.disabled = false,
    this.color,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: widget.disabled ? null : widget.onPressed,
        style: ButtonStyle(
          backgroundColor: widget.disabled
              ? MaterialStateProperty.all(CustomColors.buttonDisabledColor)
              : _getColor(
            colorDefault: CustomColors.buttonColor,
            colorPressed: CustomColors.buttonPressedColor,
          ),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          elevation: MaterialStateProperty.all(0.0),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Container(
          width: 300,
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }

  MaterialStateProperty<Color> _getColor({
    required Color colorDefault,
    required Color colorPressed,
  }) {
    Color getColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return colorDefault;
      }
    }

    return MaterialStateProperty.resolveWith(getColor);
  }
}
