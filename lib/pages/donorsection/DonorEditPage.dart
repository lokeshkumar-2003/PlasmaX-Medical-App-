import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonorEditPage extends StatefulWidget {
  final Map<String, dynamic> donorData;
  final String donorId;

  const DonorEditPage(
      {super.key, required this.donorData, required this.donorId});

  @override
  State<DonorEditPage> createState() => _DonorEditPageState();
}

class _DonorEditPageState extends State<DonorEditPage> {
  late TextEditingController fullNameController;
  late TextEditingController ageController;
  late TextEditingController contactController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController aadharController;
  late TextEditingController amountDonatedController;
  late TextEditingController weightController;
  late TextEditingController lastDonationDateController;
  late TextEditingController medicalConditionController;

  String? selectedGender;
  String? selectedBloodGroup;

  bool _isLoading = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  @override
  void initState() {
    super.initState();
    fullNameController =
        TextEditingController(text: widget.donorData["fullName"]);
    ageController = TextEditingController(text: widget.donorData["age"]);
    contactController =
        TextEditingController(text: widget.donorData["contact"]);
    emailController = TextEditingController(text: widget.donorData["email"]);
    addressController =
        TextEditingController(text: widget.donorData["address"]);
    aadharController = TextEditingController(text: widget.donorData["aadhar"]);
    amountDonatedController =
        TextEditingController(text: widget.donorData["amountDonated"]);
    weightController = TextEditingController(text: widget.donorData["weight"]);
    lastDonationDateController =
        TextEditingController(text: widget.donorData["lastDonationDate"]);
    medicalConditionController =
        TextEditingController(text: widget.donorData["medicalConditions"]);
    selectedGender = widget.donorData["gender"];
    selectedBloodGroup = widget.donorData["bloodGroup"];
  }

  @override
  void dispose() {
    fullNameController.dispose();
    ageController.dispose();
    contactController.dispose();
    emailController.dispose();
    addressController.dispose();
    aadharController.dispose();
    amountDonatedController.dispose();
    weightController.dispose();
    lastDonationDateController.dispose();
    medicalConditionController.dispose();
    super.dispose();
  }

  void _saveDonorData() async {
    final updatedDonor = {
      "fullName": fullNameController.text,
      "age": ageController.text,
      "gender": selectedGender,
      "contact": contactController.text,
      "email": emailController.text,
      "address": addressController.text,
      "aadhar": aadharController.text,
      "bloodGroup": selectedBloodGroup,
      "amountDonated": amountDonatedController.text,
      "weight": weightController.text,
      "lastDonationDate": lastDonationDateController.text,
      "medicalConditions": medicalConditionController.text,
    };

    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection("donors")
          .doc(widget.donorId)
          .update(updatedDonor);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Updated successfully")));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Something went wrong while updating please try again")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    Navigator.pop(context, true);
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.donorId);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Donor"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildTextField("Full Name", fullNameController),
            _buildTextField("Age", ageController, type: TextInputType.number),
            DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
              items: _genders
                  .map((gender) =>
                      DropdownMenuItem(value: gender, child: Text(gender)))
                  .toList(),
              onChanged: (val) => setState(() => selectedGender = val),
            ),
            const SizedBox(height: 10),
            _buildTextField("Contact", contactController,
                type: TextInputType.phone),
            _buildTextField("Email", emailController,
                type: TextInputType.emailAddress),
            _buildTextField("Address", addressController),
            _buildTextField("Aadhar", aadharController),
            DropdownButtonFormField<String>(
              value: selectedBloodGroup,
              decoration: InputDecoration(
                  labelText: "Blood Group",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
              items: _bloodGroups
                  .map((group) =>
                      DropdownMenuItem(value: group, child: Text(group)))
                  .toList(),
              onChanged: (val) => setState(() => selectedBloodGroup = val),
            ),
            const SizedBox(height: 10),
            _buildTextField("Amount Donated", amountDonatedController),
            _buildTextField("Weight", weightController),
            _buildTextField("Last Donation Date", lastDonationDateController),
            _buildTextField("Medical Conditions", medicalConditionController),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _saveDonorData, // Disable button when loading
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 25.0,
                        width: 25.0,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Edit',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
