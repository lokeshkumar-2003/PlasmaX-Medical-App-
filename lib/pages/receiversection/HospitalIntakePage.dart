import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/pages/donorsection/Mapwidget.dart';
import 'package:url_launcher/url_launcher.dart';

class Hospitalintakepage extends StatefulWidget {
  const Hospitalintakepage({super.key});

  @override
  State<Hospitalintakepage> createState() => _Hospitalintakepage();
}

class _Hospitalintakepage extends State<Hospitalintakepage> {
  final TextEditingController _searchHospitalController =
      TextEditingController();
  final TextEditingController _searchPlaceController = TextEditingController();
  final TextEditingController _searchplasmaamountController =
      TextEditingController();
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

  List<Map<String, dynamic>> _hospitals = [];
  List<Map<String, dynamic>> _filteredHopital = [];

  @override
  void initState() {
    super.initState();
    getHospitalData();
  }

  void getHospitalData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot1 =
        await FirebaseFirestore.instance.collection("hospitals_details").get();

    try {
      List<Map<String, dynamic>> hospitals = snapshot1.docs.map((doc) {
        final data = doc.data();

        return {
          "_id": data["uid"],
          "hospitalName": data["hospitalName"].toString(),
          "facilityType": data["facilityType"],
          "phone": data["phone"],
          "email": data["email"],
          "docterInCharge": data["docterInCharge"],
          "address": data["address"],
          "district": data["place"],
          "locationCoords": {
            "lat": data["locationCoords"][0],
            "lng": data["locationCoords"][1]
          },
          "availablePlasma": data["availablePlasma"],
          "bloodgroupPlasma": {
            "A+": data["bloodgroupPlasma"]["A+"],
            "A-": data["bloodgroupPlasma"]["A-"],
            "B+": data["bloodgroupPlasma"]["B+"],
            "B-": data["bloodgroupPlasma"]["B-"],
            "AB+": data["bloodgroupPlasma"]["AB+"],
            "AB-": data["bloodgroupPlasma"]["AB-"],
            "O+": data["bloodgroupPlasma"]["O+"],
            "O-": data["bloodgroupPlasma"]["O-"]
          }
        };
      }).toList();

      setState(() {
        _hospitals = hospitals;
        _filteredHopital = hospitals;
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
    String hospitalQuery = _searchHospitalController.text.toLowerCase();
    String placeQuery = _searchPlaceController.text.toLowerCase();
    int amountPlasmaQuery =
        int.tryParse(_searchplasmaamountController.text.trim()) ?? 0;
    setState(() {
      _filteredHopital = _hospitals.where((hospital) {
        final hospitalName = hospital['hospitalName'].toString().toLowerCase();
        final district = hospital['district'].toString().toLowerCase();
        final availablePlasma =
            int.tryParse(hospital['availablePlasma'].toString()) ?? 0;

        final hospitalMatch = hospitalName.contains(hospitalQuery);
        final placeMatch = district.contains(placeQuery);
        final amountMatch = availablePlasma >= amountPlasmaQuery;

        return hospitalMatch && placeMatch && amountMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Hospital List",
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
                      controller: _searchHospitalController,
                      decoration: InputDecoration(
                        hintText: 'Search by Hospital Name',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextField(
                      controller: _searchplasmaamountController,
                      decoration: InputDecoration(
                        hintText: 'Amount of Plasma',
                        prefixIcon: const Icon(Icons.bloodtype),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                        _searchHospitals();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
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
              child: _filteredHopital.isEmpty
                  ? const Center(child: Text("No Hospitals found."))
                  : ListView.builder(
                      itemCount: _filteredHopital.length,
                      itemBuilder: (context, index) {
                        final hosptial = _filteredHopital[index];

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundColor: Colors.redAccent,
                                child: Icon(
                                  hosptial["facilityType"] == "Hospital"
                                      ? Icons.local_hospital
                                      : hosptial["facilityType"] == "Clinic"
                                          ? Icons.medical_services
                                          : hosptial["facilityType"] ==
                                                  "Blood Bank"
                                              ? Icons.bloodtype
                                              : Icons
                                                  .location_city, // fallback icon
                                  color: Colors.white,
                                )),
                            title: Text(hosptial['hospitalName'] ?? "-"),
                            trailing: Wrap(
                              spacing: 10,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    makeCall(hosptial['phone']);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => FreeMapWidget(
                                                lat: hosptial['locationCoords']
                                                    ["lat"],
                                                lng: hosptial['locationCoords']
                                                    ["lng"])));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.map,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
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
