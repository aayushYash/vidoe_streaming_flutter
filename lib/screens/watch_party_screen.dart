import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:video_streaming_proj/screens/watch_party_streaming_screen.dart';
import '../services/watch_party_service.dart';
import '../widgets/custom_input.dart';

class WatchPartyScreen extends StatefulWidget {
  const WatchPartyScreen({Key? key}) : super(key: key);

  @override
  _WatchPartyScreenState createState() => _WatchPartyScreenState();
}

class _WatchPartyScreenState extends State<WatchPartyScreen> {
  final WatchPartyService _watchPartyService = WatchPartyService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedPlatform = "YouTube";
  bool isPrivate = false;
  bool isLoading = false;

  Future<void> _createWatchParty() async {
    if (nameController.text.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      String partyId = const Uuid().v4();
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await _watchPartyService.createWatchParty(
        partyId: partyId,
        hostId: user.uid,
        hostName: user.displayName ?? "Unknown",
        title: nameController.text.trim(),
        description: descriptionController.text.trim(),
        platform: selectedPlatform,
        videoId: "",
        isPrivate: isPrivate,
        maxParticipants: 10,
      );

      nameController.clear();
      descriptionController.clear();
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Watch Party Created!")));

      // **Navigate to Watch Party Room**
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WatchPartyStreamingScreen(partyId: partyId),
        ),
      );

    } catch (e) {
      setState(() => isLoading = false);
      print("Error creating watch party: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create or Join Watch Party")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Watch Party Name Input
            CustomInputField(
              controller: nameController,
              hintText: "Watch Party Name",
              icon: Icons.video_library,
            ),
            const SizedBox(height: 10),

            // Description Input
            CustomInputField(
              controller: descriptionController,
              hintText: "Description (optional)",
              icon: Icons.description,
            ),
            const SizedBox(height: 10),

            // Platform Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _platformIcon(Icons.ondemand_video, "YouTube"),
              ],
            ),
            const SizedBox(height: 10),

            // Private Toggle
            Row(
              children: [
                Checkbox(
                  value: isPrivate,
                  onChanged: (value) => setState(() => isPrivate = value!),
                ),
                const Text("Private Watch Party", style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 10),

            // **Create Watch Party Button**
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading ? null : _createWatchParty,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Create Watch Party", style: TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 20),

            // **Join Watch Party Button**
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.purple), // Restore Original Color
                ),
                onPressed: () {
                  // TODO: Implement Join Watch Party functionality
                },
                child: const Text("Join Watch Party", style: TextStyle(fontSize: 16, color: Colors.purple)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _platformIcon(IconData icon, String platform) {
    return GestureDetector(
      onTap: () => setState(() => selectedPlatform = platform),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: selectedPlatform == platform ? Colors.purple : Colors.grey[800],
            radius: 30,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 5),
          Text(platform, style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
