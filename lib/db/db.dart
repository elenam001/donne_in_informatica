import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('donne_e_informatica.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute(
      '''
      CREATE TABLE donna ( 
        id $idType, 
        nome $textType,
        description $textType
      )

      INSERT INTO donna [(id, nome, descrizione)]  
      VALUES (1, Ada Lovelace, "Augusta Ada Byron, contessa di Lovelace, nacque il 10 dicembre 1815 a Londra, figlia del celebre poeta Lord Byron e di Anne Isabella Milbanke, un'aristocratica inglese appassionata di matematica. 

      Fin dalla giovane età, Ada ricevette un'educazione rigorosa e completa, comprensiva di musica, lingue straniere e, soprattutto, matematica, grazie alla determinazione della madre di evitare che la figlia seguisse le orme artistiche del padre. Ada fu allieva della nota matematica e astronoma Mary Somerville, che le presentò il matematico Charles Babbage nel 1833. Questa presentazione segnò l'inizio di una collaborazione cruciale nella storia dell'informatica.

      Babbage stava lavorando al progetto della sua Macchina Analitica, un calcolatore meccanico capace di eseguire qualsiasi calcolo matematico complesso. Ada fu profondamente affascinata dalla macchina e dalla sua potenziale applicazione. Nel 1842, Ada tradusse un articolo del matematico italiano Luigi Federico Menabrea che descriveva la Macchina Analitica. La traduzione fu arricchita con note estensive di suo pugno, che risultarono essere più dettagliate e lungimiranti dell'articolo stesso.

      Le note di Ada Lovelace non si limitarono a spiegare il funzionamento della macchina, ma introdussero concetti che oggi sono fondamentali nell'informatica. Ada descrisse un algoritmo per calcolare i numeri di Bernoulli, il che le valse il titolo di "prima programmatrice" della storia. Le sue idee includevano l'uso di subroutine e iterazioni, elementi chiave nei moderni linguaggi di programmazione.

      Ada immaginò che la Macchina Analitica potesse fare molto più che semplici calcoli numerici. Previde che potesse essere programmata per eseguire una varietà di compiti, come comporre musica o manipolare simboli. Questa visione prefigurava l'idea dei computer moderni come strumenti multifunzionali.

      Nonostante non vide mai la Macchina Analitica costruita, Ada Lovelace lasciò un'eredità duratura nel campo dell'informatica. La sua capacità di vedere oltre le applicazioni immediate della macchina di Babbage e di immaginare un futuro in cui le macchine potessero svolgere una vasta gamma di compiti è stata fondamentale. Oggi, in suo onore, ogni anno si celebra l'Ada Lovelace Day, per riconoscere e commemorare i contributi delle donne nelle discipline STEM."
      );

      CREATE TABLE collezionata (
        id $idType
        idDonna $idType
      )
      '''
    );
  }
  Future<int> insertCollected(Map<String, dynamic> row) async {
    final db = await instance.database;

    return await db.insert('collezionata', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await instance.database;

    return await db.query('items');
  }

  Future<int> update(Map<String, dynamic> row) async {
    final db = await instance.database;
    int id = row['id'];

    return await db.update('items', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
