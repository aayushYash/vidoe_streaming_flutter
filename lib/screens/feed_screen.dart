import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:video_streaming_proj/screens/watch_party_details_screen.dart';
// import 'package:video_streaming_proj/screens/watch_party_streaming_screen.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Map<String, String> _hostNameCache = {}; // 🔥 Store fetched host names

  @override
  void initState() {
    super.initState();
    _fetchAllUsers(); // Fetch all user data at the start
  }

  /// 🔥 Fetch all user names in one call and cache them
  Future<void> _fetchAllUsers() async {
    var usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    Map<String, String> tempCache = {};

    for (var doc in usersSnapshot.docs) {
      tempCache[doc.id] = doc.data()['name'] ?? 'Unknown Host';
    }

    setState(() {
      _hostNameCache = tempCache;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("🎥 Live Streams Feed"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('watch_parties').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No live streams available.",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

          var streams = snapshot.data!.docs;

          return ListView.builder(
            itemCount: streams.length,
            itemBuilder: (context, index) {
              var stream = streams[index];

              return _buildStreamCard(context, stream);
            },
          );
        },
      ),
    );
  }

  Widget _buildStreamCard(BuildContext context, QueryDocumentSnapshot stream) {
    // 🔥 Ensure no missing fields, provide default values
    Map<String, dynamic> streamData = stream.data() as Map<String, dynamic>;

    String thumbnailUrl = streamData.containsKey('thumbnail')
        ? streamData['thumbnail']
        : 'https://via.placeholder.com/300x170?text=No+Image';

    String streamName = streamData.containsKey('name') ? streamData['name'] : "Untitled Stream";
    String streamDescription = streamData.containsKey('description') ? streamData['description'] : "No description available";
    String platform = streamData.containsKey('platform') ? streamData['platform'] : "Unknown";
    String createdBy = streamData.containsKey('createdBy') ? streamData['createdBy'] : "unknown_user";

    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => WatchPartyDetailScreen(
        //       partyId: stream.id,
        //     ),
        //   ),
        // );
      },
      child: Card(
        color: Colors.grey[900],
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Thumbnail Section with Safe Handling
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                thumbnailUrl,
                width: double.infinity,
                height: 170,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/default_thumbnail.png', // Local fallback image
                  width: double.infinity,
                  height: 170,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    streamName,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    streamDescription,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _platformTag(platform),
                      Text(
                        "👤 Host: ${_hostNameCache[createdBy] ?? 'Loading...'}",
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _platformTag(String platform) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: platform == "YouTube" ? Colors.red : Colors.purple,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        platform,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
