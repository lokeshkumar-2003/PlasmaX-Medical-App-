import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Donorintakepage extends StatefulWidget {
  const Donorintakepage({super.key});

  @override
  State<Donorintakepage> createState() => _Donorintakepage();
}

class _Donorintakepage extends State<Donorintakepage> {
  final TextEditingController _searchPlaceController = TextEditingController();
  String _selectedBloodGroup = 'All';

  final List<String> _bloodGroups = [
    'All',
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];

  List<Map<String, dynamic>> _donors = [];
  List<Map<String, dynamic>> _filteredDonors = [];

  @override
  void initState() {
    super.initState();
    getHospitalData();
  }

  bool isAbove90Days(DateTime targetDate) {
    final currentDate = DateTime.now();
    final differenceInDays = currentDate.difference(targetDate).inDays;
    return differenceInDays > 90;
  }

  void getHospitalData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection("donors").get();

      List<Map<String, dynamic>> donors = snapshot.docs.where((doc) {
        final data = doc.data();
        DateTime targetDate;
        if (data['createdAt'] is Timestamp) {
          targetDate = (data['createdAt'] as Timestamp).toDate();
        } else {
          targetDate = data['createdAt'];
        }
        return isAbove90Days(targetDate);
      }).map((doc) {
        final data = doc.data();
        return {
          "donorName": data["fullName"],
          "phoneNo": data["contact"],
          "district": data["district"] ?? "",
          "bloodGroup": data["bloodGroup"] ?? ""
        };
      }).toList();

      setState(() {
        _donors = donors;
        _filteredDonors = donors;
      });
    } catch (e) {
      print("Error fetching donors: $e");
    }
  }

  void makeCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      print("Phone number is empty or null");
      return;
    }

    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _searchHospitals() {
    String placeQuery = _searchPlaceController.text.toLowerCase();
    String selectedGroup = _selectedBloodGroup;

    setState(() {
      _filteredDonors = _donors.where((donor) {
        final donorDistrict = donor['district'].toString().toLowerCase();
        final donorGroup = donor['bloodGroup'].toString();

        final placeMatch = donorDistrict.contains(placeQuery);
        final groupMatch =
            selectedGroup == 'All' || donorGroup == selectedGroup;

        return placeMatch && groupMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Donors List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Column(children: [
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextField(
                      controller: _searchPlaceController,
                      decoration: InputDecoration(
                        hintText: 'Search by Place',
                        prefixIcon: const Icon(Icons.place),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: DropdownButtonFormField<String>(
                      value: _selectedBloodGroup,
                      items: _bloodGroups.map((String group) {
                        return DropdownMenuItem<String>(
                          value: group,
                          child: Text(group),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBloodGroup = value!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _searchHospitals,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                  )
                ],
              )
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredDonors.isEmpty
                  ? const Center(child: Text("No Donors found."))
                  : ListView.builder(
                      itemCount: _filteredDonors.length,
                      itemBuilder: (context, index) {
                        final donor = _filteredDonors[index];

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.redAccent,
                              child: Icon(Icons.face, color: Colors.white),
                            ),
                            title: Text(donor['donorName'] ?? "-"),
                            subtitle: Text(
                                "District: ${donor['district']}, Blood Group: ${donor['bloodGroup']}"),
                            trailing: ElevatedButton(
                              onPressed: () {
                                makeCall(donor['phoneNo']);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child:
                                  const Icon(Icons.phone, color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
