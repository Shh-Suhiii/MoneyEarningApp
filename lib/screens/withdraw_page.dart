import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WithdrawPage extends StatefulWidget {
  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();
  bool _isProcessing = false;
  String _selectedMethod = "UPI"; // Default withdrawal method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Withdraw Money", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildWalletBalanceCard(),
              SizedBox(height: 20),
              _buildMethodSelector(),
              SizedBox(height: 20),
              _buildTextField(
                controller: _amountController,
                label: "Enter Amount",
                icon: Icons.currency_rupee,
                inputType: TextInputType.number,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _upiController,
                label: _selectedMethod == "UPI" ? "Enter UPI ID" : "Enter Bank Account Details",
                icon: _selectedMethod == "UPI" ? Icons.account_balance_wallet : Icons.account_balance,
                inputType: TextInputType.text,
              ),
              SizedBox(height: 20),
              _buildWithdrawButton(),
              SizedBox(height: 20),
              _buildInfoBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletBalanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.greenAccent, Colors.green]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4))],
      ),
      child: Column(
        children: [
          Text("Available Balance", style: TextStyle(fontSize: 18, color: Colors.white70)),
          SizedBox(height: 10),
          Text("₹0.00", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildMethodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMethodButton("UPI", Icons.qr_code, _selectedMethod == "UPI"),
        SizedBox(width: 10),
        _buildMethodButton("Bank", Icons.account_balance, _selectedMethod == "Bank"),
      ],
    );
  }

  Widget _buildMethodButton(String method, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.black54),
            SizedBox(width: 8),
            Text(method, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, required TextInputType inputType}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildWithdrawButton() {
    return ElevatedButton(
      onPressed: _isProcessing ? null : _withdrawMoney,
      child: _isProcessing
          ? CircularProgressIndicator(color: Colors.white)
          : Text("Withdraw Now", style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.yellow[700]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.yellow[800]),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Withdrawals may take up to 24 hours to process. Ensure your details are correct.",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _withdrawMoney() {
    if (_amountController.text.isEmpty || _upiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields!"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Withdrawal request sent successfully!"), backgroundColor: Colors.green),
      );
    });
  }
}