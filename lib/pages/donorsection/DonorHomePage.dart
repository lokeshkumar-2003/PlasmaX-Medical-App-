import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:quizapp/components/DonorCard.dart';
import 'package:quizapp/backend/SharedPeference.dart';
import 'package:quizapp/pages/donorsection/AddDonorsForm.dart';
import 'package:quizapp/pages/donorsection/Bloodgroupchart.dart';
import 'package:quizapp/pages/donorsection/DonorsListPage.dart';

class DonorHomePage extends StatefulWidget {
  const DonorHomePage({super.key});

  @override
  State<DonorHomePage> createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? userId;
  String? hospitalName;
  int? totalDonors = 0;
  int? availabelplasma = 0;
  int expriedplasma = 0;
  List<Map<String, dynamic>> donorsList = [];
  Map<String, int> bloodGroup = {
    'A+': 0,
    'B+': 0,
    'AB+': 0,
    'O+': 0,
    'A-': 0,
    'B-': 0,
    'AB-': 0,
    'O-': 0,
  };

  @override
  void initState() {
    super.initState();
    isCheckUserProfileUpdation();
    fetchData();
  }

  void fetchData() async {
    await getDonorsList();
    await getMatrics();
  }

  Future<void> isCheckUserProfileUpdation() async {
    String? userId = await Sharedpeference.getUserId();

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User ID not found! Please log in.")),
      );
      return;
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("hospitals_details")
        .where("uid", isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first;
      setState(() {
        hospitalName = userDoc['hospitalName'];
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text("Update Profile"),
            content:
                Text("No profile found. Please update your hospital profile."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.pushNamed(context, "/receiverprofile");
                },
                child: Text("Go"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> getDonorsList() async {
    String? hospitalId = (await Sharedpeference.getUserId())?.trim();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("donors")
          .where("hospitalId", isEqualTo: hospitalId)
          .get();

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
          "state": data["state"],
          "district": data["district"],
          "gender": data["gender"],
          "lastDonationDate": data["lastDonationDate"],
          "medicalConditions": data["medicalConditions"],
          "weight": data["weight"],
          "address": data["address"],
          "hospitalId": data["hospitalId"],
          "createdAt": data["createdAt"]
        };
      }).toList();

      setState(() {
        donorsList = donors;
      });
    } catch (e) {
      print("Error fetching donors: $e");
    }
  }

  int getRemainingDay(DateTime? createdAt) {
    if (createdAt == null) return 0;
    DateTime now = DateTime.now();
    int differenceInDays = now.difference(createdAt).inDays;
    return differenceInDays;
  }

  Future<void> getMatrics() async {
    int totalAmountPlasma = 0;
    int expiredPlasma = 0;
    int availablePlasma = 0;
    Map<String, int> updatedBloodGroup = {};

    for (var donor in donorsList) {
      try {
        int amount = int.parse(donor['amountDonated'].toString());
        totalAmountPlasma += amount;
        //print(amount);
        if (donor['createdAt'] != null) {
          Timestamp ts = donor['createdAt'];
          DateTime createdAtDate = ts.toDate();
          int remainingDays = DateTime.now().difference(createdAtDate).inDays;
          print("$remainingDays : $amount");
          if (remainingDays > 90) {
            setState(() {
              expiredPlasma += amount;
            });
          } else {
            setState(() {
              availablePlasma = totalAmountPlasma - expiredPlasma;
            });
          }
        }

        String bloodGroup = donor['bloodGroup'];
        if (updatedBloodGroup.containsKey(bloodGroup)) {
          updatedBloodGroup[bloodGroup] =
              updatedBloodGroup[bloodGroup]! + amount;
        } else {
          updatedBloodGroup[bloodGroup] = amount;
        }
      } catch (e) {
        print('Error parsing amountDonated or handling donor: $e');
      }
    }
    setState(() {
      totalDonors = donorsList.length;
      bloodGroup = updatedBloodGroup;
      availabelplasma = availablePlasma;
      expriedplasma = expiredPlasma;
    });
  }

  Future<void> logout(BuildContext context) async {
    await Sharedpeference.clearUserId();

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/auth',
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "PlasmaX",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, "/receiverprofile");
              },
            ),
            IconButton(
              icon: Icon(Icons.power_settings_new, color: Colors.white),
              onPressed: () {
                // Handle logout action
                logout(context);
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.redAccent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.account_circle, size: 50, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      "Welcome, $hospitalName!",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.redAccent),
                title: Text("Home"),
                onTap: () {
                  Navigator.pushNamed(context, "/auth");
                },
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.redAccent),
                title: Text("Profile"),
                onTap: () {
                  Navigator.pushNamed(context, "/receiverprofile");
                },
              ),
              ListTile(
                leading: Icon(Icons.list, color: Colors.redAccent),
                title: Text("Donor List"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DonorListPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                hospitalName != null && hospitalName!.isNotEmpty
                    ? hospitalName!
                    : "Guest",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatCard(
                        icon: Icons.people,
                        label: "Total Donors",
                        count: "$totalDonors",
                        color: Colors.green),
                    StatCard(
                        icon: Icons.bloodtype,
                        label: "Available plasma",
                        count: "$availabelplasma L",
                        color: Colors.blue),
                    StatCard(
                        icon: Icons.hourglass_bottom,
                        label: "Expired plasma",
                        count: "$expriedplasma L",
                        color: Colors.red),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.amber[50],
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 28, horizontal: 32),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Donor Distribution by Category",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF737373),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                              height: 200,
                              child: BloodGroupChart(bloodGroup: bloodGroup))
                        ]),
                  )),
              SizedBox(height: 20),
              Text(
                "Recent Donors",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 250, // Set the height as required
                child: donorsList.isEmpty
                    ? Center(
                        child: const Text(
                            style: TextStyle(fontSize: 18), "No donors"))
                    : ListView.builder(
                        itemCount: donorsList.length,
                        itemBuilder: (context, index) {
                          final donor = donorsList[index];

                          return DonorCard(
                            name: donor['fullName'],
                            bloodGroup: donor['bloodGroup'],
                            location: donor['district'] ?? "-",
                            available: true,
                          );
                        },
                      ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddDonorForm()))
                .then((value) {
              if (value == true) {
                getMatrics();
                getDonorsList();
              }
            });
          },
        ),
      ),
    );
  }
}

/// Donor List Page

/// Stat Card
class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 36),
            SizedBox(height: 8),
            Text(label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(count,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

List<BarChartGroupData> getBarChartGroups(Map<String, int> bloodGroup) {
  return [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
            toY: bloodGroup["A+"]?.toDouble() ?? 0,
            color: Colors.green,
            width: 20)
      ],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
            toY: bloodGroup["B+"]?.toDouble() ?? 0,
            color: Colors.blue,
            width: 20)
      ],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
            toY: bloodGroup["AB+"]?.toDouble() ?? 90,
            color: Colors.orange,
            width: 20)
      ],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
            toY: bloodGroup["O+"]?.toDouble() ?? 0,
            color: Colors.yellow,
            width: 20)
      ],
    ),
    BarChartGroupData(
      x: 4,
      barRods: [
        BarChartRodData(
            toY: bloodGroup["A-"]?.toDouble() ?? 0,
            color: Colors.purple,
            width: 20)
      ],
    ),
    BarChartGroupData(
      x: 5,
      barRods: [
        BarChartRodData(
            toY: bloodGroup["B-"]?.toDouble() ?? 0,
            color: Colors.red,
            width: 20)
      ],
    ),
    BarChartGroupData(
      x: 6,
      barRods: [
        BarChartRodData(
            toY: bloodGroup["AB-"]?.toDouble() ?? 0,
            color: Colors.pink,
            width: 20)
      ],
    ),
    BarChartGroupData(
      x: 7,
      barRods: [
        BarChartRodData(
            toY: bloodGroup["O-"]?.toDouble() ?? 0,
            color: Colors.brown,
            width: 20)
      ],
    ),
  ];
}

Widget bottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('Green', style: style);
      break;
    case 1:
      text = const Text('Blue', style: style);
      break;
    case 2:
      text = const Text('Orange', style: style);
      break;
    case 3:
      text = const Text('Yellow', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

/// Chart Legend
List<Widget> getLegend() {
  return [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Indicator(color: Colors.green, text: "A Group"),
        SizedBox(width: 10),
        Indicator(color: Colors.blue, text: "O Positive"),
        SizedBox(width: 10),
        Indicator(color: Colors.orange, text: "B Negative"),
      ],
    ),
  ];
}

/// Custom Legend Indicator
class Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const Indicator({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
