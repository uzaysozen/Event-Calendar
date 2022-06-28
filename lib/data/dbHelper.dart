import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database? _db;

Future<Database?> get db async{
  if (_db == null){
    _db = await initDb();
  }
  return _db;
}

Future<Database?> initDb() async{
  String dbPath = join(await getDatabasesPath(), "countdown.db");
  var countdownDb = await openDatabase(dbPath, version: 1, onCreate: dbCreate);
  return countdownDb;
}

void dbCreate(Database db, int version) async{
  await db.execute("Create table events(id integer primary key, name text, description text, endDate date)");
}

