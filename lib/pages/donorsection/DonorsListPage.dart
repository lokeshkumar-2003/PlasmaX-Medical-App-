import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/backend/SharedPeference.dart';
import 'package:quizapp/pages/donorsection/DonorEditPage.dart';
import 'package:quizapp/pages/donorsection/ViewDonorDetailsPage.dart';

class DonorListPage extends StatefulWidget {
  const DonorListPage({super.key});

  @override
  State<DonorListPage> createState() => _DonorListPageState();
}

class _DonorListPageState extends State<DonorListPage> {
  final TextEditingController _searchController = TextEditingController();
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
    getDonorsData();
  }

  String? hospitalId;
  void getDonorsData() async {
    try {
      hospitalId = await Sharedpeference.getUserId();
      if (hospitalId != null && hospitalId!.trim().isNotEmpty) {
        final trimmedId = hospitalId!.trim();

        // Firestore query for donors where hospitalId matches
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection("donors")
            .where("hospitalId", isEqualTo: trimmedId)
            .get();

        // Debugging: print the number of matching donors
        print("Number of donors found: ${snapshot.docs.length}");

        // Map snapshot to list of donors
        List<Map<String, dynamic>> donors = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return {
            "_id": doc.id,
            "aadhar": data["aadhar"],
            "age": data["age"],
            "amountDonated": data["amountDonated"],
            "bloodGroup": data["bloodGroup"],
            "contact": data["contact"],
            "email": data["email"],
            "fullName": data["fullName"],
            "gender": data["gender"],
            "lastDonationDate": data["lastDonationDate"],
            "medicalConditions": data["medicalConditions"],
            "weight": data["weight"],
            "address": data["address"],
            "hospitalId": data["hospitalId"],
          };
        }).toList();

        // Update state with donors
        setState(() {
          _donors = donors;
          _filteredDonors = donors;
        });
      } else {
        print("Hospital ID is null or empty.");
      }
    } catch (e) {
      print("Error fetching donors: $e");
    }
  }

  void _searchDonors() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDonors = _donors.where((donor) {
        final nameMatch =
            (donor['fullName'] ?? "").toLowerCase().contains(query);
        final groupMatch = _selectedBloodGroup == 'All' ||
            donor['bloodGroup'] == _selectedBloodGroup;
        return nameMatch && groupMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Donor List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
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
                      _searchDonors();
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
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _searchDonors,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredDonors.isEmpty
                  ? const Center(child: Text("No donors found."))
                  : ListView.builder(
                      itemCount: _filteredDonors.length,
                      itemBuilder: (context, index) {
                        final donor = _filteredDonors[index];

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.redAccent,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(donor['fullName'] ?? "-"),
                            subtitle: Text(
                                'Blood Group: ${donor['bloodGroup'] ?? "-"}'),
                            trailing: Wrap(
                              spacing: 10,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            DonorViewPage(donorData: donor),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.white,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Add your edit logic here
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DonorEditPage(
                                                donorData: donor,
                                                donorId: donor["_id"]))).then(
                                        (value) {
                                      if (value == true) {
                                        getDonorsData();
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit_document,
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
