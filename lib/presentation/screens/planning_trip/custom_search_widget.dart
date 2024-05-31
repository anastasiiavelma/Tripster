import 'package:flutter/material.dart';

class CustomSearchTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const CustomSearchTextField({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        cursorColor: Theme.of(context).colorScheme.onBackground,
        decoration: InputDecoration(
          hintText: 'Search by country name',
          hintStyle: Theme.of(context).textTheme.headlineSmall,
          prefixIcon: Icon(Icons.search,
              color: Theme.of(context).colorScheme.onBackground),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onBackground, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onBackground, width: 2.0),
          ),
        ),
      ),
    );
  }
}
