// import 'dart:async';
// import 'package:path/path.dart' as p;
// import 'package:sqflite/sqflite.dart';

// /// Versão do schema:
// /// v1: estrutura inicial (tabela `transactions`)
// /// v2: adiciona `person`, `category`, `personId`, `categoryId` e seed "EU".
// const int _kDbVersion = 2;
// const String _kDbName = 'contas_facil.db';

// class AppDatabase {
//   AppDatabase._();
//   static final AppDatabase instance = AppDatabase._();

//   Database? _database;

//   /// ✅ CORREÇÃO: Getter público para acessar o database
//   Database get db {
//     if (_database == null) {
//       throw Exception('Database não inicializado. Chame init() primeiro.');
//     }
//     return _database!;
//   }

//   /// ✅ CORREÇÃO: Método público de inicialização
//   Future<void> init() async {
//     print('[DB] [init] Chamado...');
//     if (_database != null) {
//       print('[DB] Já em memória, retornando...');
//       return;
//     }
//     try {
//       print('[DB] _initDatabase chamado...');
//       _database = await _initDatabase();
//       print('[DB] Banco inicializado!');
//     } catch (e, s) {
//       print('[DB] ERRO ao abrir banco: $e');
//       print(s);
//       rethrow;
//     }
//   }

//   // =========================================================
//   // =============== Inicialização do banco ==================
//   // =========================================================

//   Future<Database> _initDatabase() async {
//     final dbPath = await getDatabasesPath();
//     final fullPath = p.join(dbPath, _kDbName);
//     print('[DB] _initDatabase: path: $fullPath');

//     try {
//       final db = await openDatabase(
//         fullPath,
//         version: _kDbVersion,
//         onCreate: _onCreate,
//         onUpgrade: _onUpgrade,
//         onOpen: (db) async {
//           print('[DB] onOpen chamado.');
//           await db.execute('PRAGMA foreign_keys = ON;');
//         },
//       );
//       print('[DB] openDatabase retornou OK!');
//       return db;
//     } catch (e, s) {
//       print('[DB] ERRO em openDatabase: $e');
//       print(s);
//       rethrow;
//     }
//   }

//   // =========================================================
//   // =============== Criação inicial ==========================
//   // =========================================================
//   Future<void> _onCreate(Database db, int version) async {
//     print('[DB] _onCreate chamado (version $version)');
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS transactions(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         amount REAL NOT NULL,
//         date INTEGER NOT NULL,
//         note TEXT
//       );
//     ''');

//     await _createPerson(db);
//     await _createCategory(db);

//     await _safeAddColumn(db, 'transactions', 'personId', 'INTEGER');
//     await _safeAddColumn(db, 'transactions', 'categoryId', 'INTEGER');

//     await _ensureDefaultPersonEU(db);
//     await db.execute('UPDATE transactions SET personId = 1 WHERE personId IS NULL;');

//     await _createIndices(db);
//     print('[DB] _onCreate concluído.');
//   }

//   // =========================================================
//   // =============== Upgrade de versão ========================
//   // =========================================================
//   Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
//     print('[DB] _onUpgrade chamado: $oldVersion → $newVersion');
//     await db.execute('PRAGMA foreign_keys = OFF;');
//     try {
//       if (oldVersion < 2) {
//         await _createPerson(db);
//         await _createCategory(db);
//         await _safeAddColumn(db, 'transactions', 'personId', 'INTEGER');
//         await _safeAddColumn(db, 'transactions', 'categoryId', 'INTEGER');
//         await _ensureDefaultPersonEU(db);
//         await db.execute('UPDATE transactions SET personId = 1 WHERE personId IS NULL;');
//         await _createIndices(db);
//       }
//     } finally {
//       await db.execute('PRAGMA foreign_keys = ON;');
//     }
//     print('[DB] _onUpgrade concluído.');
//   }

//   // =========================================================
//   // =============== Criação de tabelas =======================
//   // =========================================================
//   Future<void> _createPerson(Database db) async {
//     print('[DB] Criando tabela person...');
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS person(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT NOT NULL UNIQUE,
//         createdAt INTEGER NOT NULL
//       );
//     ''');
//   }

//   Future<void> _createCategory(Database db) async {
//     print('[DB] Criando tabela category...');
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS category(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT NOT NULL UNIQUE,
//         colorHex INTEGER,
//         icon TEXT
//       );
//     ''');
//   }

//   Future<void> _createIndices(Database db) async {
//     print('[DB] Criando índices...');
//     await db.execute('CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions(date);');
//     await db.execute('CREATE INDEX IF NOT EXISTS idx_transactions_person ON transactions(personId);');
//     await db.execute('CREATE INDEX IF NOT EXISTS idx_transactions_category ON transactions(categoryId);');
//   }

//   // =========================================================
//   // =============== Utilitários internos =====================
//   // =========================================================
//   Future<void> _safeAddColumn(Database db, String table, String column, String type) async {
//     print('[DB] Verificando coluna $column em $table...');
//     final info = await db.rawQuery('PRAGMA table_info($table);');
//     final exists = info.any((m) => (m['name'] as String?)?.toLowerCase() == column.toLowerCase());
//     if (!exists) {
//       print('[DB] Adicionando coluna $column à $table...');
//       await db.execute('ALTER TABLE $table ADD COLUMN $column $type;');
//     }
//   }

//   Future<void> _ensureDefaultPersonEU(Database db) async {
//     print('[DB] Garantindo person EU...');
//     final rows = await db.query('person', columns: ['id'], where: 'name = ?', whereArgs: ['EU']);
//     if (rows.isEmpty) {
//       try {
//         print('[DB] Inserindo person EU com id 1...');
//         await db.insert('person', {
//           'id': 1,
//           'name': 'EU',
//           'createdAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
//         });
//       } catch (_) {
//         print('[DB] Inserindo person EU sem id...');
//         await db.insert('person', {
//           'name': 'EU',
//           'createdAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
//         });
//       }
//     }
//   }

//   // =========================================================
//   // =============== Funções públicas =========================
//   // =========================================================
//   Future<T> txn<T>(Future<T> Function(Transaction) action) async {
//     final db = await _initDatabase(); // ✅ Corrigido para usar _initDatabase
//     return db.transaction<T>((tx) => action(tx));
//   }

//   Future<void> close() async {
//     print('[DB] Fechando conexão do banco...');
//     await _database?.close();
//     _database = null;
//   }
// }




import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Versão do schema:
/// v1: estrutura inicial (tabela `transactions`)
/// v2: adiciona `person`, `category`, `personId`, `categoryId` e seed "EU".
const int _kDbVersion = 2;
const String _kDbName = 'contas_facil.db';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  /// ✅ CORREÇÃO: Getter público para acessar o database
  Database get db {
    if (_database == null) {
      throw Exception('Database não inicializado. Chame init() primeiro.');
    }
    return _database!;
  }

  /// ✅ CORREÇÃO: Método público de inicialização
  Future<void> init() async {
    print('[DB] [init] Chamado...');
    if (_database != null) {
      print('[DB] Já em memória, retornando...');
      return;
    }
    try {
      print('[DB] _initDatabase chamado...');
      _database = await _initDatabase();
      print('[DB] Banco inicializado!');
    } catch (e, s) {
      print('[DB] ERRO ao abrir banco: $e');
      print(s);
      rethrow;
    }
  }

  // =========================================================
  // =============== Inicialização do banco ==================
  // =========================================================

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final fullPath = p.join(dbPath, _kDbName);
    print('[DB] _initDatabase: path: $fullPath');

    try {
      final db = await openDatabase(
        fullPath,
        version: _kDbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onOpen: (db) async {
          print('[DB] onOpen chamado.');
          await db.execute('PRAGMA foreign_keys = ON;');
        },
      );
      print('[DB] openDatabase retornou OK!');
      return db;
    } catch (e, s) {
      print('[DB] ERRO em openDatabase: $e');
      print(s);
      rethrow;
    }
  }

  // =========================================================
  // =============== Criação inicial ==========================
  // =========================================================
  Future<void> _onCreate(Database db, int version) async {
    print('[DB] _onCreate chamado (version $version)');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        date INTEGER NOT NULL,
        note TEXT
      );
    ''');

    await _createPerson(db);
    await _createCategory(db);

    await _safeAddColumn(db, 'transactions', 'personId', 'INTEGER');
    await _safeAddColumn(db, 'transactions', 'categoryId', 'INTEGER');

    await _ensureDefaultPersonEU(db);
    
    // ✅ CORREÇÃO: Busque o ID real da pessoa "EU" após a inserção
    final euPerson = await db.query('person', where: 'name = ?', whereArgs: ['EU']);
    if (euPerson.isNotEmpty) {
      final euId = euPerson.first['id'] as int;
      await db.execute('UPDATE transactions SET personId = $euId WHERE personId IS NULL;');
    }

    await _createIndices(db);
    print('[DB] _onCreate concluído.');
  }

  // =========================================================
  // =============== Upgrade de versão ========================
  // =========================================================
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('[DB] _onUpgrade chamado: $oldVersion → $newVersion');
    await db.execute('PRAGMA foreign_keys = OFF;');
    try {
      if (oldVersion < 2) {
        await _createPerson(db);
        await _createCategory(db);
        await _safeAddColumn(db, 'transactions', 'personId', 'INTEGER');
        await _safeAddColumn(db, 'transactions', 'categoryId', 'INTEGER');
        await _ensureDefaultPersonEU(db);
        
        // ✅ CORREÇÃO: Busque o ID real da pessoa "EU"
        final euPerson = await db.query('person', where: 'name = ?', whereArgs: ['EU']);
        if (euPerson.isNotEmpty) {
          final euId = euPerson.first['id'] as int;
          await db.execute('UPDATE transactions SET personId = $euId WHERE personId IS NULL;');
        }
        
        await _createIndices(db);
      }
    } finally {
      await db.execute('PRAGMA foreign_keys = ON;');
    }
    print('[DB] _onUpgrade concluído.');
  }

  // =========================================================
  // =============== Criação de tabelas =======================
  // =========================================================
  Future<void> _createPerson(Database db) async {
    print('[DB] Criando tabela person...');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS person(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        createdAt INTEGER NOT NULL
      );
    ''');
  }

  Future<void> _createCategory(Database db) async {
    print('[DB] Criando tabela category...');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS category(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        colorHex INTEGER,
        icon TEXT
      );
    ''');
  }

  Future<void> _createIndices(Database db) async {
    print('[DB] Criando índices...');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions(date);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_transactions_person ON transactions(personId);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_transactions_category ON transactions(categoryId);');
  }

  // =========================================================
  // =============== Utilitários internos =====================
  // =========================================================
  Future<void> _safeAddColumn(Database db, String table, String column, String type) async {
    print('[DB] Verificando coluna $column em $table...');
    final info = await db.rawQuery('PRAGMA table_info($table);');
    final exists = info.any((m) => (m['name'] as String?)?.toLowerCase() == column.toLowerCase());
    if (!exists) {
      print('[DB] Adicionando coluna $column à $table...');
      await db.execute('ALTER TABLE $table ADD COLUMN $column $type;');
    }
  }

  Future<void> _ensureDefaultPersonEU(Database db) async {
    print('[DB] Garantindo person EU...');
    final rows = await db.query('person', columns: ['id'], where: 'name = ?', whereArgs: ['EU']);
    if (rows.isEmpty) {
      try {
        // ✅ CORREÇÃO: Removido o ID fixo - deixe o AUTOINCREMENT funcionar
        print('[DB] Inserindo person EU...');
        await db.insert('person', {
          'name': 'EU',
          'createdAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        });
      } catch (e) {
        print('[DB] Erro ao inserir person EU: $e');
      }
    }
  }

  // =========================================================
  // =============== Funções públicas =========================
  // =========================================================
  Future<T> txn<T>(Future<T> Function(Transaction) action) async {
    // ✅ CORREÇÃO: Use o database já inicializado em vez de criar nova conexão
    if (_database == null) {
      await init();
    }
    return _database!.transaction<T>((tx) => action(tx));
  }

  Future<void> close() async {
    print('[DB] Fechando conexão do banco...');
    await _database?.close();
    _database = null;
  }
}