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

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    donne = await db.DatabaseHelper.instance.getCollectedBadges();
    setState(() {
      collectedCount = donne.length;
    });
  }

  Widget _buildListItem(String title) {
    return FutureBuilder<String>(
      future: db.DatabaseHelper.getDescription(title),
      builder: (context, snapshot) {
        String fullDescription = snapshot.data ?? 'Descrizione non disponibile';
        return ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              'Ciao!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.badge,
                  size: 90,
                ),
                Text(
                  'Badge trovati \n $collectedCount/10',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 5, thickness: 2),
            Expanded(
              child: collectedCount == 0
                  ? const Center(
                      child: Text(
                        'Inizia a collezionare i badge cercando i pannelli all\'interno del dipartimento',
                        style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
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
}


