import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validator/extensions/extensions.dart';

import 'border_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    required this.leadingOnPressed,
    required this.leadingIcon,
    this.popValue,
    this.actionWidget,
    this.actionOnPressed,
  }) : super(key: key);

  CustomAppBar.pop({Key? key, required this.title, required BuildContext context})
      : leadingIcon = CupertinoIcons.left_chevron,
        leadingOnPressed = (() => Navigator.of(context).pop()),
        actionWidget = null,
        actionOnPressed = null,
        popValue = null,
        super(key: key);

  CustomAppBar.popDelete({Key? key, this.popValue, required this.title, required this.actionOnPressed, required BuildContext context})
      : leadingIcon = CupertinoIcons.left_chevron,
        actionWidget = BorderButton.delete(width: context.w * 0.1, onPressed: actionOnPressed),
        leadingOnPressed = popValue != null ? (() => Navigator.of(context).pop(popValue)) : (() => Navigator.of(context).pop()),
        super(key: key);

  final String title;
  final IconData leadingIcon;
  final Function() leadingOnPressed;
  final dynamic popValue;
  final Widget? actionWidget;
  final void Function()? actionOnPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(color: Colors.black87),
      ),
      leading: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: const EdgeInsets.only(left: 16),
        icon: Icon(
          leadingIcon,
          size: 26,
          color: Colors.black87,
        ),
        onPressed: leadingOnPressed,
      ),
      actions: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8), child: actionWidget),
      ],
    );
  }
}
