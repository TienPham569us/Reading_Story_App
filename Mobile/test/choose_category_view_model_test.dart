import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_login/Models/Category.dart';
import 'package:project_login/Services/StoryService.dart';
import 'package:project_login/ViewModels/ChooseCategoryViewModel.dart';

class MockStoryService extends Mock implements StoryService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChooseCategoryViewModel', () {
    late MockStoryService mockStoryService;
    late ChoiseCategoryViewModel viewModel;

    setUp(() {
      mockStoryService = MockStoryService();
      viewModel = ChoiseCategoryViewModel(storyService: mockStoryService);
    });

    test('fetchCategories successfully fetches and sets categories', () async {
      // Set up the mock responses
      String datasource = "mockDatasource";
      List<Category> mockCategories = [
        Category(content: 'Category 1', url: 'http://example.com/1'),
        Category(content: 'Category 2', url: 'http://example.com/2'),
      ];
      when(mockStoryService.fetchListCategory(datasource))
          .thenAnswer((_) async => mockCategories);

      await viewModel.fetchCategories(datasource);

      // Verify that the categories list is set correctly
      expect(viewModel.categories, mockCategories);
    });

    test('fetchCategories handles errors gracefully', () async {
      // Set up the mock to throw an exception
      String datasource = "mockDatasource";
      when(mockStoryService.fetchListCategory(datasource))
          .thenThrow(Exception('Failed to fetch categories'));

      await viewModel.fetchCategories(datasource);

      // Verify that the categories list remains null
      expect(viewModel.categories, null);
    });

    test('changeCategory successfully changes the selected category', () async {
      String newCategory = 'New Category';

      viewModel.changeCategory(newCategory);

      // Verify that the choisedCategory is set correctly
      expect(viewModel.choisedCategory, newCategory);
    });
  });
}
