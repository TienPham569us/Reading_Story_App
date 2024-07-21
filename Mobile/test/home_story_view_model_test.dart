import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_login/Models/Story.dart';
import 'package:project_login/Models/Category.dart';
import 'package:project_login/Services/StoryService.dart';
import 'package:project_login/ViewModels/HomeStoryViewModel.dart';

class MockStoryService extends Mock implements StoryService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HomeStoryViewModel viewModel;
  late MockStoryService mockStoryService;

  setUp(() {
    mockStoryService = MockStoryService();
    viewModel = HomeStoryViewModel(storyService: mockStoryService);
  });

  group('HomeStoryViewModel Tests', () {
    test('fetchHomeStories fetches and sets stories correctly', () async {
      Map<String, List<Story>> mockStories = {
        'category1': [
          Story(
            name: 'Story 1',
            cover: 'Cover 1',
            link: 'Link 1',
            title: 'Title 1',
            description: 'Description 1',
            author: 'Author 1',
            authorLink: 'https://www.example.com/',
            view: '1000',
            categories: [Category(content: 'Category 1', url: 'https://www.example.com/')],
            detail: 'Detail 1',
          ),
        ],
        'category2': [
          Story(
            name: 'Story 2',
            cover: 'Cover 2',
            link: 'Link 2',
            title: 'Title 2',
            description: 'Description 2',
            author: 'Author 2',
            authorLink: 'https://www.example.com/',
            view: '2000',
            categories: [Category(content: 'Category 2', url: 'https://www.example.com/')],
            detail: 'Detail 2',
          ),
        ],
      };
      String datasource = "mockDatasource";
      when(mockStoryService.fetchHomeStory(datasource)).thenAnswer((_) async => mockStories);

      await viewModel.fetchHomeStories('mockDatasource');

      expect(viewModel.stories, mockStories);
      expect(viewModel.isLoading, false);
    });

    test('fetchHomeStories handles errors gracefully', () async {
      String datasource = "mockDatasource";
      when(mockStoryService.fetchHomeStory(datasource)).thenThrow(Exception('Failed to fetch stories'));

      await viewModel.fetchHomeStories('mockDatasource');

      expect(viewModel.stories, {});
      expect(viewModel.isLoading, true);
    });

    test('fetchHomeSourceBooks fetches and sets source books correctly', () async {
      SharedPreferences.setMockInitialValues({});
      List<String> mockSourceBooks = ['Source 1', 'Source 2'];

      when(mockStoryService.fetchListNameDataSource()).thenAnswer((_) async => mockSourceBooks);

      await viewModel.fetchHomeSourceBooks();

      expect(viewModel.sourceBooks, mockSourceBooks);
    });

    test('changeSourceBook updates the source book correctly', () {
      String newSourceBook = 'New Source';
      viewModel.changeSourceBook(newSourceBook);

      expect(viewModel.sourceBook, newSourceBook);
    });

    test('changeListOrGrid updates the view type correctly', () {
      viewModel.changeListOrGrid(false);
      expect(viewModel.listOn, false);

      viewModel.changeListOrGrid(true);
      expect(viewModel.listOn, true);
    });

    test('changeIndex updates the index correctly', () {
      int newIndex = 1;
      viewModel.changeIndex(newIndex);

      expect(viewModel.indexSourceBook, newIndex);
    });

    test('reorder updates the source books order correctly', () {
      viewModel.sourceBooks = ['Source 1', 'Source 2', 'Source 3'];

      viewModel.reorder(0, 2);

      expect(viewModel.sourceBooks, ['Source 2', 'Source 1', 'Source 3']);
    });

    test('changeCategory updates the category correctly', () {
      String newCategory = 'New Category';
      viewModel.changeCategory(newCategory);

      expect(viewModel.category, newCategory);
    });

    test('changeScreenType updates the screen type correctly', () {
      String newScreenType = 'New Screen';
      viewModel.changeScreenType(newScreenType);

      expect(viewModel.screenType, newScreenType);
    });

    test('changeIsLoading updates the loading state correctly', () {
      viewModel.changeIsLoading(false);
      expect(viewModel.isLoading, false);
    });

    test('saveStringList saves string list to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      List<String> testList = ['Item 1', 'Item 2'];
      await viewModel.saveStringList('test_key', testList);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('test_key'), jsonEncode(testList));
    });

    test('getStringList retrieves string list from SharedPreferences', () async {
      List<String> testList = ['Item 1', 'Item 2'];
      SharedPreferences.setMockInitialValues({'test_key': jsonEncode(testList)});

      List<String>? result = await viewModel.getStringList('test_key');
      expect(result, testList);
    });

    test('checkSimilarity returns true for similar lists', () {
      List<String> list1 = ['Item 1', 'Item 2'];
      List<String> list2 = ['Item 2', 'Item 1'];

      expect(viewModel.checkSimilarity(list1, list2), true);
    });

    test('checkSimilarity returns false for different lists', () {
      List<String> list1 = ['Item 1', 'Item 2'];
      List<String> list2 = ['Item 3', 'Item 4'];

      expect(viewModel.checkSimilarity(list1, list2), false);
    });
  });
}

