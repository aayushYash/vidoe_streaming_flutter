import 'package:firebase_database/firebase_database.dart';

class WatchPartyRTDBService {
  final DatabaseReference _rtdb = FirebaseDatabase.instance.ref();

  Future<void> createWatchPartySession(String partyId, String videoId, String videoTitle) async {
    try {
      await _rtdb.child("watch_parties").child(partyId).set({
        "video": {
          "videoId": videoId,
          "videoTitle": videoTitle,
          "currentTime": 0,
          "isPlaying": false,
        },
        "participants": {},
        "messages": {}
      });
    } catch (e) {
      print("Error creating watch party session: $e");
    }
  }

  Future<void> updatePlaybackState(String partyId, bool isPlaying, int currentTime) async {
    try {
      await _rtdb.child("watch_parties").child(partyId).child("video").update({
        "isPlaying": isPlaying,
        "currentTime": currentTime,
      });
    } catch (e) {
      print("Error updating playback state: $e");
    }
  }

  Future<void> addParticipant(String partyId, String userId, String name, String profilePic) async {
    try {
      await _rtdb.child("watch_parties").child(partyId).child("participants").child(userId).set({
        "name": name,
        "profilePic": profilePic,
        "joinedAt": DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print("Error adding participant: $e");
    }
  }

  Future<void> sendMessage(String partyId, String userId, String username, String message) async {
    try {
      String messageId = _rtdb.child("watch_parties").child(partyId).child("messages").push().key!;
      await _rtdb.child("watch_parties").child(partyId).child("messages").child(messageId).set({
        "userId": userId,
        "username": username,
        "message": message,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }
}
