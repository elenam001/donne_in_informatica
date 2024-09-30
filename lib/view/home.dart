import 'package:donne_e_informatica/db/db.dart' as db;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<String> donne = [];
  int collectedCount = 0;

  final Map<String, int> badgeMap = {
    'https://womenincs.math.unipd.it/orientamento-1.0/ada_lovelace': 1,
    'https://womenincs.math.unipd.it/orientamento-1.0/hedy_lamarr': 2,
    'https://womenincs.math.unipd.it/orientamento-1.0/barbara_liskov': 3,
    'https://womenincs.math.unipd.it/orientamento-1.0/margaret_hamilton': 4,
    'https://womenincs.math.unipd.it/orientamento-1.0/grace_hopper': 5,
    'https://womenincs.math.unipd.it/orientamento-1.0/frances_elizabeth_allen': 6,
    'https://womenincs.math.unipd.it/orientamento-1.0/fei_fei_li': 7,
    'https://womenincs.math.unipd.it/orientamento-1.0/shafi_goldwasser': 8,
    'https://womenincs.math.unipd.it/orientamento-1.0/luigia_carlucci_aiello': 9,
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
    _loadItems(); // Load collected badges when the HomePage initializes
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    donne = prefs.getStringList('collected_badges') ?? [];
    setState(() {
      collectedCount = donne.length;
      print('Numero di badge trovati aggiornato: $collectedCount');
    });
  }

  Future<void> addCollected(String scannedData) async {
    print("QR Code scansionato: $scannedData");

    int? idDonna = badgeMap[scannedData];

    if (idDonna != null && badgeNames.containsKey(idDonna)) {
      String badgeName = badgeNames[idDonna]!;

      print("Badge riconosciuto: $badgeName");

      if (!donne.contains(badgeName)) {
        donne.add(badgeName);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('collected_badges', donne);

        setState(() {
          collectedCount = donne.length;  // This should trigger the UI update
        });

        _showBadgeAcquiredDialog(context, badgeName);
      } else {
        print("Badge già raccolto!");
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

  void _showBadgeAcquiredDialog(BuildContext context, String badgeName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Badge Acquisito!'),
          content: Text('Hai acquisito il badge: $badgeName!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Map<String, bool> isExpandedMap = {};

  Widget _buildListItem(String title) {
    return FutureBuilder<String>(
      future: db.DatabaseHelper.getDescription(title),
      builder: (context, snapshot) {
        String fullDescription = snapshot.data ?? 'Descrizione non disponibile';
        
        return FutureBuilder<String>(
          future: db.DatabaseHelper.getShortDescription(title),
          builder: (context, shortSnapshot) {
            String shortDescription = shortSnapshot.data ?? 'Breve descrizione non disponibile';

            bool isExpanded = isExpandedMap[title] ?? false;

            return ExpansionTile(
              backgroundColor: const Color.fromARGB(255, 130, 29, 29).withOpacity(0.1),
              collapsedBackgroundColor: const Color.fromARGB(255, 130, 29, 29).withOpacity(0.1),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onExpansionChanged: (expanded) {
                setState(() {
                  isExpandedMap[title] = expanded;
                });
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (!isExpanded) // Show the short description only if not expanded
                    Text(
                      shortDescription,
                      style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                ],
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(fullDescription, style: const TextStyle(fontSize: 16)),
                ),
              ],
            );
          },
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              'Benvenuto!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.person_2,
                  size: 90,
                ),
                Text(
                  'Carte trovate \n $collectedCount/10',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 5, thickness: 2),
            Expanded(
              child: ListView.builder(
                itemCount: donne.length,
                itemBuilder: (context, index) {
                  return _buildListItem(donne[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}/*
import 'package:donne_e_informatica/db/db.dart' as db;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Usa shared_preferences per il web

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> donne = [];
  int collectedCount = 0;

  // Mappa per associare QR code ID ai badge
  final Map<String, int> badgeMap = {
    'https://womenincs.math.unipd.it/orientamento-1.0/ada_lovelace': 1,
    'https://womenincs.math.unipd.it/orientamento-1.0/hedy_lamarr': 2,
    'https://womenincs.math.unipd.it/orientamento-1.0/barbara_liskov': 3,
    'https://womenincs.math.unipd.it/orientamento-1.0/margaret_hamilton': 4,
    'https://womenincs.math.unipd.it/orientamento-1.0/grace_hopper': 5,
    'https://womenincs.math.unipd.it/orientamento-1.0/frances_elizabeth_allen': 6,
    'https://womenincs.math.unipd.it/orientamento-1.0/fei_fei_li': 7,
    'https://womenincs.math.unipd.it/orientamento-1.0/shafi_goldwasser': 8,
    'https://womenincs.math.unipd.it/orientamento-1.0/luigia_carlucci_aiello': 9,
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
          const SnackBar(content: Text('Hai già acquisito questo badge!')),
        );
      }
    } else {
      // Mostra un messaggio di errore se il QR code non è valido
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR code non valido!')),
      );
    }
  }

  // Funzione per mostrare il popup di conferma
  void _showBadgeAcquiredDialog(BuildContext context, String badgeName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Badge Acquisito!'),
          content: Text('Hai acquisito il badge: $badgeName!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildListItem(String title) {
    return FutureBuilder<String>(
      future: db.DatabaseHelper.getDescription(title), // Fetch the full description from the DB
      builder: (context, snapshot) {
        String fullDescription = snapshot.data ?? 'Descrizione non disponibile';

        return ExpansionTile(
          backgroundColor: const Color.fromARGB(255, 238, 238, 238).withOpacity(0.5),
          collapsedBackgroundColor: const Color.fromARGB(255, 238, 238, 238).withOpacity(0.5),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                fullDescription, // Show the full description when expanded
                style: const TextStyle(fontSize: 16),
              ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              'Benvenuto!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.person_2,
                  size: 90,
                  ),
                Text('Carte trovate \n $collectedCount/10', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), // Mostra il conteggio aggiornato dei badge trovati
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(
                height: 5,
                thickness: 2,
                indent: 12,
                endIndent: 12,
              ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: donne.length,
                itemBuilder: (context, index) {
                  return _buildListItem(donne[index]);
                },
              ),
            ),
            /*ElevatedButton(
              onPressed: _simulateQRCodeScan, // Simula lo scan del QR code
              child: Text('Simula Scansione QR'),
            ),*/
          ],
        ),
      ),
    );
  }
*/
/*
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
  }*/

