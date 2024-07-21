import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_login/Models/Story.dart';
import 'package:project_login/Services/StoryService.dart';
import 'package:project_login/ViewModels/ListTypeViewModel.dart';

// Mock class for StoryService
class MockStoryService extends Mock implements StoryService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ListTypeViewModel viewModel;
  late MockStoryService mockStoryService;

  setUp(() {
    mockStoryService = MockStoryService();
    viewModel = ListTypeViewModel(storyService: mockStoryService);
  });

  group('ListTypeViewModel Tests', () {
    test('fetchTypeStories fetches and sets stories correctly', () async {
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
          categories: [],
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
          categories: [],
          detail: 'Detail 2',
        )
      ];
      String sourceBook = "mockSourceBook";
      String type = "mockType";

      when(mockStoryService.fetchListStoryByType(type, 1, sourceBook))
          .thenAnswer((_) async => mockStories);

      await viewModel.fetchTypeStories(sourceBook, type);

      expect(viewModel.stories.isNotEmpty, true);
      expect(viewModel.stories[type]!.length, mockStories.length);
    });

    test('fetchTypeStories handles errors gracefully', () async {
      String sourceBook = "mockSourceBook";
      String type = "mockType";

      when(mockStoryService.fetchListStoryByType(type, 1, sourceBook))
          .thenThrow(Exception('Failed to fetch stories'));

      await viewModel.fetchTypeStories(sourceBook, type);

      expect(viewModel.stories.isEmpty, true);
    });

    test('changeSourceBook updates sourceBook', () {
      viewModel.changeSourceBook('newSourceBook');
      expect(viewModel.sourceBook, 'newSourceBook');
    });

    test('changeListOrGrid updates listOn', () {
      viewModel.changeListOrGrid(false);
      expect(viewModel.listOn, false);
    });

    test('changeType updates type', () {
      viewModel.changeType('newType');
      expect(viewModel.type, 'newType');
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
  });
}
