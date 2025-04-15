// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import 'leaderboard_page.dart';

class ReferralPage extends StatelessWidget {
  final String referralCode = "ABC123"; // Replace with dynamic code if needed

  // Global key for Snackbar (removes need for context)
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  // Dummy Leaderboard Data
  final List<Map<String, dynamic>> topReferrers = [
    {"name": "John Doe", "referrals": 120, "rank": 1},
    {"name": "Alice Smith", "referrals": 95, "rank": 2},
    {"name": "Michael Lee", "referrals": 80, "rank": 3},
  ];

  ReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey, // Assign global key
      child: Scaffold(
        appBar: AppBar(
          title: Text("Refer & Earn"),
          backgroundColor: AppColors.primary,
          centerTitle: true,
          elevation: 5,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🎉 Heading
              Text(
                "Invite Your Friends & Earn ₹5 per Signup!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // 🏆 Referral Code Card with Glassmorphism
              _buildReferralCard(),

              SizedBox(height: 20),

              // 🏅 Leaderboard Section
              _buildLeaderboardSection(),

              SizedBox(height: 20),

              // 📊 View Full Leaderboard Button
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to Leaderboard Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeaderboardPage()),
                  );
                },
                icon: Icon(Icons.leaderboard, color: Colors.white),
                label: Text("View Full Leaderboard", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🎁 Referral Code Card with Glassmorphism Effect
  Widget _buildReferralCard() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4))],
          ),
          child: Column(
            children: [
              Text("Your Referral Code", style: TextStyle(fontSize: 16, color: Colors.white70)),
              SizedBox(height: 10),
              SelectableText(
                referralCode,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.white54),
              SizedBox(height: 10),

              // 📤 Copy & Share Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(Icons.copy, "Copy Code", () {
                    Clipboard.setData(ClipboardData(text: referralCode));

                    // ✅ Using _scaffoldKey instead of context
                    _scaffoldKey.currentState?.showSnackBar(
                      SnackBar(content: Text("Code Copied!")),
                    );
                  }),
                  SizedBox(width: 10),
                  _buildActionButton(Icons.share, "Share Code", () {
                    Share.share("Join this amazing app & earn rewards! Use my referral code: $referralCode");
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🔥 Custom Animated Action Button
  Widget _buildActionButton(IconData icon, String text, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // 🏅 Leaderboard Section
  Widget _buildLeaderboardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("🏆 Top Referrers", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Column(
          children: topReferrers.map((user) => _buildLeaderboardTile(user)).toList(),
        ),
      ],
    );
  }

  // 🏅 Individual Leaderboard Tile
  Widget _buildLeaderboardTile(Map<String, dynamic> user) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(2, 3))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blueAccent.withOpacity(0.2),
            child: Text("${user['rank']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(user['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Text("${user['referrals']} Referrals", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }
}