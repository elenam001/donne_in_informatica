import 'package:flutter/material.dart';
import 'package:donne_e_informatica/view/home.dart';
import 'package:donne_e_informatica/view/camera.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  // Create a GlobalKey to access the HomePageState
  final GlobalKey<HomePageState> homePageKey = GlobalKey<HomePageState>();
  
  late List<Widget> _pages;
  
  @override
  void initState() {
    super.initState();

    // Initialize the pages with the GlobalKey for HomePage
    _pages = <Widget>[
      HomePage(key: homePageKey),
      QRCodeScannerPage(onScanned: (String scannedData) {
        setState(() {
          _selectedIndex = 0;
        });
        
        homePageKey.currentState?.addCollected(scannedData); //TODO c'è un problema qui e non entra nel metodo però per il resto va

        homePageKey.currentState?.setState(() {});
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],  // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 130, 29, 29),
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.camera),
            icon: Icon(Icons.camera_outlined),
            label: 'QR Scan',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
