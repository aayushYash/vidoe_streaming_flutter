import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class WatchPartyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _realtimeDB = FirebaseDatabase.instance.ref();

  Future<void> createWatchParty({
    required String partyId,
    required String hostId,
    required String hostName,
    required String title,
    required String description,
    required String platform,
    required String videoId,
    required bool isPrivate,
    required int maxParticipants,
  }) async {
    try {
      // Step 1: Check if the user already has an active watch party
      QuerySnapshot existingParty = await _firestore
          .collection('watch_parties')
          .where('hostId', isEqualTo: hostId)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (existingParty.docs.isNotEmpty) {
        // If a party exists, delete it before creating a new one
        String existingPartyId = existingParty.docs.first.id;
        await deleteWatchParty(existingPartyId, hostId);
      }

      // Step 2: Store watch party metadata in Firestore (Removed Thumbnail)
      await _firestore.collection('watch_parties').doc(partyId).set({
        'partyId': partyId,
        'hostId': hostId,
        'hostName': hostName,
        'title': title,
        'description': description,
        'platform': platform,
        'videoId': videoId,
        'isPrivate': isPrivate,
        'maxParticipants': maxParticipants,
        'isActive': true,
        'startTime': FieldValue.serverTimestamp(),
        'participantCount': 0,
        'engagement': 0, // Track engagement later
      });

      // Step 3: Create real-time database entry for syncing
      await _realtimeDB.child('watch_parties').child(partyId).set({
        'hostId': hostId,
        'videoId': videoId,
        'playbackState': 'paused', // Initial state
        'currentTime': 0,
        'participants': {},
      });

    } catch (e) {
      print("Error creating watch party: $e");
    }
  }

  Future<void> deleteWatchParty(String partyId, String hostId) async {
    try {
      // Step 1: Remove from Firestore
      await _firestore.collection('watch_parties').doc(partyId).delete();

      // Step 2: Remove from RTDB
      await _realtimeDB.child('watch_parties').child(partyId).remove();

    } catch (e) {
      print("Error deleting watch party: $e");
    }
  }
}
