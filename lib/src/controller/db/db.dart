import 'package:integration_test_example_app/src/model/sign_in_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/user_model.dart';
import '../repo/repo.dart';

class DB extends Repo {
  final String userDetailsTable = 'UserDetails';
  final String signedInUserTable = 'SignedInUserTable';
  DB._();
  static final DB _internal = DB._();
  static DB instance() => _internal;
  late final Database _db;
  Future<void> initialize() async {
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/demo.db';
    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE $userDetailsTable (userName TEXT PRIMARY KEY, firstName TEXT, lastName TEXT, dob TEXT, password TEXT,  gender TEXT)');
      await db.execute(
          'CREATE TABLE $signedInUserTable (userName TEXT PRIMARY KEY, password TEXT, isRememberMe BOOL)');
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
  Future<bool> removeSignInDetails() async {
    int removeStatus = await _db.delete(
      signedInUserTable,
    );
    if (removeStatus != 0 || (await _db.query(signedInUserTable)).isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> saveSignInDetails(SignInModel signInModel) async {
    int saveStatus = await _db.insert(
      signedInUserTable,
      signInModel.toJson(),
    );
    if (saveStatus != 0) {
      return true;
    } else {
      return false;
    }
  }
}
