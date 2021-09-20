import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static var db, userCollection;
  static var MONGO_CONN_URL =
      'mongodb+srv://amaterasu:42sqEzzucN55oX02@unit-camera.wfqou.gcp.mongodb.net/Camera-Unit-db?retryWrites=true&w=majority';
  static var USER_COLLECTION = 'hitobito';

  Future cleanupDatabase() async {
    await db.close();
  }

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    userCollection = db.collection(USER_COLLECTION);
  }

  static Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      final users = await userCollection.find().toList();
      return users;
    } catch (e) {
      return Future.value();
    }
  }

  static authLogin(passcode) async {
    try {
      final res =
          await userCollection.findOne(where.eq('pinid', '${passcode}'));
      if (res['pinid'] == passcode) {
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
