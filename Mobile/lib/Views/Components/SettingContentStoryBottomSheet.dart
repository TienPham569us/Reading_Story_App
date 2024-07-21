import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../../Constants.dart';
import '../../ViewModels/ContentStoryViewModel.dart';

class SettingContentStoryBottomSheet extends StatefulWidget {
  final ContentStoryViewModel contentStoryViewModel;
  final Function(double) onTextSizeChanged;
  final Function(double) onLineSpacingChanged;
  final Function(String) onFontFamilyChanged;
  final Function(int) onTextColorChanged;
  final Function(int) onBackgroundChanged;
  final Function(String) onSourceChange;

  const SettingContentStoryBottomSheet(
      {required this.contentStoryViewModel,
      required this.onTextSizeChanged,
      required this.onLineSpacingChanged,
      required this.onFontFamilyChanged,
      required this.onTextColorChanged,
      required this.onBackgroundChanged,
      required this.onSourceChange,
      super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingContentStoryBottomSheetState();
  }
}

class _SettingContentStoryBottomSheetState extends State<SettingContentStoryBottomSheet> {

  late String dropdownValueFont;
  late String dropdownValueSource;

  @override
  void initState() {
    super.initState();
    dropdownValueFont = widget.contentStoryViewModel.contentDisplay.fontFamily;
    dropdownValueSource = widget.contentStoryViewModel.currentSource;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    const int textSizeChange = 2;
    const double lineSpacingChange = 0.5;

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    const Text(
                      "Nguồn truyện",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: DropdownButton<String>(
                            value: dropdownValueSource,
                            onChanged: (String? newValue) {
                              setState(() {
                                // change source
                                dropdownValueSource = newValue!;
                                widget.onSourceChange(dropdownValueSource);
                                Navigator.pop(context);
                              });
                            },
                            items: widget.contentStoryViewModel.sourceBooks
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                            isExpanded: true,
                            menuMaxHeight: screenHeight / 4,
                            underline: Container(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                child: Text(
                  "Size",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(204),
                        topRight: Radius.circular(204),
                        bottomLeft: Radius.circular(204),
                        bottomRight: Radius.circular(204),
                      ),
                      color: Colors.white),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        // decrease text size
                        if (widget.contentStoryViewModel.contentDisplay.textSize - textSizeChange >= MIN_TEXT_SIZE) {
                          double newTextSize = widget.contentStoryViewModel.contentDisplay.textSize - textSizeChange;
                          widget.contentStoryViewModel.contentDisplay.textSize = newTextSize;
                          widget.onTextSizeChanged(newTextSize);
                        }
                      });
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: ImageIcon(AssetImage(
                          'assets/images/text_size_decrease_icon.png')),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    widget.contentStoryViewModel.contentDisplay.textSize.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(204),
                        topRight: Radius.circular(204),
                        bottomLeft: Radius.circular(204),
                        bottomRight: Radius.circular(204),
                      ),
                      color: Colors.white),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        // increase text size
                        if (widget.contentStoryViewModel.contentDisplay.textSize + textSizeChange <= MAX_TEXT_SIZE) {
                          double newTextSize = widget.contentStoryViewModel.contentDisplay.textSize + textSizeChange;
                          widget.contentStoryViewModel.contentDisplay.textSize = newTextSize;
                          widget.onTextSizeChanged(newTextSize);
                        }
                      });
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: ImageIcon(AssetImage(
                          'assets/images/text_size_increase_icon.png')),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(204),
                        topRight: Radius.circular(204),
                        bottomLeft: Radius.circular(204),
                        bottomRight: Radius.circular(204),
                      ),
                      color: Colors.white),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        // decrease line space
                        if (widget.contentStoryViewModel.contentDisplay.lineSpacing - lineSpacingChange >= MIN_LINE_SPACING) {
                          double newlineSpacing = widget.contentStoryViewModel.contentDisplay.lineSpacing - lineSpacingChange;
                          widget.contentStoryViewModel.contentDisplay.lineSpacing = newlineSpacing;
                          widget.onLineSpacingChanged(newlineSpacing);
                        }
                      });
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: ImageIcon(AssetImage(
                          'assets/images/line_spacing_decrease_icon.png')),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    widget.contentStoryViewModel.contentDisplay.lineSpacing.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(204),
                        topRight: Radius.circular(204),
                        bottomLeft: Radius.circular(204),
                        bottomRight: Radius.circular(204),
                      ),
                      color: Colors.white),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        // increase line space
                        if (widget.contentStoryViewModel.contentDisplay.lineSpacing + lineSpacingChange <= MAX_LINE_SPACING) {
                          double newlineSpacing = widget.contentStoryViewModel.contentDisplay.lineSpacing + lineSpacingChange;
                          widget.contentStoryViewModel.contentDisplay.lineSpacing = newlineSpacing;
                          widget.onLineSpacingChanged(newlineSpacing);
                        }
                      });
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: ImageIcon(AssetImage(
                          'assets/images/line_spacing_increase_icon.png')),
                    ),
                  ),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Font",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.white),
              width: screenWidth - 50,
              child: DropdownButton<String>(
                value: dropdownValueFont,
                onChanged: (String? newValue) {
                  setState(() {
                    // change font family
                    dropdownValueFont = newValue!;
                    widget.onFontFamilyChanged(dropdownValueFont);
                  });
                },
                items: widget.contentStoryViewModel.fontNames
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(value),
                    ),
                  );
                }).toList(),
                isExpanded: true,
                menuMaxHeight: screenHeight / 4,
                underline: Container(),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                  child: Row(
                    children: [
                      const Text(
                        "Màu chữ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            _showColorPickerDialog(widget.onTextColorChanged);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            backgroundColor: Colors.white,
                          ),
                          child: const Text('Chọn'),
                        ),
                      )
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      const Text(
                        "Màu nền",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            _showColorPickerDialog(widget.onBackgroundChanged);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            backgroundColor: Colors.white,
                          ),
                          child: const Text('Chọn'),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  // open color picker dialog to choose color
  void _showColorPickerDialog(Function(int) onConfirmClicked) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn màu'),
          content: SingleChildScrollView(
            child: MaterialColorPicker(
              onColorChange: (Color color) {
                onConfirmClicked(color.value);
              },
              // selectedColor: _selectedColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
