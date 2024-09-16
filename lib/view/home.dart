import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:donne_e_informatica/db/db.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseHelper dbHelper;
  List<Map<String, dynamic>> donne = [];
  int collectedCount = 0;

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
    await dbHelper.insertCollected(row);
    _loadItems();
  }

  void _scanQRCode() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => QRViewScreen(onScanned: (id) {
        _addCollected(id);
        Navigator.of(context).pop(); // Close the scanner screen
      }),
    ));
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
              'Ciao!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildCard('Donne Collected', '$collectedCount donne', Icons.person),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: donne.length,
                itemBuilder: (context, index) {
                  return _buildListItem(donne[index]['nome'], donne[index]['description']);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQRCode,
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, IconData icon) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
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
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

