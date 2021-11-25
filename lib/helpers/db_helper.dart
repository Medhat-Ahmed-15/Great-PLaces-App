import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

// //We could also just define a couple of functions in that file and therefore use these functions
// in any other file which imports this file but I'm a fan of having a class as a wrapper around that.
class DBHelper {
  static Future<Database> createOrOpenDatabase() async {
    final dbPath = await sql
        .getDatabasesPath(); //that's the path where I may store my database which I am about to create because that database doesn't come together with my app I have to create such a database basically in my app folder or on the har drive in a folder reserved

    return sql.openDatabase(
        //allows to open database either existing one if it finds or it creates a new one Now the path is not just the db path because that's just a folder where we should store the database, it instead has to be the path which includes the database name and for that, I'll use something from the path package here because there, I can use the join method to create a new path made up of the db path and then the second segment here should be places.db, .db is the extension of our database file. So I'll create a new file which is named places and has the db extension in that path which we may use to store our database. Now when open database finds a database here, it will open that so that we can read and write to it. If it doesn't find that file, which is the case when we execute the code for the first time ever in the lifetime of our app, so when it doesn't find that file, it will create the database and therefore, open database gives us another argument which we can specify, the onCreate argument. This takes a function and you can use a named or an anonymous function, a function which will execute when SQL, so SQFLite tries to open the database and doesn't find the file. Then it goes ahead and creates the file and there  I  can run some code to initialize to database when it's created the first time. and I get access to the database using the db parameter
        path.join(dbPath, 'places.db'), onCreate: (db, version) {
      return db.execute(
          //actually, we should return the result of that, so that SQFLite knows when this is done because this returns a future which basically tells SQFLite that it is done but for SQFLite to digest that information, we need to return that future
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL,loc_lng REAL,address TEXT)'); //REAL is double but in sql
    }, version: 1);
  }

  //first of all we need to craete a database if we don't have one
  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.createOrOpenDatabase();
    db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm
            .ignore); //the conflictAlgorithm named argument and I'll set this to conflictAlgorithm.replace and this means that if we're trying to insert data for an ID which already is in the database table, then we'll override the existing entry, the existing record with the new data. Shouldn't really happen but that is how we would do that.
  }

  static Future<List<Map<String, Object>>> getData(String table) async {
    final db = await DBHelper.createOrOpenDatabase();
//.query to get the data
    return db.query(
        table); //return a list of map in it my data which is convenient because I added my data throough map
  }
}
