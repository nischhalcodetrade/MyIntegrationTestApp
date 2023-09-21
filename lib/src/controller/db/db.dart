import 'package:integration_test_example_app/src/model/sign_in_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/user_model.dart';
import '../repo/repo.dart';

class DB extends Repo {
  DB._();
  static final DB _internal = DB._();
  static DB instance() => _internal;

  final String userDetailsTable = 'UserDetails';
  final String signedInUserTable = 'SignedInUserTable';
  late final Database _db;

  Future<void> initialize() async {
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/demo.db';
    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE $userDetailsTable (userName TEXT PRIMARY KEY, firstName TEXT, lastName TEXT, dob TEXT, password TEXT,  gender TEXT)');
      await db.execute(
          'CREATE TABLE $signedInUserTable (userName TEXT PRIMARY KEY, password TEXT, isRememberMe BOOL, alreadySignedIn BOOL)');
    });
  }

  @override
  Future<UserModel?> getUserDetails(String userName) async {
    List<Map<String, dynamic>> userData = await _db
        .query(userDetailsTable, where: 'userName = ?', whereArgs: [userName]);
    if (userData.isNotEmpty) {
      return UserModel.fromJson(userData[0]);
    } else {
      return null;
    }
  }

  @override
  Future<bool> saveNewUser(UserModel userModel) async {
    int insertionStatus = await _db.insert(userDetailsTable, userModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.rollback);

    if (insertionStatus != 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> removeUserDetail(String userName) async {
    int userDeleted = await _db
        .delete(userDetailsTable, where: 'userName = ?', whereArgs: [userName]);
    if (userDeleted != 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<SignInModel?> getSignInDetails() async {
    List<Map<String, dynamic>> signInDetails =
        await _db.query(signedInUserTable);
    if (signInDetails.isNotEmpty) {
      return SignInModel.formJson(signInDetails.last);
    } else {
      return null;
    }
  }

  @override
  Future<bool> signOut(String userName) async {
    SignInModel signInModel = SignInModel.formJson((await _db.query(
            signedInUserTable,
            where: 'userName == ?',
            whereArgs: [userName]))
        .first);
    if (signInModel.isRememberMe) {
      int updateTable = await _db.update(
          signedInUserTable, {'alreadySignedIn': false.toString()},
          where: 'userName ==  ?',
          whereArgs: [userName],
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (updateTable != 0) {
        return true;
      } else {
        return false;
      }
    } else {
      int removeStatus = await _db.delete(
        signedInUserTable,
      );
      if (removeStatus != 0 || (await _db.query(signedInUserTable)).isEmpty) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Future<bool> saveSignInDetails(SignInModel signInModel) async {
    await _db.delete(signedInUserTable);
    int saveStatus = await _db.insert(signedInUserTable, signInModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    if (saveStatus != 0) {
      return true;
    } else {
      return false;
    }
  }
}
