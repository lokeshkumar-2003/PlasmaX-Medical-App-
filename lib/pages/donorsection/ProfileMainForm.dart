import 'package:flutter/material.dart';
import 'package:quizapp/backend/SharedPeference.dart';
import 'package:quizapp/backend/ProfileService.dart';
import 'package:quizapp/pages/donorsection/ProfileForm.dart';
import 'package:quizapp/pages/donorsection/ProfileViewForm.dart';

class ProfileMainForm extends StatefulWidget {
  const ProfileMainForm({super.key});

  @override
  _ProfileMainFormState createState() => _ProfileMainFormState();
}

class _ProfileMainFormState extends State<ProfileMainForm> {
  late String? userId;
  bool _hasData = false;
  bool _isLoading = true;

  void getInitializeUserId() async {
    userId = await Sharedpeference.getUserId();
    print(userId);
    await checkIfDataExists();
  }

  Future<void> checkIfDataExists() async {
    print(userId);
    final ProfileService profileService = ProfileService();
    final result = await profileService.getUserProfileData(userId!);
    print(result);
    if (result['status']) {
      setState(() {
        _hasData = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _hasData = false;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getInitializeUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            )
          : _hasData
              ? ProfileViewForm()
              : ProfileForm(),
    );
  }
}
