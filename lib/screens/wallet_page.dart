// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'withdraw_page.dart';
// ignore: unused_import
import '../widgets/transaction_tile.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double walletBalance = 120.50; // Replace with dynamic balance from database
  List<Map<String, String>> transactions = [
    {"title": "Ad Watched", "amount": "+ ₹1.00", "date": "Just Now", "type": "credit"},
    {"title": "Referral Bonus", "amount": "+ ₹5.00", "date": "1 hr ago", "type": "credit"},
    {"title": "Withdrawal Request", "amount": "- ₹100.00", "date": "Pending", "type": "debit"},
  ];

  Future<void> _refreshTransactions() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate API call
    setState(() {
      transactions.add({
        "title": "New Bonus",
        "amount": "+ ₹10.00",
        "date": "Just Now",
        "type": "credit"
      });
      walletBalance += 10.00; // Update balance dynamically
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallet & Transactions"),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 5,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTransactions,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Wallet Balance Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.greenAccent, Colors.green]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4))],
                ),
                child: Column(
                  children: [
                    Text("Total Balance", style: TextStyle(fontSize: 18, color: Colors.white70)),
                    SizedBox(height: 10),
                    Text(
                      "₹${walletBalance.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.white54),
                    SizedBox(height: 10),

                    // Withdraw Money Button
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WithdrawPage()),
                        );
                      },
                      icon: Icon(Icons.money, color: Colors.white),
                      label: Text("Withdraw Money", style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Transaction History Section
              _buildTransactionHistory(),
            ],
          ),
        ),
      ),
    );
  }

  // Transaction History Section
  Widget _buildTransactionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("📜 Transaction History", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        transactions.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Column(
                    children: [
                      Icon(Icons.receipt_long_rounded, size: 80, color: Colors.grey[400]),
                      SizedBox(height: 10),
                      Text("No Transactions Yet!", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                    ],
                  ),
                ),
              )
            : Column(
                children: transactions.map((txn) => _buildTransactionTile(txn)).toList(),
              ),
      ],
    );
  }

  // Transaction Tile
  Widget _buildTransactionTile(Map<String, String> txn) {
    bool isCredit = txn["type"] == "credit";
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
            backgroundColor: isCredit ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
            child: Icon(isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                size: 28, color: isCredit ? Colors.green : Colors.red),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(txn["title"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                txn["amount"]!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCredit ? Colors.green : Colors.red,
                ),
              ),
              Text(txn["date"]!, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            ],
          ),
        ],
      ),
    );
  }
}