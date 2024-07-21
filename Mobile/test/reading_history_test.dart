import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_login/Models/ReadingHistory.dart';
import 'package:project_login/Services/LocalDatabase.dart';
import 'package:project_login/ViewModels/ReadingHistoryViewModel.dart';

// Create a mock for the LocalDatabase
class MockLocalDatabase extends Mock implements LocalDatabase {}

void main() {
  group('ReadingHistoryViewModel', () {
    late MockLocalDatabase mockLocalDatabase = MockLocalDatabase();
    late ReadingHistoryViewModel viewModel = ReadingHistoryViewModel();

    setUp(() {
      mockLocalDatabase = MockLocalDatabase();
      viewModel = ReadingHistoryViewModel();
      viewModel.localDatabase = mockLocalDatabase; // Inject the mock
    });

    test('fetchReadingHistoryList fetches and sorts the list correctly', () async {
      // Arrange
      final mockReadingHistoryList = [
        ReadingHistory(date: DateTime(2021, 6, 1).millisecondsSinceEpoch, title: 'Title 1', name: 'Name 1', chap: 1, pageNumber: 1, author: 'Author 1', cover: 'Cover 1', dataSource: 'Source 1', format: ''),
        ReadingHistory(date: DateTime(2021, 6, 2).millisecondsSinceEpoch, title: 'Title 2', name: 'Name 2', chap: 2, pageNumber: 2, author: 'Author 2', cover: 'Cover 2', dataSource: 'Source 2', format: ''),
        ReadingHistory(date: DateTime(2021, 5, 1).millisecondsSinceEpoch, title: 'Title 3', name: 'Name 3', chap: 3, pageNumber: 3, author: 'Author 3', cover: 'Cover 3', dataSource: 'Source 3', format: ''),
      ];

      when(mockLocalDatabase.getReadingHistoryList())
          .thenAnswer((_) async => mockReadingHistoryList);

      // Act
      await viewModel.fetchReadingHistoryList();

      // Assert
      expect(viewModel.readingHistoryList, equals(mockReadingHistoryList.toList()));
      verify(mockLocalDatabase.getReadingHistoryList()).called(1);
    });

    test('fetchReadingHistoryList handles empty list correctly', () async {
      // Arrange
      when(mockLocalDatabase.getReadingHistoryList())
          .thenAnswer((_) async => []);

      // Act
      await viewModel.fetchReadingHistoryList();

      // Assert
      expect(viewModel.readingHistoryList, isEmpty);
      verify(mockLocalDatabase.getReadingHistoryList()).called(1);
    });
  });
}
