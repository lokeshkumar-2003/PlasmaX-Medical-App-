import 'package:flutter/material.dart';
import 'package:quizapp/backend/ProfileService.dart';
import 'package:quizapp/backend/SharedPeference.dart';
import 'package:quizapp/pages/donorsection/Mapwidget.dart';
import 'package:quizapp/pages/donorsection/ProfileForm.dart';

class ProfileViewForm extends StatefulWidget {
  const ProfileViewForm({super.key});

  @override
  _ProfileViewFormState createState() => _ProfileViewFormState();
}

class _ProfileViewFormState extends State<ProfileViewForm> {
  final ProfileService _profileService = ProfileService();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  late String? userId;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    userId = await Sharedpeference.getUserId();
    await getUserProfileData();
  }

  Future<void> getUserProfileData() async {
    final result = await _profileService.getUserProfileData(userId!);
    if (result['status']) {
      setState(() {
        _userData = result['data'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _buildField(
                      "Hospital/Clinic Name", _userData!['hospitalName']),
                  SizedBox(height: 16),
                  _buildField("Facility Type", _userData!['facilityType']),
                  SizedBox(height: 16),
                  _buildField("Registration No", _userData!['registrationNo']),
                  SizedBox(height: 16),
                  _buildField("Accreditation", _userData!['accreditation']),
                  SizedBox(height: 16),
                  _buildField("Email", _userData!['email']),
                  SizedBox(height: 16),
                  _buildField("Phone", _userData!['phone']),
                  SizedBox(height: 16),
                  _buildField("Address", _userData!['address']),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () {
                        // Navigate to edit profile page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileForm()));
                      },
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FreeMapWidget(
                lat: _userData!['locationCoords'][0],
                lng: _userData!['locationCoords'][1],
              ),
            ),
          );
        },
        child: Icon(Icons.map, color: Colors.white),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Divider(thickness: 1),
      ],
    );
  }
}
