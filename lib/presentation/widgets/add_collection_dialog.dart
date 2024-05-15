import 'package:flutter/material.dart';

class CollectionDialog {
  static void show(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Collection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter collection name',
                  hintStyle: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: 'Enter location',
                  hintStyle: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  hintText: 'Enter date of vacation',
                  hintStyle: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle data processing or saving here
                // String collectionName = nameController.text;
                // String location = locationController.text;
                // String date = dateController.text;

                // Do something with the collected data
                // For example:
                // collections.add({
                //   'name': collectionName,
                //   'location': location,
                //   'date': date,
                // });

                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
