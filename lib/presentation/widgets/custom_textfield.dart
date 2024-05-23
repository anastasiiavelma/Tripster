import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final int? maxLines;
  const CustomTextField(
      {super.key, required this.controller, required this.text, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          cursorColor: Theme.of(context).colorScheme.onBackground,

          maxLines: maxLines ?? 1,
          controller: controller,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
          // validator: (value) {
          //   if (value!.isEmpty) {
          //     return 'Please enter your password';
          //   }
          //   return null;
          // },

          decoration: InputDecoration(
            labelText: text,
            labelStyle: Theme.of(context).textTheme.headlineMedium,
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(
                width: 1.0,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(
                width: 1.0,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(
                width: 2.0,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ));
  }
}
