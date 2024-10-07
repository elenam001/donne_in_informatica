/*import 'package:flutter/material.dart';
import 'home.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:donne_e_informatica/db/db.dart'; 

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    } else if (index == 1) {
      _scanQRCode();
    } else if (index == 2) {
    }
  }

  void _scanQRCode() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          QRViewScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOptionCard('Impostazioni', Icons.chevron_right),
            SizedBox(height: 16),
            _buildOptionCard('Badges', Icons.chevron_right),
            SizedBox(height: 16),
            _buildOptionCard('Informazioni', Icons.chevron_right),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex, // Evidenzia l'elemento selezionato
        selectedItemColor: Colors.red,
        onTap:
            _onItemTapped, // Chiama la funzione _onItemTapped quando si clicca su un'icona
      ),
    );
  }

  Widget _buildOptionCard(String title, IconData trailingIcon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(trailingIcon),
        onTap: () {
        },
      ),
    );
  }
}

class QRViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scanner QR')),
      body: MobileScanner(
        onDetect: (barcode, args) {
          final String? code = barcode.rawValue;
          if (code != null) {
            print('QR Code trovato: $code');
          }
        },
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: AccountPage(),
    ));
*/