import 'package:flutter/material.dart';

Widget buildExclusiveOffers() {
  List<Map<String, String>> offers = [
    {"title": "Amazon Gift Card", "discount": "₹50 Off", "image": "assets/amazon.png"},
    {"title": "Flipkart Coupon", "discount": "10% Off", "image": "assets/flipkart.png"},
    {"title": "Uber Ride Discount", "discount": "₹100 Cashback", "image": "assets/uber.png"},
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "🎁 Exclusive Offers",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Changed to black for better visibility
        ),
      ),
      SizedBox(height: 10),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: offers.map((offer) {
            return Container(
              width: 170,
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade200, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(2, 3)),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (offer["image"] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        offer["image"]!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                      ),
                    ),
                  SizedBox(height: 10),
                  Text(
                    offer["title"]!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    offer["discount"]!,
                    style: TextStyle(fontSize: 12, color: Colors.yellowAccent, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Implement claim functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: Text("Claim Now", style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}