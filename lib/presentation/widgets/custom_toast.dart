import 'package:flutter/material.dart';
import 'package:validator/extensions/extensions.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final Color color;
  final IconData icon;
  final double width;

  const CustomToast({super.key, required this.message, required this.color, required this.icon, required this.width});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          width: width,
          height: context.h * 0.05,
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: Colors.white,
              ),
              Center(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showToast({required BuildContext context, required String message, required Color color, required IconData icon, required double width}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).size.height * 0.1,
        left: 0,
        right: 0,
        child: CustomToast(
          message: message,
          color: color,
          icon: icon,
          width: width,
        ),
      ),
    );

    overlay!.insert(overlayEntry);

    // Remove the toast after a certain duration
    Future.delayed(const Duration(milliseconds: 2500), () => overlayEntry.remove());
  }
}
