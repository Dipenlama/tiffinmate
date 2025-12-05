import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  children: [
                    TextSpan(text: "Hey Dipen, "),
                    TextSpan(
                      text: "Good Afternoon!",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Search Tiffin",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Featured Item
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/images/food4.png",
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "30% OFF",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 12,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chenille Carpets",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            "Full Veg Tiffin",
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Our Menu",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: ListView(
                  children: [
                    buildMenuCard("Monday", "Rice, Tarkari & roti mix", "assets/images/food2.png"),
                    buildMenuCard("Tuesday", "Thukpa- (chicken/buff)", "assets/images/thukpa.png"),
                    buildMenuCard("Wednesday", "Daal Bhat Tarkari", "assets/images/food3.png"),
                    buildMenuCard("Thursday", "Chana Items", "assets/images/food4.png"),
                    buildMenuCard("Friday", "Sukkha Roti, Tarkari", "assets/images/food5.png"),
                    buildMenuCard("Saturday", "Roti Cauliflower Tarkari", "assets/images/food6.png"),
                    buildMenuCard("Sunday", "Fried Rice (chicken/veg/buff)", "assets/images/food7.png"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuCard(String day, String label, String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Positioned(
              right: 12,
              bottom: 12,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }
}
