import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/youtube_player_widget.dart';
import '../widgets/chat_widget.dart';
import '../widgets/video_search_widget.dart';

class WatchPartyStreamingScreen extends StatefulWidget {
  final String partyId;

  const WatchPartyStreamingScreen({Key? key, required this.partyId}) : super(key: key);

  @override
  _WatchPartyStreamingScreenState createState() => _WatchPartyStreamingScreenState();
}

class _WatchPartyStreamingScreenState extends State<WatchPartyStreamingScreen> {
  final DatabaseReference _realtimeDB = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _videoUrl;
  bool _isChatVisible = true;
  String _partyTitle = "";
  String _hostName = "";
  bool _isPrivate = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWatchPartyDetails();
  }

  Future<void> _fetchWatchPartyDetails() async {
    try {
      DocumentSnapshot partySnapshot = await _firestore.collection('watch_parties').doc(widget.partyId).get();

      if (!partySnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Watch Party Not Found")));
        Navigator.pop(context);
        return;
      }

      Map<String, dynamic> data = partySnapshot.data() as Map<String, dynamic>;
      setState(() {
        _partyTitle = data['title'];
        _hostName = data['hostName'];
        _isPrivate = data['isPrivate'];
      });

      // Listen to video updates in Firebase RTDB
      _realtimeDB.child('watch_parties').child(widget.partyId).onValue.listen((event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> playbackData = event.snapshot.value as Map<dynamic, dynamic>;
          String newVideoUrl = playbackData['videoUrl'];

          if (_videoUrl != newVideoUrl) {
            setState(() {
              _videoUrl = newVideoUrl;
            });
          }
        }
      });

      setState(() => _isLoading = false);
    } catch (e) {
      print("Error fetching watch party details: $e");
    }
  }

  void _updateVideo(String newVideoUrl) {
    _realtimeDB.child('watch_parties').child(widget.partyId).update({
      'videoUrl': newVideoUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(_partyTitle), backgroundColor: Colors.black,elevation: 0,),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Video Player Section (Full Width, 2/3 of Screen Height)
                Container(
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height * (2 / 3),
                  color: Colors.red,
                  child: _videoUrl != null
                      ? YoutubePlayerWidget(videoUrl: _videoUrl!)
                      : const Center(child: Text("No video selected")),
                ),

                // Toggle Section (Remaining 1/3 of Screen)
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => setState(() => _isChatVisible = true),
                            child: const Text("Chat"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => setState(() => _isChatVisible = false),
                            child: const Text("Search Video"),
                          ),
                        ],
                      ),
                      Expanded(
                        child: _isChatVisible
                            ? ChatWidget(partyId: widget.partyId)
                            : VideoSearchWidget(onVideoSelected: _updateVideo),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
