import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_login/Models/ReadingHistory.dart';
import 'package:project_login/Views/Components/ReadingHistoryItem.dart';

void main() {
  testWidgets('ReadingHistoryItem displays correctly', (WidgetTester tester) async {
    // Create a ReadingHistory object for testing
    final ReadingHistory history = ReadingHistory(
      cover: 'https://example.com/cover.jpg',
      name: 'Sample Book',
      author: 'John Doe',
      chap: 1, title: '', date: DateTime.april, pageNumber: 1, dataSource: '', format: '',
    );

    // Build a MaterialApp with the ReadingHistoryItem inside
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ReadingHistoryItem(
          history,
              (history) {
            // Callback function for onTap event
          },
        ),
      ),
    ));

    // Expect to find the name, author, and chapter text
    expect(find.text('Sample Book'), findsOneWidget);
    expect(find.text('By: John Doe'), findsOneWidget);
    expect(find.text('Đã đọc đến chương: Chapter 1'), findsOneWidget);

    // Expect to find the cover image
    expect(find.byType(Image), findsOneWidget);
  });
}
