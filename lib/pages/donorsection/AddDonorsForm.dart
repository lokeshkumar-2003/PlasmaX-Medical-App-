import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/backend/SharedPeference.dart';

class AddDonorForm extends StatefulWidget {
  const AddDonorForm({super.key});

  @override
  State<AddDonorForm> createState() => _AddDonorFormState();
}

class _AddDonorFormState extends State<AddDonorForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController amountDonatedController = TextEditingController();
  final TextEditingController lastDonationDateController =
      TextEditingController();
  final TextEditingController medicalConditionController =
      TextEditingController();

  String? selectedGender;
  String? selectedBloodGroup;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> bloodGroupOptions = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  void validateLastDonation(String lastDonationDateStr) {
    try {
      final lastDonationDate = DateTime.parse(lastDonationDateStr);
      final today = DateTime.now();
      final difference = today.difference(lastDonationDate).inDays;

      if (difference < 90) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Not Eligible"),
            content: Text(
                "You must wait at least 90 days between plasma donations.\n\nLast donation: $lastDonationDateStr\nDays passed: $difference"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
      } else {
        _submitDonorData();
      }
    } catch (e) {
      // Handle format errors
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Invalid date format! Use yyyy-MM-dd")),
      // );
    }
  }

  void _submitDonorData() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      String? hospitalId = await Sharedpeference.getUserId();

      if (hospitalId == null || hospitalId.isEmpty) {
        throw "Hospital ID is invalid!";
      }

      // Validate donation date
      validateLastDonation(lastDonationDateController.text);

      // Prepare donor data
      final donorData = {
        "fullName": fullNameController.text,
        "age": ageController.text,
        "gender": selectedGender,
        "contact": contactController.text,
        "email": emailController.text,
        "address": addressController.text,
        "district": districtController.text,
        "state": stateController.text,
        "aadhar": aadharController.text,
        "bloodGroup": selectedBloodGroup,
        "amountDonated": amountDonatedController.text,
        "weight": weightController.text,
        "lastDonationDate": lastDonationDateController.text,
        "medicalConditions": medicalConditionController.text,
        "createdAt": Timestamp.now(),
        "hospitalId": hospitalId,
      };

      await FirebaseFirestore.instance.collection('donors').add(donorData);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("hospitals_details")
          .where("uid", isEqualTo: hospitalId.trim())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        var hospitalData = doc.data() as Map<String, dynamic>;

        int currentAvailablePlasma = hospitalData["availablePlasma"] ?? 0;
        Map<String, dynamic> currentBloodGroupPlasma =
            Map<String, dynamic>.from(hospitalData["bloodgroupPlasma"] ?? {});

        int donatedAmount = int.tryParse(amountDonatedController.text) ?? 0;
        if (donatedAmount == 0) throw "Invalid donation amount!";

        String? donorBloodGroup = selectedBloodGroup;

        int updatedAvailablePlasma = currentAvailablePlasma + donatedAmount;
        int updatedBloodGroupPlasma =
            (currentBloodGroupPlasma[donorBloodGroup] ?? 0) + donatedAmount;

        await FirebaseFirestore.instance
            .collection("hospitals_details")
            .doc(doc.id)
            .update({
          "availablePlasma": updatedAvailablePlasma,
          "bloodgroupPlasma": {
            ...currentBloodGroupPlasma,
            donorBloodGroup: updatedBloodGroupPlasma,
          },
        });

        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Donor added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } else {
        throw "No hospital found with this UID.";
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Donor Entry',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField("Full Name", fullNameController,
                    required: true),
                _buildTextField("Age", ageController, required: true),
                _buildDropdownField("Gender", genderOptions,
                    (value) => selectedGender = value, selectedGender),
                _buildTextField("Contact Number", contactController,
                    required: true),
                _buildTextField("Email", emailController),
                _buildTextField("Address", addressController),
                _buildTextField("District", districtController),
                _buildTextField("State", stateController),
                _buildTextField("Aadhar Number", aadharController,
                    required: true),
                _buildDropdownField("Blood Group", bloodGroupOptions,
                    (value) => selectedBloodGroup = value, selectedBloodGroup),
                _buildTextField("Amount Donated (ml)", amountDonatedController,
                    required: true),
                _buildTextField("Weight (kg)", weightController),
                _buildTextField("Last Donation Date (dd-mm-yyyy)",
                    lastDonationDateController),
                _buildTextField(
                    "Medical Conditions (if any)", medicalConditionController),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, // 👈 Makes it full width
                  child: ElevatedButton(
                    onPressed: _submitDonorData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(6), // 👈 Less corner radius
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 14), // Optional: better height
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool required = false,
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        validator: (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return '\$label is required';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items,
      Function(String?) onChanged, String? currentValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) =>
            value == null || value.isEmpty ? '\$label is required' : null,
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    ageController.dispose();
    contactController.dispose();
    emailController.dispose();
    addressController.dispose();
    aadharController.dispose();
    weightController.dispose();
    districtController.dispose();
    stateController.dispose();
    lastDonationDateController.dispose();
    medicalConditionController.dispose();
    amountDonatedController.dispose();
    super.dispose();
  }
}
