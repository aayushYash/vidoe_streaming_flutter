import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_streaming_proj/services/profile_service.dart'; // Assuming you have a profile service

class ProfileScreen extends StatefulWidget {
  final VoidCallback onSignOut;

  const ProfileScreen({required this.onSignOut, Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = "User";
  String email = "example@example.com";
  bool emailVerified = false;
  int numberOfFriends = 0;
  int numberOfJams = 0;
  int numberOfWatchParties = 0;
  int coins = 0;

  final ProfileService _profileService = ProfileService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Load basic user data (name, email, friends, jams, etc.)
    Map<String, dynamic> userData = await _profileService.getUserData();
    setState(() {
      fullName = userData['fullName'] ?? "User";
      email = userData['email'] ?? "example@example.com";
      emailVerified = userData['emailVerified'] ?? false;
      numberOfFriends = userData['numberOfFriends'] ?? 0;
      numberOfJams = userData['numberOfJams'] ?? 0;
      numberOfWatchParties = userData['numberOfWatchParties'] ?? 0;
    });

    // Fetch coins from Firestore
    await _fetchCoins();
  }

  Future<void> _fetchCoins() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Fetch the user's document from Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        if (userDoc.exists) {
          setState(() {
            coins = userDoc['coins'] ?? 0;   // Default to 0 if not found
          });
        }
      } catch (e) {
        debugPrint("Error fetching coins: $e");
      }
    }
  }

  Future<void> _resetPassword() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset email sent")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<void> _updateProfile() async {
    // You can implement a profile update screen here
    print("Profile update clicked");
  }

  Future<void> _goAdFree() async {
    // Placeholder for Go Ad-Free subscription logic
    print("Go Ad-Free clicked");
    // Implement your subscription logic later
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: widget.onSignOut,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Name
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.account_circle, size: 50, color: Colors.white),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fullName, style: const TextStyle(fontSize: 24, color: Colors.white)),
                    Row(
                      children: [
                        Text(
                          email,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        emailVerified
                            ? const Icon(Icons.verified, color: Colors.green, size: 20)
                            : const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats Section (Friends, Jams, Watch Parties)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatColumn("Friends", numberOfFriends),
                _buildStatColumn("Jams", numberOfJams),
                _buildStatColumn("Watch Parties", numberOfWatchParties),
              ],
            ),
            const SizedBox(height: 30),

            // Coins Section (fetched from Firestore)
            const Text("Coins", style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            _buildCoinRow("Coins: $coins"),

            const SizedBox(height: 30),

            // Buttons (Update Profile, Reset Password, Go Ad-Free, Log Out)
            _buildProfileButton("Update Profile", _updateProfile),
            _buildProfileButton("Reset Password", _resetPassword),
            _buildProfileButton("Go Ad-Free", _goAdFree),  // Go Ad-Free button
            _buildSignOutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildCoinRow(String coins) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(coins, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _buildProfileButton(String text, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => onPressed(),
          style: ElevatedButton.styleFrom(
            primary: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: widget.onSignOut,
          style: ElevatedButton.styleFrom(
            primary: Colors.redAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text("Log Out", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
