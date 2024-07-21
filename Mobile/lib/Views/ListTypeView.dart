import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModels/DetailStoryViewModel.dart';
import '../ViewModels/ListTypeViewModel.dart';
import 'DetailStoryView.dart';

class ListTypeScreen extends StatefulWidget {
  final String source;
  final String type;
  const ListTypeScreen({super.key, required this.type, required this.source});

  @override
  State<ListTypeScreen> createState() => _ListTypeViewState();
}

class _ListTypeViewState extends State<ListTypeScreen> {
  late ListTypeViewModel _listTypeViewModel;

  @override
  void initState() {
    super.initState();
    _listTypeViewModel=Provider.of<ListTypeViewModel>(context,listen: false);
    _listTypeViewModel.fetchTypeStories(widget.source,widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit:BoxFit.cover
              )
          ),
        ),
        SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                   child: Image.asset('assets/images/Logo.png',height:60,)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 10
                      ),
                      color: Colors.black,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              "${widget.source} "
                                  "- ${widget.type.toUpperCase()} Books",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const ListOrGridbuttom(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: const Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: ListorGrid()
                      ),
                    ),
                  ),
                ],
              ),
            )
        )
      ],
    );
  }
}

class ListOrGridbuttom extends StatefulWidget {
  const ListOrGridbuttom({super.key});

  @override
  State<ListOrGridbuttom> createState() => _ListOrGridbuttomState();
}

class _ListOrGridbuttomState extends State<ListOrGridbuttom> {
  bool isListButtonPressed = true;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isListButtonPressed = true; // Đặt trạng thái nút danh sách được nhấn
                Provider.of<ListTypeViewModel>(context,listen: false).changeListOrGrid(true);
              });
            },
            child: Icon(
              Icons.list,
              color: isListButtonPressed ? Colors.red : Colors.white, // Thay đổi màu sắc dựa trên trạng thái của nút
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isListButtonPressed = false;
                Provider.of<ListTypeViewModel>(context,listen: false).changeListOrGrid(false);// Đặt trạng thái nút danh sách không được nhấn
              });
            },
            child: Icon(
              Icons.grid_on_sharp,
              color: isListButtonPressed ? Colors.white : Colors.red, // Thay đổi màu sắc dựa trên trạng thái của nút
            ),
          ),
        ),

      ],
    );
  }
}

class ListorGrid extends StatefulWidget {
  const ListorGrid({super.key});

  @override
  State<ListorGrid> createState() => _ListorGridState();
}

class _ListorGridState extends State<ListorGrid> {

  @override
  Widget build(BuildContext context) {
    return Provider.of<ListTypeViewModel>(context).listOn ?  ListViewBook(): const GridViewBook();
  }
}

class ListViewBook extends StatefulWidget {
  @override
  _ListViewBookState createState() => _ListViewBookState();
}

class _ListViewBookState extends State<ListViewBook> {
  final ScrollController controller = ScrollController();
  late ListTypeViewModel _listTypeViewModel;
  bool isLoadindMore = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _listTypeViewModel = Provider.of<ListTypeViewModel>(context, listen: false);
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        _listTypeViewModel.insertpage();
        _listTypeViewModel.fetchTypeStories(_listTypeViewModel.sourceBook, _listTypeViewModel.type);
        setState(() {
          isLoadindMore = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListTypeViewModel>(
      builder: (context, storyNotifier, _) {
        if (storyNotifier.stories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            controller: controller,
            itemCount: storyNotifier.stories.length,
            itemBuilder: (context, index) {
              final liststoryname = storyNotifier.stories.keys.elementAt(index);
              final liststorys = storyNotifier.stories[liststoryname]!;
              if (liststorys.isEmpty) {
                return Center(
                  child: Image.asset(
                    'assets/images/empty-box.png',
                    height: 120,
                    width: 110,
                  ),
                );
              } else {
                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: isLoadindMore ? liststorys.length + 1 : liststorys.length,
                      itemBuilder: (context, index) {
                        if (index < liststorys.length) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                    create: (context) => DetailStoryViewModel(),
                                    child: DetailStoryScreen(
                                      storyTitle: liststorys[index].title,
                                      datasource: storyNotifier.sourceBook,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.yellow, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Image(
                                          image: NetworkImage(liststorys[index].cover),
                                          height: 101,
                                          width: 84,
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            return Image.asset(
                                              'assets/images/default_image.png',
                                              height: 101,
                                              width: 84,
                                            );
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              liststorys[index].name,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 5.0),
                                              child: Text(
                                                'By: ${liststorys[index].author}',
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 5.0),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    for (int j = 0; j < (liststorys[index].categories!.length < 3 ? liststorys[index].categories!.length : 3); j++)
                                                      Container(
                                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius: BorderRadius.circular(20),
                                                          border: Border.all(color: Colors.white, width: 1),
                                                        ),
                                                        child: Text(
                                                          liststorys[index].categories![j].content,
                                                          style: const TextStyle(
                                                            fontSize: 7,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                );
              }
            },
          );
        }
      },
    );
  }
}


class GridViewBook extends StatefulWidget {
  const GridViewBook({super.key});

  @override
  _GridViewBookState createState() => _GridViewBookState();
}

class _GridViewBookState extends State<GridViewBook> {
  final ScrollController gridController = ScrollController();
  late ListTypeViewModel _listTypeViewModel;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    gridController.addListener(_onScroll);
    _listTypeViewModel = Provider.of<ListTypeViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    gridController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (gridController.position.pixels == gridController.position.maxScrollExtent) {
      _listTypeViewModel.insertpage();
      _listTypeViewModel.fetchTypeStories(_listTypeViewModel.sourceBook, _listTypeViewModel.type);
      setState(() {
        isLoadingMore = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListTypeViewModel>(
      builder: (context, storyNotifier, _) {
        if (storyNotifier.stories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            controller: gridController,
            itemCount: storyNotifier.stories.length,
            itemBuilder: (context, listIndex) {
              final listStoryName = storyNotifier.stories.keys.elementAt(listIndex);
              final listStories = storyNotifier.stories[listStoryName]!;
              if (listStories.isEmpty) {
                return Center(
                  child: Image.asset(
                    'assets/images/empty-box.png',
                    height: 120,
                    width: 110,
                  ),
                );
              } else {
                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: isLoadingMore ? listStories.length + 1 : listStories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns in grid view
                        mainAxisSpacing: 10, // Spacing between rows
                        childAspectRatio: 110 / 150, // Aspect ratio of each item
                      ),
                      itemBuilder: (context, gridIndex) {
                        if (gridIndex < listStories.length) {
                          final story = listStories[gridIndex];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                    create: (context) => DetailStoryViewModel(),
                                    child: DetailStoryScreen(
                                      storyTitle: story.title,
                                      datasource: storyNotifier.sourceBook,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white, width: 0.5),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.yellow, width: 2),
                                    ),
                                    child: Image(
                                      image: NetworkImage(story.cover),
                                      height: 120,
                                      width: 110,
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return Image.asset(
                                          'assets/images/default_image.png',
                                          height: 120,
                                          width: 110,
                                        );
                                      },
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 99,
                                        child: Text(
                                          story.name,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3.0),
                                        child: Text(
                                          'By: ${story.author}',
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 8,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                );
              }
            },
          );
        }
      },
    );
  }
}
