import 'package:countdown_app/models/event.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database? _db;

  Future<Database?> get db async{
    if (_db == null){
      _db = await initDb();
    }
    return _db;
  }

  Future<Database?> initDb() async{
    String dbPath = join(await getDatabasesPath(), "countdown.db");
    //databaseFactory.deleteDatabase(dbPath);
    var countdownDb = await openDatabase(dbPath, version: 1, onCreate: dbCreate);
    return countdownDb;
  }

  void dbCreate(Database db, int version) async{
    await db.execute("Create table events(id integer primary key, name text, description text, endDate date)");
  }

  Future<List<Event>?> getEvents() async {
    Database? db = await this.db;
    var result = await db?.query("events");
    return List.generate(result!.length, (index) {
      return Event.fromObject(result[index]);
    });
  }

  Future<int?> insert(Event event) async{
    Database? db = await this.db;
    var result = await db?.insert("events", event.toMap());
    return result;
  }

  Future<int?> delete(int id) async{
    Database? db = await this.db;
    var result = await db?.rawDelete("delete from events where id= $id");
    return result;
  }

  Future<int?> update(Event event) async{
    Database? db = await this.db;
    var result = await db?.update("events", event.toMap(), where: "id=?", whereArgs: [event.id]);
    return result;
  }

}


