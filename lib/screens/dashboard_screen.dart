import 'package:flutter/material.dart';
import 'package:tiffinmate/features/bookings/presentation/pages/bookings_list_screen.dart';
import 'package:tiffinmate/screens/bottom_Screen/about.dart';
import 'package:tiffinmate/screens/bottom_Screen/menu_screen.dart';
import 'package:tiffinmate/screens/bottom_Screen/home_screen.dart';
import 'package:tiffinmate/screens/bottom_Screen/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<DashboardScreen> {

  int _selectedIndex=0;
  List<Widget> lstBottomScreen=[
    const HomeScreen(),
    const MenuScreen(),
    const BookingsListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:AppBar(
      //   title: Text("buttom navigation screen "), backgroundColor: Colors.greenAccent,
      // ) ,
      body: lstBottomScreen [_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black26,
        type: BottomNavigationBarType.fixed,
        items: const[
        BottomNavigationBarItem(icon: Icon(Icons.home),
        label: 'Home'),
        
        BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu),
        label: 'Menu'),
        
        BottomNavigationBarItem(icon: Icon(Icons.album_outlined),
        label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.person),
        label: 'profile'),
<<<<<<< HEAD
        BottomNavigationBarItem(icon: Icon(Icons.album_outlined),
        label: 'About')
      <uses-permission android:name="android.permission.CAMERA" />
      <!-- For Android 13+ -->
      <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
      <!-- For older Android versions -->
      <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />      ],
=======
      ],
>>>>>>> ea6c531c00e0006e1206e631070b59bac692c3af
      backgroundColor: Colors.lightBlue,
      
      currentIndex: _selectedIndex,
    onTap: (index) {
      setState(() {
        _selectedIndex=index;
      });
    } ,
      ),
      
    );
  }
}