import 'package:flutter/material.dart';
import 'package:donne_e_informatica/view/home.dart';
import 'package:donne_e_informatica/db/db.dart' as db;
import 'package:donne_e_informatica/view/camera.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = <Widget>[
      HomePage(), // HomePage will only show collected badges
      QRCodeScannerPage(onScanned: (String scannedData) async {
        // Directly handle badge collection in Navigation
        await _handleCollectedBadge(scannedData);

        // Switch to the HomePage after the badge is processed
        setState(() {
          _selectedIndex = 0;
        });
      }),
    ];
  }

  Future<void> _handleCollectedBadge(String scannedData) async {
    final Map<String, int> badgeMap = {
      'https://womenincs.math.unipd.it/orientamento-1.0/ada_lovelace': 1,
      'https://womenincs.math.unipd.it/orientamento-1.0/hedy_lamarr': 2,
      'https://womenincs.math.unipd.it/orientamento-1.0/barbara_liskov': 3,
      'https://womenincs.math.unipd.it/orientamento-1.0/margaret_hamilton': 4,
      'https://womenincs.math.unipd.it/orientamento-1.0/grace_hopper': 5,
      'https://womenincs.math.unipd.it/orientamento-1.0/frances_elizabeth_allen':
          6,
      'https://womenincs.math.unipd.it/orientamento-1.0/fei_fei_li': 7,
      'https://womenincs.math.unipd.it/orientamento-1.0/shafi_goldwasser': 8,
      'https://womenincs.math.unipd.it/orientamento-1.0/luigia_carlucci_aiello':
          9,
      'https://womenincs.math.unipd.it/orientamento-1.0/code_girls': 10,
    };

    final Map<int, String> badgeNames = {
      1: 'Ada Lovelace',
      2: 'Hedy Lamarr',
      3: 'Barbara Liskov',
      4: 'Margaret Hamilton',
      5: 'Grace Hopper',
      6: 'Frances Elizabeth Allen',
      7: 'Fei-Fei Li',
      8: 'Shafi Goldwasser',
      9: 'Luigia Carlucci Aiello',
      10: 'Code Girls',
    };

    int? idDonna = badgeMap[scannedData];
    if (idDonna != null && badgeNames.containsKey(idDonna)) {
      String badgeName = badgeNames[idDonna]!;

      bool alreadyCollected =
          await db.DatabaseHelper.instance.isBadgeCollected(badgeName);

      if (!alreadyCollected) {
        await db.DatabaseHelper.instance.addCollectedBadge(badgeName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hai acquisito il badge: $badgeName!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hai già acquisito questo badge!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR code non valido!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            const Color.fromARGB(255, 130, 29, 29), // Sfondo rosso scuro
        selectedItemColor: Colors.white, // Icona e testo selezionati bianchi
        unselectedItemColor:
            Colors.white, // Icona e testo non selezionati bianchi
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.camera_alt),
            icon: Icon(Icons.camera_alt_outlined),
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
