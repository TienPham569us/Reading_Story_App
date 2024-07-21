import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:project_login/ViewModels/SearchViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SearchViewModel viewModel;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    viewModel = SearchViewModel();
  });

  group('SearchViewModel Tests', () {

    test('insertHistory adds a new search string to history list', () {
      String searchString = "Flutter";
      viewModel.insertHistory(searchString);
      expect(viewModel.historylist.contains(searchString), true);
    });

    test('insertHistory does not add duplicate search string to history list', () {
      String searchString = "Flutter";
      viewModel.insertHistory(searchString);
      viewModel.insertHistory(searchString);
      expect(viewModel.historylist.length, 1);
    });

    test('deleteAll clears the history list', () {
      viewModel.insertHistory("Flutter");
      viewModel.deleteAll();
      expect(viewModel.historylist.isEmpty, true);
    });

    test('saveAll saves the history list to SharedPreferences', () async {
      viewModel.deleteAll();
      String searchString = "Flutter";
      viewModel.insertHistory(searchString);
      viewModel.saveAll();

      // Wait for SharedPreferences to save
      await Future.delayed(Duration(milliseconds: 100));

      final savedList = await viewModel.getStringList("Historysearch");
      expect(savedList, isNotNull);
      expect(savedList, viewModel.historylist);
    });


    test('fetchHistoryList fetches and sets the history list from SharedPreferences', () async {
      List<String> mockHistoryList = ['Flutter', 'Dart'];
      await sharedPreferences.setString('Historysearch', jsonEncode(mockHistoryList));
      await viewModel.fetchHistoryList();
      expect(viewModel.historylist, mockHistoryList);
    });

    test('saveStringList saves string list to SharedPreferences', () async {
      List<String> testList = ['Item 1', 'Item 2'];
      await viewModel.saveStringList('test_key', testList);
      final savedList = sharedPreferences.getString('test_key');
      expect(savedList, isNotNull);
      expect(savedList, jsonEncode(testList));
    });

    test('getStringList retrieves string list from SharedPreferences', () async {
      List<String> testList = ['Item 1', 'Item 2'];
      await sharedPreferences.setString('test_key', jsonEncode(testList));
      final fetchedList = await viewModel.getStringList('test_key');
      expect(fetchedList, isNotNull);
      expect(fetchedList, testList);
    });

    test('getStringList returns null if key does not exist', () async {
      final fetchedList = await viewModel.getStringList('nonexistent_key');
      expect(fetchedList, isNull);
    });
  });
}
