import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:donne_e_informatica/db/db.dart';
import 'profile.dart'; // Importa la pagina del profilo

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseHelper dbHelper;
  List<Map<String, dynamic>> donne = [];
  int collectedCount = 0;
  int _selectedIndex = 0; // Indice della pagina selezionata

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    _loadItems();
  }

  Future<void> _loadItems() async {
    final data = await dbHelper.queryAllRows();
    setState(() {
      donne = data;
      collectedCount = donne.length;
    });
  }

  Future<void> _addCollected(int idDonna) async {
    Map<String, dynamic> row = {
      'idDonna': idDonna,
    };
    //await dbHelper.insertCollected(row);
    _loadItems();
  }

  void _scanQRCode() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => QRViewScreen(onScanned: (id) {
        _addCollected(id);
        Navigator.of(context).pop(); // Chiude lo schermo del QR scanner
      }),
    ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Gestisce la navigazione in base all'icona cliccata
    if (index == 0) {
      // Resta nella HomePage
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    } else if (index == 1) {
      // Apre lo scanner
      _scanQRCode();
    } else if (index == 2) {
      // Naviga alla pagina profilo
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AccountPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ciao User!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildCard('Carte trovate', '3/10', Icons.person),
                SizedBox(width: 16),
                _buildCard('Altro?', '3/10', Icons.info),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: donne.length,
                itemBuilder: (context, index) {
                  return _buildListItem(
                      donne[index]['nome'], donne[index]['description']);
                },
              ),
            ),
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
        currentIndex: _selectedIndex, // Mostra l'indice selezionato
        selectedItemColor: Colors.red,
        onTap: _onItemTapped, // Gestisce il tap sui bottoni
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, IconData icon) {
    return Expanded(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 48),
              SizedBox(height: 8),
              Text(title, style: TextStyle(fontSize: 18)),
              SizedBox(height: 4),
              Text(subtitle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String title, String subtitle) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}

class QRViewScreen extends StatelessWidget {
  final Function(int) onScanned;

  QRViewScreen({required this.onScanned});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR Code')),
      body: MobileScanner(
        onDetect: (Barcode barcode, MobileScannerArguments? args) {
          final String? code = barcode.rawValue;
          if (code != null) {
            int? idDonna = int.tryParse(code);
            if (idDonna != null) {
              onScanned(idDonna);
            }
          }
        },
      ),
    );
  }
}
