import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_login/Models/Category.dart';
import 'package:project_login/Models/Story.dart';
import 'package:project_login/Services/StoryService.dart';
import 'package:project_login/ViewModels/ListSearchViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockStoryService extends Mock implements StoryService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ListSearchViewModel viewModel;
  late MockStoryService mockStoryService;

  setUp(() {
    mockStoryService = MockStoryService();
    viewModel = ListSearchViewModel(storyService: mockStoryService);
  });

  group('ListSearchViewModel Tests', () {
    test('fetchSearchStories fetches and sets stories correctly', () async {
      List<Story> mockStories = [
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
        )
      ];
      String datasource = "mockDatasource";
      String searchString = "mockSearchString";
      int page = 1;
      String category = "mockCategory";

      when(mockStoryService.fetchSearchStoryByCategory(searchString, datasource, page, category))
          .thenAnswer((_) async => mockStories);
      viewModel.stories[searchString]=mockStories;
      viewModel.changeSearchString(searchString);

      expect(viewModel.stories[searchString], mockStories);
      expect(viewModel.searchString, searchString);
    });

    test('fetchSearchStories handles errors gracefully', () async {
      String datasource = "mockDatasource";
      String searchString = "mockSearchString";
      int page = 1;
      String category = "mockCategory";

      when(mockStoryService.fetchSearchStoryByCategory(searchString, datasource, page, category))
          .thenThrow(Exception('Failed to fetch stories'));

      viewModel.changeSearchString(searchString);
      expect(viewModel.stories.isEmpty, true);
      expect(viewModel.searchString, searchString);
    });

    test('fetchSearchSourceBooks fetches and sets source books correctly', () async {
      SharedPreferences.setMockInitialValues({});
      List<String> mockSourceBooks = ['Source 1', 'Source 2'];
      when(mockStoryService.fetchListNameDataSource()).thenAnswer((_) async => mockSourceBooks);

      await viewModel.fetchSearchSourceBooks('searchString');

      expect(viewModel.sourceBooks, mockSourceBooks);
    });

    test('changeSourceBook updates sourceBook', () {
      viewModel.changeSourceBook('newSourceBook');
      expect(viewModel.sourceBook, 'newSourceBook');
    });

    test('changeListOrGrid updates listOn', () {
      viewModel.changeListOrGrid(false);
      expect(viewModel.listOn, false);
    });

    test('changeIndex updates indexSourceBook', () {
      viewModel.changeIndex(2);
      expect(viewModel.indexSourceBook, 2);
    });

    test('changeCategory updates category', () {
      viewModel.changeCategory('newCategory');
      expect(viewModel.category, 'newCategory');
    });

    test('changeSearchString updates searchString', () {
      viewModel.changeSearchString('newSearchString');
      expect(viewModel.searchString, 'newSearchString');
    });

    test('changepage updates page', () {
      viewModel.changepage(2);
      expect(viewModel.page, 2);
    });

    test('insertpage increments page', () {
      viewModel.changepage(1);
      viewModel.insertpage();
      expect(viewModel.page, 2);
    });

    test('changeIsLoading updates isLoading', () {
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

    test('checkSimilarity returns correct similarity result', () {
      List<String> list1 = ['Item 1', 'Item 2'];
      List<String> list2 = ['Item 2', 'Item 1'];
      expect(viewModel.checkSimilarity(list1, list2), true);

      List<String> list3 = ['Item 1', 'Item 3'];
      expect(viewModel.checkSimilarity(list1, list3), false);
    });
  });
}
