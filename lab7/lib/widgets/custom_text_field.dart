import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool enableToggleObscure;
  final VoidCallback? onEditingComplete;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enableToggleObscure = false,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    bool isObscure = obscureText;

    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isObscure,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: enableToggleObscure
                ? IconButton(
              icon: Icon(
                isObscure
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
            )
                : null,
          ),
          validator: validator,
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context)
                  .requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          onEditingComplete: onEditingComplete,
        );
      },
    );
  }
}