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

    // Creazione della tabella "donna"
    await db.execute('''
      CREATE TABLE donna ( 
        id $idType, 
        nome $textType,
        description $textType
      );
    ''');


    // Creazione della tabella "collezionata"
    await db.execute('''
      CREATE TABLE collezionata (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome $textType
      );
    ''');


    // Inserimento dei dati nella tabella "donna"
    await _insertInitialData(db);
    
  }

  Future _insertInitialData(Database db) async {
    await db.execute('''
      INSERT INTO donna (nome, description) VALUES 
      ('Ada Lovelace', 'Augusta Ada Byron, contessa di Lovelace, pioniera della programmazione.'),
      ('Hedy Lamarr', 'Attrice e inventrice, brevettò un sistema di comunicazione segreta basato sul frequency hopping.'),
      ('Barbara Liskov', 'Prima donna a conseguire un dottorato in Informatica negli USA, creatrice del linguaggio CLU.'),
      ('Margaret Hamilton', 'Ingegnere del software per il programma Apollo della NASA, contribuì all''allunaggio.'),
      ('Grace Hopper', 'Pioniera dell''informatica, sviluppò il primo compilatore per computer e contribuì allo sviluppo di COBOL.'),
      ('Frances Elizabeth Allen', 'Prima donna a vincere il Premio Turing per i suoi contributi all''ottimizzazione dei compilatori.'),
      ('Fei-Fei Li', 'Professoressa di Stanford e creatrice di ImageNet, una risorsa chiave per il deep learning.'),
      ('Shafi Goldwasser', 'Figura di spicco nella crittografia e nell''informatica teorica, vincitrice del Turing Award.'),
      ('Luigia Carlucci Aiello', 'Fondatrice dell''intelligenza artificiale in Italia e promotrice di progetti di ricerca su sistemi intelligenti.'),
      ('Code Girls', 'Oltre 10.000 donne americane reclutate per decifrare codici durante la Seconda Guerra Mondiale.');

    ''');
  }

  Future<bool> isBadgeCollected(String badgeName) async {
    final db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'collezionata',
      where: 'nome = ?',
      whereArgs: [badgeName],
    );
    return result.isNotEmpty;
  }

  Future<void> addCollectedBadge(String badgeName) async {
    final db = await instance.database;
    await db.insert('collezionata', {'nome': badgeName});
  }

  Future<List<String>> getCollectedBadges() async {
    final db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('collezionata');
    return result.map((row) => row['nome'] as String).toList();
  }


  static Future<String> getDescription(String badgeName) async {
    final db = await instance.database;


    // Query the description from the "donna" table where "nome" matches the badge name
    List<Map<String, dynamic>> result = await db.query(
      'donna',
      where: 'nome = ?',
      whereArgs: [badgeName],
    );

    if (result.isNotEmpty) {
      return result[0]['description']; // Return the description
    } else {
      return 'Descrizione non disponibile.'; // Fallback message
    }
  }

  static Future<String> getShortDescription(String badgeName) async {
  final db = await instance.database;
  
  // Query the description from the "donna" table where "nome" matches the badge name
  List<Map<String, dynamic>> result = await db.query(
    'donna',
    where: 'nome = ?',
    whereArgs: [badgeName],
  );

  if (result.isNotEmpty) {
    String description = result[0]['description'];
    return description.length > 50 ? description.substring(0, 50) + '...' : description;
  } else {
    return 'Descrizione non disponibile.';
  }
}

  Future<int> insertCollected(Map<String, dynamic> row) async {
    final db = await instance.database;

    return await db.insert('collezionata', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await instance.database;

    return await db.query('donna');
  }

  Future<int> update(Map<String, dynamic> row) async {
    final db = await instance.database;
    int id = row['id'];

    return await db.update('donna', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete('donna', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
