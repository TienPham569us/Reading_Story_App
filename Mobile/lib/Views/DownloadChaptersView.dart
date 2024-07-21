import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:project_login/ViewModels/DownloadChaptersViewModel.dart';
import 'package:provider/provider.dart';
import '../ViewModels/DetailStoryViewModel.dart';

class DownloadChaptersScreen extends StatefulWidget {
  final String storyTitle;
  final String datasource;
  const DownloadChaptersScreen({super.key, required this.storyTitle,required this.datasource});

  @override
  _DownloadChaptersState createState() => _DownloadChaptersState();
}
late List<int> chapters =[];

class _DownloadChaptersState extends State<DownloadChaptersScreen>{
  late DetailStoryViewModel _detailStoryViewModel;
  late DownloadChaptersViewModel _downloadChaptersViewModel;
  //Define cho hiển thị mặc định của trang download
  final int buttonsPerRow = 3;
  late int _perPage  = 21; // Cài đặt giá trị mặc định
  int _currentPage = 1;
  late Map<int, bool> selectedButtons;
  bool _isCheckAll = false;
  //Các thông tin cần lưu vào cơ sở dữ liệu
  late String title;
  late String coverImage;
  late String nameStory;
  //Trạng thái trong lúc đang tải truyện
  bool _isLoading = false;
  //Load phân trang
  void _fetchChapters() {
    _detailStoryViewModel.fetchChapterPagination(widget.storyTitle, _currentPage, widget.datasource);
  }
  //Tải các chương cần tải vào thiết bị
  Future<bool> _downloadChapters (String storyTitle,String cover,String name, List<int> chapters,String fileType,String datasource) {
    setState(() {
      _isLoading = true;
    });
    return _downloadChaptersViewModel.downloadChaptersOfStory(storyTitle,cover,name, chapters, fileType, datasource);
  }
  @override
  void initState() {
    super.initState();
    _detailStoryViewModel = Provider.of<DetailStoryViewModel>(context, listen: false);
    _downloadChaptersViewModel = DownloadChaptersViewModel();
    _downloadChaptersViewModel.fetchListFileExtension();
    _detailStoryViewModel.fetchDetailsStory(widget.storyTitle, widget.datasource);
    _fetchChapters();
    //Tạo danh sách các button là các chap truyện
    selectedButtons = Map.fromIterable(
      List.generate(_perPage, (index) => index + 1),
      key: (item) => item,
      value: (item) => false,
    );

  }
  //Dialog show các tệp mở rộng muốn tải
  void _showDialogWithDropdown(BuildContext context) {
    String? selectedValue = _downloadChaptersViewModel.listFileExtension[0];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select an Option'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: _downloadChaptersViewModel.listFileExtension
                      .map((String format) => RadioListTile<String>(
                    title: Text(format),
                    value: format,
                    groupValue: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  ))
                      .toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: ()  async {
                Navigator.of(context).pop();
                if(chapters.isEmpty){
                  showErrorDialogDownload();
                }
                else{
                  Logger logger = Logger();
                  logger.i("Chapters is: $chapters");
                  bool result = await _downloadChapters(title,coverImage,nameStory, chapters, selectedValue!, widget.datasource);
                  if(result){
                    showMyDialog();
                    resetState(false);
                  }
                  else{
                    showErrorDialog();
                  }
                  setState(() {
                    _isLoading = false;
                  });
                }
                print('Selected value: $selectedValue');
              },
            ),
          ],
        );
      },
    );
  }
  //Dialog show tải truyện thành công
  void showMyDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text(
              'Tải truyện thành công'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  //Dialog show chưa chọn chương tải truyện
  void showErrorDialogDownload() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text(
              'Chọn chương để tải truyện'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  //Dialog show tải truyện lỗi
  void showErrorDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text(
              'Tải truyện Thất bại'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  //Cập nhật trạng thái các truyện khi tải xong (bỏ chọn các truyện)
  void resetState(bool state)
  {
    selectedButtons = Map.fromIterable(
      List.generate(_perPage, (index) => index + 1),
      key: (item) => item,
      value: (item) => state,
    );
    chapters.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.black,
          title:const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Center(
              child: Text("Chọn chương để tải về",style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              ),
            ),
          ) ,
        ),
        body: Consumer<DetailStoryViewModel>(
            builder: (context, storyDetailViewModel,_) {
              if (storyDetailViewModel.chapterPagination == null || storyDetailViewModel.story==null || _isLoading == true) {
                return const Center(child: CircularProgressIndicator());
              }
              final chapter = storyDetailViewModel.chapterPagination!;
              final story = storyDetailViewModel.story!;
              title = story.title;
              coverImage = story.cover;
              nameStory = story.name;
              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/background_home.png',
                          ),
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                  LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints){
                        double screenWidth = constraints.maxWidth;
                        double screenHeight = constraints.maxHeight;

                        Logger logger = Logger();
                        logger.i("Screen Width: $screenWidth");
                        logger.i("Screen Height: $screenHeight");

                        // Tính toán vị trí của từng widget
                        double widget1Top = screenHeight * 0.06;
                        double widget1Bottom = screenHeight * 0.1;
                        double widget1Left = screenWidth * 0.05;
                        double widget1Right = screenWidth * 0.05;

                        double widget2Top = screenHeight * 0.7;
                        double widget2Bottom = screenHeight * 0.015;
                        double widget2Left = screenWidth * 0.03;
                        double widget2Right = screenWidth * 0.033;

                        //Tính toán độ rộng của button
                        double widthButton = screenWidth * 0.1;
                        double heightButton = screenHeight * 0.1;

                        return Stack(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'Tổng số chương: ${chapter.maxChapter}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // top: 50.0,
                                // left: 20.0,
                                // right: 20.0,
                                // bottom: 50,
                                top: widget1Top,
                                left: widget1Left,
                                right: widget1Right,
                                bottom: widget1Bottom,
                                child:  GridView.builder(
                                    itemCount: _currentPage * _perPage >= chapter.maxChapter ? chapter.maxChapter - (_currentPage-1) * _perPage : _perPage,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: buttonsPerRow,
                                      mainAxisSpacing: 20.0,
                                      crossAxisSpacing: 20.0,
                                      childAspectRatio: 100 / 40,
                                    ),
                                    itemBuilder: (BuildContext,int index){
                                      int chapterNumber = _perPage * (_currentPage - 1) + index + 1;
                                      return ElevatedButton(
                                        onPressed: (){
                                          setState(() {
                                            selectedButtons[index+1] = !selectedButtons[index+1]!;
                                          });
                                          if(selectedButtons[index+1] == true){
                                            chapters.add(chapterNumber);
                                          }
                                          else{
                                            chapters.removeAt(chapterNumber);
                                          }
                                        },
                                        child: Text(
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            '$chapterNumber'
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(200, 50),
                                          backgroundColor: selectedButtons[index+1]! && chapters.contains(chapterNumber) ? Colors.yellow : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),

                                        ),

                                      );
                                    }
                                ),
                              ),
                              Positioned(
                                // left: 13,
                                // bottom: 10,
                                // right: 20,
                                // top: 540,
                                left: widget2Left,
                                bottom: widget2Bottom,
                                right: widget2Right,
                                top: widget2Top,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: _currentPage == 1 ? Colors.grey : Colors.white,),
                                      onPressed: _currentPage == 1
                                          ? null
                                          : () {
                                        setState(() {
                                          _currentPage--;
                                        });
                                      },
                                    ),
                                    Text(
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        'Page $_currentPage'
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward,
                                        color: _currentPage * _perPage >= chapter.maxChapter ? Colors.grey : Colors.white,),
                                      onPressed: _currentPage * _perPage >= chapter.maxChapter
                                          ? null
                                          : () {
                                        setState(() {
                                          _currentPage++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: BottomAppBar(
                                    child: Row(
                                      children: <Widget>[
                                        Checkbox(
                                            value: _isCheckAll,
                                            onChanged: (bool ?value){
                                              setState(() {
                                                _isCheckAll = value!;
                                                if(_isCheckAll){
                                                  resetState(true);
                                                }
                                                else{
                                                  resetState(false);
                                                }
                                              });
                                            }
                                        ),
                                        const Text(
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            'Chọn tất cả'
                                        ),
                                        const SizedBox(
                                          width: 40,
                                        ),
                                        const VerticalDivider(
                                          color: Colors.black ,
                                          thickness: 2,
                                          width: 20,
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        IconButton(
                                            onPressed: (){
                                              _showDialogWithDropdown(context);
                                            },
                                            icon: const Icon(Icons.download)
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              _showDialogWithDropdown(context);
                                            },
                                            child: const Text(
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                'Tải xuống'
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                              )
                            ]
                        );
                      }
                  ),
                ],
              );
            }
        )
    );
  }
}