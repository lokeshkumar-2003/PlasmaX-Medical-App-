import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/backend/ProfileService.dart';
import 'package:quizapp/pages/donorsection/AddressAutocomplete.dart';
import 'package:quizapp/pages/donorsection/Mapwidget.dart';
import 'package:quizapp/pages/donorsection/OperatingHoursPicker.dart';
import 'package:quizapp/backend/SharedPeference.dart';
import 'package:quizapp/pages/donorsection/ProfileViewForm.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StepperForm(),
    );
  }
}

class StepperForm extends StatefulWidget {
  const StepperForm({super.key});

  @override
  _StepperFormState createState() => _StepperFormState();
}

class _StepperFormState extends State<StepperForm> {
  int _currentStep = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController facilityTypeController = TextEditingController();
  final TextEditingController registrationNoController =
      TextEditingController();
  final TextEditingController accreditationController = TextEditingController();
  final TextEditingController affiliatedProgramsController =
      TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController alternatePhoneController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController plasmaStorageController = TextEditingController();
  final TextEditingController emergencyAvailabilityController =
      TextEditingController();
  final TextEditingController openTimeController = TextEditingController();
  final TextEditingController closeTimeController = TextEditingController();
  final TextEditingController doctorInChargeController =
      TextEditingController();
  ValueNotifier<double> latNotifier = ValueNotifier(0.0);
  ValueNotifier<double> lngNotifier = ValueNotifier(0.0);
  String? userId;

  final ProfileService _profileService = ProfileService();
  var formTitle = [
    "Basic Information",
    "Contact Details",
    "Medical Information",
    "Preview"
  ];

  var facilityTypes = ["Hospital", "Clinic", "Blood Bank"];

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    userId = await Sharedpeference.getUserId();
    await loadUserProfileData(userId!);
  }

  Future<void> loadUserProfileData(String? userId) async {
    final userProfileData = await _profileService.getUserProfileData(userId!);

    final data = userProfileData["data"];
    if (data != null) {
      setState(() {
        hospitalNameController.text = data["hospitalName"] ?? "";
        facilityTypeController.text = data["facilityType"] ?? "";
        registrationNoController.text = data["registrationNo"] ?? "";
        accreditationController.text = data["accreditation"] ?? "";
        affiliatedProgramsController.text = data["affiliatedPrograms"] ?? "";
        dateController.text = data["date"] ?? "";
        emailController.text = data["email"] ?? "";
        phoneController.text = data["phone"] ?? "";
        alternatePhoneController.text = data["alternatePhone"] ?? "";
        addressController.text = data["address"] ?? "";
        websiteController.text = data["website"] ?? "";
        plasmaStorageController.text = data["plasmaStorage"] ?? "";
        emergencyAvailabilityController.text =
            data["emergencyAvailability"] ?? "";
        openTimeController.text = data["openTime"] ?? "";
        closeTimeController.text = data["closeTime"] ?? "";
        doctorInChargeController.text = data["doctorInCharge"] ?? "";
        latNotifier.value = data["locationCoords"][0] ?? 0.0;
        lngNotifier.value = data["locationCoords"][1] ?? 0.0;
      });
    } else {
      setState(() {
        hospitalNameController.text = "";
        facilityTypeController.text = "";
        registrationNoController.text = "";
        accreditationController.text = "";
        affiliatedProgramsController.text = "";
        dateController.text = "";
        emailController.text = "";
        phoneController.text = "";
        alternatePhoneController.text = "";
        addressController.text = "";
        websiteController.text = "";
        plasmaStorageController.text = "";
        emergencyAvailabilityController.text = "";
        openTimeController.text = "";
        closeTimeController.text = "";
        doctorInChargeController.text = "";
        latNotifier.value = 0.0;
        lngNotifier.value = 0.0;
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      CollectionReference hospitals =
          FirebaseFirestore.instance.collection('hospitals_details');
      Map<String, dynamic> hospitalData = {
        "uid": userId,
        "hospitalName": hospitalNameController.text,
        "facilityType": facilityTypeController.text,
        "registrationNo": registrationNoController.text,
        "accreditation": accreditationController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "alternatePhone": alternatePhoneController.text,
        "address": addressController.text,
        "website": websiteController.text,
        "plasmaStorage": plasmaStorageController.text,
        "emergencyAvailability": emergencyAvailabilityController.text,
        "openTime": openTimeController.text,
        "closeTime": closeTimeController.text,
        "doctorInCharge": doctorInChargeController.text,
        "locationCoords": [latNotifier.value, lngNotifier.value],
        "availablePlasma": 0,
        "bloodgroupPlasma": {
          "A+": 0,
          "A-": 0,
          "B+": 0,
          "B-": 0,
          "AB+": 0,
          "AB-": 0,
          "O+": 0,
          "O-": 0,
        }
      };

      final userProfileData = await _profileService.getUserProfileData(userId!);

      final docId = userProfileData["docId"];
      await hospitals.doc(docId).set(hospitalData, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileViewForm()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error submitting data: $e"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("PlasmaX", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                formTitle[_currentStep],
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: (_currentStep + 1) / 4,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
              ),
              SizedBox(height: 20),
              Expanded(child: SingleChildScrollView(child: _getStepContent())),
              KeyedSubtree(
                key: Key('stepper-button-row'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _currentStep == 0
                          ? null
                          : () => setState(() => _currentStep--),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.white),
                          SizedBox(width: 5),
                          Text("Prev", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print(formTitle[_currentStep]);

                        if (_currentStep < 3) {
                          setState(() => _currentStep++);
                        } else {
                          _submitForm();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: Row(
                        children: [
                          Text(
                            _currentStep == 3 ? "Submit" : "Next",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            _currentStep == 3
                                ? Icons.check
                                : Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _currentStep == 1 || _currentStep == 3
          ? Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: FloatingActionButton(
                backgroundColor: Colors.redAccent,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FreeMapWidget(
                              lat: latNotifier.value, lng: lngNotifier.value)));
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Floating Action Clicked!")));
                },
                child: Icon(Icons.map, color: Colors.white),
              ),
            )
          : null,
    );
  }

  Widget _getStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoForm();
      case 1:
        return _buildContactDetailsForm();
      case 2:
        return _buildMedicalInfoForm();
      case 3:
        return _buildPreviewForm();
      default:
        return _buildBasicInfoForm();
    }
  }

  Widget _buildPreviewForm() {
    return Form(
      child: Column(
        children: [
          SizedBox(height: 28.0),
          _buildTextField("Hospital/Clinic Name", hospitalNameController,
              required: true),
          SizedBox(height: 18.0),
          _buildDropdownField(
            "Facility type",
            facilityTypes,
            facilityTypeController,
          ),
          SizedBox(height: 18.0),
          _buildTextField("Registration No", registrationNoController,
              required: true),
          SizedBox(height: 18.0),
          _buildTextField("Accreditation & License", accreditationController),
          SizedBox(height: 18.0),
          OperatingHoursPicker(
              openTimeController: openTimeController,
              closeTimeController: closeTimeController),
          SizedBox(height: 18.0),
          _buildTextField("Official Email", emailController,
              required: true, isEmail: true),
          SizedBox(height: 18.0),
          _buildTextField("Phone Number", phoneController,
              required: true, isPhone: true),
          SizedBox(height: 18.0),
          AddressAutocomplete(
            addressController: addressController,
            latNotifier: latNotifier,
            lngNotifier: lngNotifier,
          ),
          SizedBox(height: 18.0),
          _buildDropdownField(
              "Plasma Storage", ["Yes", "No"], plasmaStorageController),
          SizedBox(height: 18.0),
          _buildTextField("Doctor In Charge", doctorInChargeController,
              required: true),
          SizedBox(height: 28.0),
        ],
      ),
    );
  }

  Widget _buildBasicInfoForm() {
    return Column(children: [
      _buildTextField("Hospital/Clinic Name", hospitalNameController),
      SizedBox(height: 18.0),
      _buildDropdownField(
          "Facility type", facilityTypes, facilityTypeController),
      SizedBox(height: 18.0),
      _buildTextField("Registration No", registrationNoController),
      SizedBox(height: 18.0),
      _buildTextField("Accreditation & License", accreditationController),
    ]);
  }

  Widget _buildContactDetailsForm() {
    return Column(children: [
      _buildTextField("Official Email", emailController),
      SizedBox(height: 18.0),
      _buildTextField("Phone Number", phoneController),
      SizedBox(height: 18.0),
      _buildTextField("Alternate Contact Number", alternatePhoneController),
      SizedBox(height: 18.0),
      AddressAutocomplete(
        addressController: addressController,
        latNotifier: latNotifier,
        lngNotifier: lngNotifier,
      ),
      SizedBox(height: 18.0),
      _buildTextField("Website URL", websiteController),
    ]);
  }

  Widget _buildMedicalInfoForm() {
    return Column(children: [
      _buildDropdownField(
          "Plasma Storage", ["Yes", "No"], plasmaStorageController),
      SizedBox(height: 18.0),
      OperatingHoursPicker(
          openTimeController: openTimeController,
          closeTimeController: closeTimeController),
      SizedBox(height: 18.0),
      _buildTextField("Doctor In Charge", doctorInChargeController),
    ]);
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool required = false,
    bool isEmail = false,
    bool isPhone = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return "$label is required";
        } else if (value == null || value.trim().isEmpty) {
          return null;
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Enter a valid email address";
        }
        if (isPhone && !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return "Enter a valid 10-digit phone number";
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(
      String label, List<String> items, TextEditingController controller) {
    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (newValue) => controller.text = newValue!,
    );
  }

  @override
  void dispose() {
    hospitalNameController.dispose();
    facilityTypeController.dispose();
    registrationNoController.dispose();
    accreditationController.dispose();
    affiliatedProgramsController.dispose();
    dateController.dispose();
    emailController.dispose();
    phoneController.dispose();
    alternatePhoneController.dispose();
    addressController.dispose();
    websiteController.dispose();
    plasmaStorageController.dispose();
    emergencyAvailabilityController.dispose();
    openTimeController.dispose();
    closeTimeController.dispose();
    doctorInChargeController.dispose();
    super.dispose();
  }
}
