import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String amount;
  final String date;

  TransactionTile({required this.title, required this.amount, required this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(date),
      trailing: Text(amount, style: TextStyle(color: amount.startsWith('+') ? Colors.green : Colors.red)),
    );
  }
}