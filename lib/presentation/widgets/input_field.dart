import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.hintText,
    required this.keyboardType,
    required this.obscureText,
    required this.textInputAction,
    required this.controller,
    required this.onChanged,
    required this.suffixIcon,
    required this.enabled,
  }) : super(key: key);

  const InputField.text({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    required this.suffixIcon,
  })  : obscureText = false,
        keyboardType = TextInputType.text,
        enabled = true,
        textInputAction = TextInputAction.done,
        super(key: key);

  const InputField.password({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    required this.suffixIcon,
  })  : obscureText = true,
        keyboardType = TextInputType.text,
        textInputAction = TextInputAction.done,
        enabled = true,
        super(key: key);

  const InputField.disabled({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.suffixIcon,
  })  : keyboardType = TextInputType.none,
        obscureText = false,
        textInputAction = TextInputAction.done,
        onChanged = null,
        enabled = false,
        super(key: key);

  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final IconData? suffixIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: TextFormField(
        enabled: enabled,
        onChanged: onChanged,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textAlignVertical: TextAlignVertical.center,
        enableSuggestions: false,
        autocorrect: false,
        enableInteractiveSelection: false,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.7,
            color: Colors.black.withOpacity(0.3),
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 240, 240, 240),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 47, 123, 255),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          suffixIcon: Icon(
            suffixIcon,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        cursorColor: Colors.black87,
        cursorHeight: 16.0,
        style: const TextStyle(color: Colors.black87, fontSize: 16.0, letterSpacing: 1.0, fontWeight: FontWeight.w500),
      ),
    );
  }
}
