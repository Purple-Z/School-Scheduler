import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';


Widget buildSwitch(BuildContext context, String label, bool value, Function(bool) onChanged, {bool isEditable=true}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 16)),
      Switch(
        thumbIcon: WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Icon(Icons.check, color: Theme.of(context).colorScheme.surface,); // All other states will use the default thumbIcon.
          }
          return Icon(Icons.close, color: Theme.of(context).colorScheme.surface,);
        }),
        value: value,
        onChanged: isEditable ? onChanged : null,
      ),
    ],
  );
}

Widget buildTextField(
    TextEditingController controller, String label, IconData icon,
    {bool obscureText = false, TextInputType inputType = TextInputType.text, bool editable = true,}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: inputType,
    enabled: editable,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: label,
      prefixIcon: Icon(icon),
    ),
  );
}

showTopMessage(BuildContext context, String text, {bool isOK = true}){
  return showTopSnackBar(
    Overlay.of(context),
    Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
                isOK ? Icons.check_circle : Icons.cancel,
                color: Theme.of(context).colorScheme.surface,
                size: 32
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ),
    animationDuration: const Duration(milliseconds: 100),
    displayDuration: const Duration(milliseconds: 1000),
    curve: Curves.easeInOut,
  );
}