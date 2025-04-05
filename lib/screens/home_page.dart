import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'wallet_page.dart';
import 'referral_page.dart';
import 'spin_win_page.dart';
import 'task_page.dart';
import 'ads_page.dart';
import 'exclusive_offers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  double walletBalance = 0.00;
  bool darkMode = false;
  bool claimedDailyBonus = false;
  int dailyStreak = 1;
  List<String> transactions = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void updateBalance(double amount) {
    setState(() {
      walletBalance += amount;
      transactions.insert(0, "You earned ₹${amount.toStringAsFixed(2)}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "EarnHub",
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold, 
            color: Colors.white
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              darkMode ? Icons.dark_mode : Icons.light_mode, 
              color: Colors.white,
              size: 26
            ),
            onPressed: () => setState(() => darkMode = !darkMode),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade900, 
              Colors.blue.shade600, 
              Colors.blue.shade400
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWalletCard(),
                      SizedBox(height: 20),
                      _buildQuickActions(),
                      SizedBox(height: 20),
                      _buildDailyRewards(),
                      SizedBox(height: 20),
                      buildExclusiveOffers(),
                      SizedBox(height: 20),
                      _buildRecentTransactions(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orangeAccent,
        icon: Icon(Icons.add, color: Colors.white, size: 28),
        label: Text("Earn Money", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        onPressed: () {
          HapticFeedback.lightImpact();
          _showEarnOptions();
        },
      ),
    );
  }

  Widget _buildWalletCard() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(2, 4)),
        ],
      ),
      child: Column(
        children: [
          Text("Wallet Balance", style: TextStyle(fontSize: 20, color: Colors.white70)),
          SizedBox(height: 10),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Text("₹${walletBalance.toStringAsFixed(2)}",
              key: ValueKey(walletBalance),
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          SizedBox(height: 10),
          Divider(color: Colors.white54),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWalletAction(
                icon: Icons.account_balance_wallet,
                label: "Withdraw",
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => WalletPage())
                ),
              ),
              _buildWalletAction(
                icon: Icons.group_add,
                label: "Refer & Earn",
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => ReferralPage())
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Activity", 
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            color: Colors.white
          )
        ),
        SizedBox(height: 10),
        if (transactions.isEmpty)
          Center(
            child: Text(
              "No recent transactions", 
              style: TextStyle(fontSize: 16, color: Colors.white70)
            ),
          )
        else
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: transactions.length,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.greenAccent, size: 30),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          transactions[index], 
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.w500, 
                            color: Colors.white
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildWalletAction({
    required IconData icon, 
    required String label, 
    required VoidCallback onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          SizedBox(height: 5),
          Text(
            label, 
            style: TextStyle(color: Colors.white70, fontSize: 12)
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickActionButton(
          icon: Icons.casino,
          label: "Spin & Win",
          color: Colors.pink,
          onTap: () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => SpinWinPage())
          ),
        ),
        _buildQuickActionButton(
          icon: Icons.task_alt,
          label: "Daily Tasks",
          color: Colors.green,
          onTap: () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => TaskPage())
          ),
        ),
        _buildQuickActionButton(
          icon: Icons.video_collection,
          label: "Watch Ads",
          color: Colors.blue,
          onTap: () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => AdsPage())
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12, 
              fontWeight: FontWeight.bold, 
              color: Colors.white
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyRewards() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(2, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🎁 Daily Rewards",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              return Column(
                children: [
                  Icon(Icons.calendar_today, color: index == 0 ? Colors.green : Colors.grey),
                  Text("Day ${index + 1}", style: TextStyle(fontSize: 14)),
                ],
              );
            }),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Implement daily reward claim logic
            },
            child: Text("Claim Reward"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  void _showEarnOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Earn Money Options",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildEarnOptionButton(
                    icon: Icons.play_circle_outline,
                    label: "Spin & Win",
                    color: Colors.pink,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => SpinWinPage())
                      );
                    },
                  ),
                  _buildEarnOptionButton(
                    icon: Icons.task_alt,
                    label: "Daily Tasks",
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => TaskPage())
                      );
                    },
                  ),
                  _buildEarnOptionButton(
                    icon: Icons.video_collection,
                    label: "Watch Ads",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => AdsPage())
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarnOptionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        FloatingActionButton(
          backgroundColor: color.withOpacity(0.2),
          elevation: 0,
          child: Icon(icon, color: color, size: 30),
          onPressed: onTap,
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}