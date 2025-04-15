// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class SpinWinPage extends StatefulWidget {
  const SpinWinPage({super.key});

  @override
  _SpinWinPageState createState() => _SpinWinPageState();
}

class _SpinWinPageState extends State<SpinWinPage>
    with SingleTickerProviderStateMixin {
  // Enhanced reward structure with more variety
  final List<Map<String, dynamic>> _rewards = [
    {"value": 0, "type": "Miss", "emoji": "😢"},
    {"value": 5, "type": "Coin", "emoji": "🪙"},
    {"value": 10, "type": "Small Prize", "emoji": "🎁"},
    {"value": 20, "type": "Cash", "emoji": "💸"},
    {"value": 50, "type": "Big Win", "emoji": "🎉"},
    {"value": 100, "type": "Jackpot", "emoji": "🏆"},
  ];

  final List<Color> _cardColors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.tealAccent,
  ];

  final Random _random = Random();

  int _spinsLeft = 5; // Increased initial spins
  bool _isSpinning = false;
  int? _selectedIndex;
  List<Map<String, dynamic>> spinHistory = [];
  int _totalEarnings = 0;

  late ConfettiController _confettiController;
  late AnimationController _controller;
  late PageController _historyPageController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _historyPageController = PageController(viewportFraction: 0.8);
  }

  void _startSpin() {
    if (_isSpinning || _spinsLeft == 0) return;

    setState(() {
      _isSpinning = true;
      _spinsLeft--;
    });

    _controller.forward(from: 0).whenComplete(() {
      int selectedIndex = _random.nextInt(_rewards.length);
      Map<String, dynamic> selectedReward = _rewards[selectedIndex];

      setState(() {
        _selectedIndex = selectedIndex;
        _isSpinning = false;

        // Add to spin history with more details
        spinHistory.insert(0, {
          "reward": selectedReward,
          "timestamp": DateTime.now(),
        });

        // Update total earnings
        _totalEarnings += (selectedReward["value"] as num).toInt();
      });

      if (selectedReward["value"] > 0) {
        _confettiController.play();
      }
      _showRewardDialog(selectedReward);
    });
  }

  void _showRewardDialog(Map<String, dynamic> reward) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text(
                "${reward['emoji']} ${reward['type']}!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  reward['value'] > 0
                      ? "You won ₹${reward['value']}!"
                      : "Better luck next time!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  reward['value'] > 0 ? "Congratulations!" : "Keep trying!",
                  style: TextStyle(
                    fontSize: 18,
                    color: reward['value'] > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _controller.dispose();
    _historyPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Spin & Win Challenge",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        elevation: 10,
      ),
      body: Stack(
        children: [
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  "Total Earnings: ₹$_totalEarnings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Spin the magical cards and unveil your fortune!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.9,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _controller.value * 2 * pi,
                          child: child,
                        );
                      },
                      child: _buildSpinningCards(screenWidth),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isSpinning || _spinsLeft == 0 ? null : _startSpin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _spinsLeft > 0 ? Colors.deepPurpleAccent : Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    _spinsLeft > 0 ? "Spin Now!" : "No Spins Left",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Spins Left: $_spinsLeft",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _spinsLeft > 0 ? Colors.green : Colors.red,
                  ),
                ),
                SizedBox(height: 20),
                _buildSpinHistoryCarousel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpinningCards(double screenWidth) {
    double cardWidth = screenWidth * 0.15;
    double cardHeight = cardWidth * 1.5;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: List.generate(_rewards.length, (index) {
        bool isSelected = _selectedIndex == index;
        Map<String, dynamic> reward = _rewards[index];

        return AnimatedContainer(
          duration: Duration(milliseconds: 500),
          width: isSelected ? cardWidth * 1.2 : cardWidth,
          height: isSelected ? cardHeight * 1.2 : cardHeight,
          decoration: BoxDecoration(
            color: _cardColors[index],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Transform.scale(
            scale: isSelected ? 1.1 : 1.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isSelected ? "₹${reward['value']}" : "?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (isSelected)
                  Text(reward['emoji'], style: TextStyle(fontSize: 30)),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSpinHistoryCarousel() {
    return Column(
      children: [
        Text(
          "Spin History",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurpleAccent,
          ),
        ),
        SizedBox(height: 10),
        spinHistory.isEmpty
            ? Text("No spins yet!", style: TextStyle(color: Colors.grey))
            : SizedBox(
              height: 100,
              child: PageView.builder(
                controller: _historyPageController,
                itemCount: spinHistory.length,
                itemBuilder: (context, index) {
                  var entry = spinHistory[index];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ListTile(
                        leading: Text(
                          entry['reward']['emoji'],
                          style: TextStyle(fontSize: 30),
                        ),
                        title: Text(
                          "${entry['reward']['type']} - ₹${entry['reward']['value']}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "${entry['timestamp'].hour}:${entry['timestamp'].minute}",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }
}
