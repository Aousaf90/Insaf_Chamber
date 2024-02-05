// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   test('getUserLoggedInStatus retrieves login status from SharedPreferences',
//       () async {
//     final helper = helperFunction();
//     await helper.saveUserLoggedInStatus(true);
//     final isLoggedIn = await helper.getUserLoggedInStatus();
//     expect(isLoggedIn, true);
//   });
// }
import 'package:flutter_test/flutter_test.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('getUsernameStatus retrieves username from SharedPreferences', () async {
    final helper = helperFunction();
    await helperFunction.saveUserName('Jane Smith');
    final username = await helperFunction.getUsernameStatus();
    expect(username, 'Jane Smith');
  });

  test('getUserLoggedInStatus retrieves login status from SharedPreferences',
      () async {
    final helper = helperFunction();
    await helperFunction.saveUserLoggedInStatus(true);
    final isLoggedIn = await helperFunction.getUserLoggedInStatus();
    expect(isLoggedIn, true);
  });

  test('saveUserName saves username to SharedPreferences', () async {
    final helper = helperFunction();
    await helperFunction.saveUserName('John Doe');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(helperFunction.nameKey), 'John Doe');
  });

  test('getUsernameStatus retrieves username from SharedPreferences', () async {
    final helper = helperFunction();
    await helperFunction.saveUserName('Jane Smith');
    final username = await helperFunction.getUsernameStatus();
    expect(username, 'Jane Smith');
  });
}
