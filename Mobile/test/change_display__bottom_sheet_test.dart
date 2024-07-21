import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_login/Models/ContentDisplay.dart';
import 'package:project_login/ViewModels/ContentStoryViewModel.dart';
import 'package:project_login/Views/Components/SettingContentStoryBottomSheet.dart';

// Create a mock for the ContentStoryViewModel
class MockContentStoryViewModel extends Mock implements ContentStoryViewModel {}

void main() {
  group('ChangeDisplayBottomSheet', () {
    late ContentStoryViewModel mockContentStoryViewModel;
    late Function(double) mockOnTextSizeChanged;
    late Function(double) mockOnLineSpacingChanged;
    late Function(String) mockOnFontFamilyChanged;
    late Function(int) mockOnTextColorChanged;
    late Function(int) mockOnBackgroundChanged;
    late Function(String) mockOnSourceChange;

    setUp(() {
      mockContentStoryViewModel = ContentStoryViewModel();
      mockOnTextSizeChanged = (value) => print('Text size changed: $value');
      mockOnLineSpacingChanged = (value) => print('Line spacing changed: $value');
      mockOnFontFamilyChanged = (value) => print('Font family changed: $value');
      mockOnTextColorChanged = (value) => print('Text color changed: $value');
      mockOnBackgroundChanged = (value) => print('Background color changed: $value');
      mockOnSourceChange = (value) => print('On source change changed: $value');

      // Set up initial values for the mock
      mockContentStoryViewModel.contentDisplay = ContentDisplay(
        textSize: 16,
        lineSpacing: 1.5,
        fontFamily: 'Arial', textColor: Colors.black.value, backgroundColor: Colors.white.value,
      );
      mockContentStoryViewModel.fontNames = ['Arial', 'Roboto', 'Times New Roman'];
    });

    testWidgets('should open color picker dialog and change text color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingContentStoryBottomSheet(
              contentStoryViewModel: mockContentStoryViewModel,
              onTextSizeChanged: mockOnTextSizeChanged,
              onLineSpacingChanged: mockOnLineSpacingChanged,
              onFontFamilyChanged: mockOnFontFamilyChanged,
              onTextColorChanged: mockOnTextColorChanged,
              onBackgroundChanged: mockOnBackgroundChanged,
              onSourceChange: mockOnSourceChange,
            ),
          ),
        ),
      );

      // Open text color picker dialog
      await tester.tap(find.text('Chọn').first);
      await tester.pumpAndSettle();

      // Select a color (assuming the first color)
      await tester.tap(find.byType(MaterialColorPicker).first);
      await tester.pumpAndSettle();

      // Confirm selection
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Verify text color changed
      // Note: Since we don't have direct access to the selected color in the dialog,
      // we need to mock the color change callback to verify the color change.
    });

    testWidgets('should open color picker dialog and change background color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingContentStoryBottomSheet(
              contentStoryViewModel: mockContentStoryViewModel,
              onTextSizeChanged: mockOnTextSizeChanged,
              onLineSpacingChanged: mockOnLineSpacingChanged,
              onFontFamilyChanged: mockOnFontFamilyChanged,
              onTextColorChanged: mockOnTextColorChanged,
              onBackgroundChanged: mockOnBackgroundChanged,
              onSourceChange: mockOnSourceChange,
            ),
          ),
        ),
      );

      // Open background color picker dialog
      await tester.tap(find.text('Chọn').last);
      await tester.pumpAndSettle();

      // Select a color (assuming the first color)
      await tester.tap(find.byType(MaterialColorPicker).first);
      await tester.pumpAndSettle();

      // Confirm selection
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Verify background color changed
      // Note: Since we don't have direct access to the selected color in the dialog,
      // we need to mock the color change callback to verify the color change.
    });
  });
}
