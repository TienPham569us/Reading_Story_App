import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_login/Models/DownloadHistory.dart';
import 'package:project_login/Models/ReadingHistory.dart';
import 'package:project_login/Services/LocalDatabase.dart';
import 'package:project_login/ViewModels/DownloadHistoryViewModel.dart';
import 'package:project_login/ViewModels/ReadingHistoryViewModel.dart';

// Create a mock for the LocalDatabase
class MockLocalDatabase extends Mock implements LocalDatabase {}

void main() {
  group('DownloadHistoryViewModel', () {
    late MockLocalDatabase mockLocalDatabase = MockLocalDatabase();
    late DownloadHistoryViewModel viewModel = DownloadHistoryViewModel();

    setUp(() {
      mockLocalDatabase = MockLocalDatabase();
      viewModel = DownloadHistoryViewModel();
      viewModel.localDatabase = mockLocalDatabase; // Inject the mock
    });

    test('fetchDownloadHistoryList fetches and sorts the list correctly', () async {
      // Arrange
      final mockDownloadHistoryList = [
        DownloadHistory(date: DateTime(2021, 6, 1).millisecondsSinceEpoch, title: 'Title 1', name: 'Name 1', chap: 1, cover: 'Cover 1', dataSource: 'Source 1',link: "example1.com.vn",format: "pdf"),
        DownloadHistory(date: DateTime(2021, 6, 2).millisecondsSinceEpoch, title: 'Title 2', name: 'Name 2', chap: 2, cover: 'Cover 2', dataSource: 'Source 2',link: "example2.com.vn",format: "txt"),
        DownloadHistory(date: DateTime(2021, 5, 1).millisecondsSinceEpoch, title: 'Title 3', name: 'Name 3', chap: 3, cover: 'Cover 3', dataSource: 'Source 3',link: "example3.com.vn",format: "html"),
      ];

      when(mockLocalDatabase.getDownloadHistoryList())
          .thenAnswer((_) async => mockDownloadHistoryList);

      // Act
      await viewModel.fetchDownloadList();

      // Assert
      expect(viewModel.downloadHistoryList, equals(mockDownloadHistoryList.toList()));
      verify(mockLocalDatabase.getDownloadHistoryList()).called(1);
    });

    test('fetchDownloadHistoryList handles empty list correctly', () async {
      // Arrange
      when(mockLocalDatabase.getDownloadHistoryList())
          .thenAnswer((_) async => []);

      // Act
      await viewModel.fetchDownloadList();

      // Assert
      expect(viewModel.downloadHistoryList, isEmpty);
      verify(mockLocalDatabase.getDownloadHistoryList()).called(1);
    });
  });
}
