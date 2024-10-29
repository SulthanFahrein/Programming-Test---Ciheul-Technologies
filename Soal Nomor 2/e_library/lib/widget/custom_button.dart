import 'package:e_library/config/app_color.dart';
import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    Key? key,
    required this.label,
    required this.onTap,
    this.isExpand,
    this.color = AppColor.primary, // Default to primary color
    this.hasShadow = true, // Default shadow visibility
  }) : super(key: key);

  final String label;
  final Function onTap;
  final bool? isExpand;
  final Color color; // Button color
  final bool hasShadow; // Shadow visibility

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0, 0.7),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: hasShadow
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.5), // Shadow color based on button color
                          offset: const Offset(0, 5),
                          blurRadius: 20,
                        ),
                      ]
                    : null, // No shadow if hasShadow is false
              ),
              width: isExpand == null
                  ? null
                  : isExpand!
                      ? double.infinity
                      : null,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                label,
              ),
            ),
          ),
          Align(
            child: Material(
              color: color, // Use the specified button color
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onTap(),
                child: Container(
                  width: isExpand == null
                      ? null
                      : isExpand!
                          ? double.infinity
                          : null,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 12,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white, // Text color
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
