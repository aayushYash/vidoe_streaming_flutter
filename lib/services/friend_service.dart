import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<int> getFriendCount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _db.collection('users').doc(user.uid).get();
      List<dynamic> friends = userDoc['friends'] ?? [];
      return friends.length;
    }
    return 0;
  }

  // You can add other methods for adding friends, sending requests, etc.
}
