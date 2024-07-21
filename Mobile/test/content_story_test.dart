import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:project_login/Constants.dart';
import 'package:project_login/Models/ChapterPagination.dart';
import 'package:project_login/Models/ReadingHistory.dart';
import 'package:project_login/Services/DownloadService.dart';
import 'package:project_login/Services/LocalDatabase.dart';
import 'package:project_login/Services/StoryService.dart';
import 'package:project_login/ViewModels/ContentStoryViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockStoryService extends Mock implements StoryService {}
class MockLocalDatabase extends Mock implements LocalDatabase {}
class MockReadingHistory extends Mock implements ReadingHistory {}
class MockNotifier extends Mock implements ContentStoryViewModel {}
class MockLogger extends Mock implements Logger {}
class MockDownloadService extends Mock implements DownloadService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ContentStoryViewModel', () {
    late MockSharedPreferences mockSharedPreferences;
    late ContentStoryViewModel viewModel;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      viewModel = ContentStoryViewModel();
    });

    test('fetchContentDisplay successfully fetches and sets content display settings', () async {
      // Set up the mock responses
      when(mockSharedPreferences.getDouble(TEXT_SIZE_KEY)).thenReturn(16.0);
      when(mockSharedPreferences.getDouble(LINE_SPACING_KEY)).thenReturn(1.5);
      when(mockSharedPreferences.getInt(TEXT_COLOR_KEY)).thenReturn(0xFF000000);
      when(mockSharedPreferences.getInt(BACKGROUND_COLOR_KEY)).thenReturn(0xFFFFFFFF);
      when(mockSharedPreferences.getString(FONT_FAMILY_KEY)).thenReturn('Roboto');
      when(mockSharedPreferences.getInt(IS_TESTING_KEY)).thenReturn(1);

      // Inject the mock SharedPreferences into the viewModel
      viewModel.setPreferences(mockSharedPreferences);  // Ensure you have this method

      await viewModel.fetchContentDisplay();

      // Verify that the contentDisplay object is set correctly
      expect(viewModel.contentDisplay.textSize, 16.0);
      expect(viewModel.contentDisplay.lineSpacing, 1.5);
      expect(viewModel.contentDisplay.textColor, 0xFF000000);
      expect(viewModel.contentDisplay.backgroundColor, 0xFFFFFFFF);
      expect(viewModel.contentDisplay.fontFamily, 'Roboto');
    });

    test('fetchContentDisplay handles missing preferences gracefully', () async {
      // Set up the mock responses to return null for all preferences
      when(mockSharedPreferences.getDouble(TEXT_SIZE_KEY)).thenAnswer((_) => null);
      when(mockSharedPreferences.getInt(LINE_SPACING_KEY)).thenAnswer((_) => null);
      when(mockSharedPreferences.getString(TEXT_COLOR_KEY)).thenAnswer((_) => null);
      when(mockSharedPreferences.getString(BACKGROUND_COLOR_KEY)).thenAnswer((_) => null);
      when(mockSharedPreferences.getString(FONT_FAMILY_KEY)).thenReturn(null);
      when(mockSharedPreferences.getInt(IS_TESTING_KEY)).thenReturn(1);

      viewModel.setPreferences(mockSharedPreferences);

      await viewModel.fetchContentDisplay();

      // Verify that the contentDisplay object is set to default values
      expect(viewModel.contentDisplay.textSize, DEFAULT_TEXT_SZIE);
      expect(viewModel.contentDisplay.lineSpacing, DEFAULT_LINE_SPACING);
      expect(viewModel.contentDisplay.textColor, DEFAULT_TEXT_COLOR);
      expect(viewModel.contentDisplay.backgroundColor, DEFAULT_BACKGROUND_COLOR);
      expect(viewModel.contentDisplay.fontFamily, DEFAULT_FONT_FAMILY);
    });
  });
}