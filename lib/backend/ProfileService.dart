import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserProfileData(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userProfileData = await _firestore
          .collection("hospitals_details")
          .where("uid", isEqualTo: userId)
          .get();

      if (userProfileData.docs.isEmpty) {
        throw ("User profile data not found");
      }
      print(userProfileData.docs[0].data());

      return {
        "status": true,
        "data": userProfileData.docs[0].data(),
        "docId": userProfileData.docs[0].id,
        "msg": "User data found"
      };
    } catch (e) {
      return {
        "status": false,
        "msg": e.toString(),
      };
    }
  }
}
