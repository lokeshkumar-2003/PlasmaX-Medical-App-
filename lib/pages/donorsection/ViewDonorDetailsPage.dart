import 'package:flutter/material.dart';

class DonorViewPage extends StatelessWidget {
  final Map<String, dynamic> donorData;

  const DonorViewPage({super.key, required this.donorData});

  @override
  Widget build(BuildContext context) {
    print(donorData);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donor Details"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailTile("Full Name", donorData["fullName"]),
            _buildDetailTile("Age", donorData["age"]?.toString()),
            _buildDetailTile("Gender", donorData["gender"]),
            _buildDetailTile("Contact", donorData["contact"]),
            _buildDetailTile("Email", donorData["email"]),
            _buildDetailTile("Address", donorData["address"]),
            _buildDetailTile("Aadhar", donorData["aadhar"]),
            _buildDetailTile("Blood Group", donorData["bloodGroup"]),
            _buildDetailTile(
                "Amount Donated", donorData["amountDonated"]?.toString()),
            _buildDetailTile("Weight", donorData["weight"]?.toString()),
            _buildDetailTile(
                "Last Donation Date", donorData["lastDonationDate"]),
            _buildDetailTile(
                "Medical Conditions", donorData["medicalConditions"]),
            _buildDetailTile("Hospital ID", donorData["hospitalId"]),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(String title, String? value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value ?? "-"),
      ),
    );
  }
}
