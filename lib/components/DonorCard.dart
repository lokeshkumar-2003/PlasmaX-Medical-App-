import 'package:flutter/material.dart';

class DonorCard extends StatelessWidget {
  final String name;
  final String bloodGroup;
  final String location;
  final bool available;

  const DonorCard(
      {super.key,
      required this.name,
      required this.bloodGroup,
      required this.location,
      required this.available});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading:
            Icon(Icons.person, color: available ? Colors.green : Colors.grey),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Blood: $bloodGroup • Location: $location"),
        trailing: Icon(available ? Icons.check_circle : Icons.cancel,
            color: available ? Colors.green : Colors.red),
      ),
    );
  }
}
