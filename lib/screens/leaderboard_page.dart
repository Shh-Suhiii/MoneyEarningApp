import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboardData = [
    {"name": "Rahul", "earnings": 500},
    {"name": "Aditi", "earnings": 450},
    {"name": "Vikas", "earnings": 400},
    {"name": "Sneha", "earnings": 350},
    {"name": "Aryan", "earnings": 300},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple,
        centerTitle: true,
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.purple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text("🏆 Top Earners", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple)),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: leaderboardData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(2, 3))],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getRankColor(index),
                          child: Text("#${index + 1}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                        title: Text(leaderboardData[index]["name"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        trailing: Text("₹${leaderboardData[index]["earnings"]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.brown;
      default:
        return Colors.blueAccent;
    }
  }
}
