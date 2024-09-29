import 'package:donne_e_informatica/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Usa shared_preferences per il web

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> donne = [];
  int collectedCount = 0;
  int _selectedIndex = 0; // Indice della pagina selezionata

  // Mappa per associare QR code ID ai badge
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

  @override
  void initState() {
    super.initState();
    _loadItems(); // Carica i badge trovati al caricamento della pagina
  }

  // Carica i badge trovati da shared_preferences
  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    donne = prefs.getStringList('collected_badges') ?? [];
    setState(() {
      collectedCount = donne.length;
      print('Numero di badge trovati aggiornato: $collectedCount');
    });
  }

  // Aggiunge un badge trovato e aggiorna la lista
  Future<void> _addCollected(String scannedData) async {
    print("QR Code scansionato: $scannedData");

    int? idDonna = badgeMap[scannedData];

    if (idDonna != null && badgeNames.containsKey(idDonna)) {
      String badgeName = badgeNames[idDonna]!;

      print("Badge riconosciuto: $badgeName");

      if (!donne.contains(badgeName)) {
        donne.add(badgeName);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('collected_badges', donne); // Salva i badge

        setState(() {
          collectedCount = donne.length;
        });

        // Mostra il popup per il badge acquisito
        _showBadgeAcquiredDialog(context, badgeName);
      } else {
        print("Badge già raccolto!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hai già acquisito questo badge!')),
        );
      }
    } else {
      // Mostra un messaggio di errore se il QR code non è valido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR code non valido!')),
      );
    }
  }

  // Funzione per mostrare il popup di conferma
  void _showBadgeAcquiredDialog(BuildContext context, String badgeName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Badge Acquisito!'),
          content: Text('Hai acquisito il badge: $badgeName!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Simula la scansione di un QR code
  void _simulateQRCodeScan() {
    String simulatedQRCode =
        "https://womenincs.math.unipd.it/orientamento-1.0/ada_lovelace";
    _addCollected(simulatedQRCode); // Simula l'acquisizione del badge
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      _loadItems(); // Aggiorna la pagina quando si clicca sulla Home
    } else if (index == 1) {
      _simulateQRCodeScan(); // Simula la scansione del QR
    } else if (index == 2) {
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
                _buildCard(
                    'Carte trovate',
                    '$collectedCount/10',
                    Icons
                        .person), // Mostra il conteggio aggiornato dei badge trovati
                SizedBox(width: 16),
                _buildCard('Altro?', '3/10', Icons.info),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: donne.length,
                itemBuilder: (context, index) {
                  return _buildListItem(donne[index], 'Descrizione del badge');
                },
              ),
            ),
            ElevatedButton(
              onPressed: _simulateQRCodeScan, // Simula lo scan del QR code
              child: Text('Simula Scansione QR'),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }

  // Costruisce una card per mostrare il titolo e il sottotitolo
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

  // Costruisce un elemento della lista per i dettagli dei badge trovati
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
