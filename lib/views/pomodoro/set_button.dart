import 'package:flutter/material.dart';

class SetButton extends StatelessWidget {
  final Function onTap;
  final bool isSelected;
  final String title;

  const SetButton({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 25,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.red : Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
