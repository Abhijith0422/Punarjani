import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseModel {
  Future addUserDetail(String docId, Map<String, dynamic> userinfoMap) async {
    return await FirebaseFirestore.instance
        .collection("user_info")
        .doc(docId)
        .set(userinfoMap);
  }
}
