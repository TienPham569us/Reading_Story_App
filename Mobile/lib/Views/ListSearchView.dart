import 'package:flutter/material.dart';
import 'package:project_login/ViewModels/ListSearchViewModel.dart';
import 'package:project_login/Views/ChooseCategoryView.dart';
import 'package:provider/provider.dart';

import '../ViewModels/ChooseCategoryViewModel.dart';
import '../ViewModels/DetailStoryViewModel.dart';
import 'DetailStoryView.dart';

class ListSearchScreen extends StatefulWidget {
  final String searchString;
  const ListSearchScreen({super.key,required this.searchString});
  @override
  State<ListSearchScreen> createState() => _ListSearchScreenState();
}

class _ListSearchScreenState extends State<ListSearchScreen> {
  late ListSearchViewModel _listSearchViewModel;

  @override
  void initState() {
    super.initState();
    _listSearchViewModel=Provider.of<ListSearchViewModel>(context,listen: false);
    _listSearchViewModel.fetchSearchSourceBooks(widget.searchString);
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
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(onPressed: (){

                      },
                        icon: Image.asset('assets/images/Logo.png',height:60,),
                      ),),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(right: 3),
                      child: IconButton(onPressed: () async{
                        Navigator.pop(context);
                      },
                          icon: const Icon(Icons.search,color: Colors.white,)
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 3),
                      child: IconButton(onPressed: () async{
                        final choisecategory=await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => ChoiseCategoryViewModel(),
                                  child: ChooseCategoryScreen(datasource: _listSearchViewModel.sourceBook, category: _listSearchViewModel.category,),
                                )
                            )
                        );
                        _listSearchViewModel.changeCategory(choisecategory);
                        _listSearchViewModel.changepage(1);
                        _listSearchViewModel.fetchSearchStories(_listSearchViewModel.sourceBook);
                      },
                          icon: const Icon(Icons.category,color: Colors.white,)
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(
                          color: Colors.white,
                          width: 2.0
                      )
                      )
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10
                  ),
                  alignment: Alignment.centerLeft,
                  child: const ListSourceBook(),
                ),
                Container(
                  color: Colors.black,
                  child: Row(
                    children: [
                      if (Provider.of<ListSearchViewModel>(context).sourceBooks.isEmpty)
                        const CircularProgressIndicator()
                      else
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "${Provider.of<ListSearchViewModel>(context).sourceBook} "
                                "- ${_listSearchViewModel.category}",
                            style: const TextStyle(
                              fontSize: 18,
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
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: ' Search: ',
                          style: TextStyle(
                            color: Colors.white, // Adjust color if needed
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: "\"${widget.searchString}\"",
                          style: const TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 25
                          ),
                        ),
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
          ),
        )
      ],
    );
  }
}

class ListSourceBook extends StatelessWidget {
  const ListSourceBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ListSearchViewModel>(builder: (context,storyListViewModel,_){
      if (storyListViewModel.sourceBooks.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < storyListViewModel.sourceBooks.length; i++)
                GestureDetector(
                  onTap: storyListViewModel.isLoading?null:() {
                    storyListViewModel.changeCategory("All");
                    storyListViewModel.changepage(1);
                    Provider.of<ListSearchViewModel>(context,listen: false).changeIndex(i);
                    storyListViewModel.changeSourceBook(storyListViewModel.sourceBooks[i]);
                    storyListViewModel.fetchSearchStories(storyListViewModel.sourceBooks[i]);
                    storyListViewModel.changeIsLoading(true);
                    storyListViewModel.stories.clear();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Provider.of<ListSearchViewModel>(context).indexSourceBook==i ? Colors.red : Colors.yellow, width: 2),
                    ),
                    child: Text(
                      storyListViewModel.sourceBooks[i],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
            ],
          ),
        );
      }
    });
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
                Provider.of<ListSearchViewModel>(context,listen: false).changeListOrGrid(true);
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
                Provider.of<ListSearchViewModel>(context,listen: false).changeListOrGrid(false);// Đặt trạng thái nút danh sách không được nhấn
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
    return Provider.of<ListSearchViewModel>(context).listOn ?  ListViewBook(): const GridViewBook();
  }
}

class ListViewBook extends StatefulWidget {
  @override
  _ListViewBookState createState() => _ListViewBookState();
}

class _ListViewBookState extends State<ListViewBook> {
  final ScrollController controller = ScrollController();
  late ListSearchViewModel _listSearchViewModel;
  bool isLoadindMore = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _listSearchViewModel = Provider.of<ListSearchViewModel>(context, listen: false);
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        _listSearchViewModel.insertpage();
        _listSearchViewModel.fetchSearchStories(_listSearchViewModel.sourceBook);
        setState(() {
          isLoadindMore = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListSearchViewModel>(
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
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                liststorys[index].name,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 5.0),
                                              child: SizedBox(
                                                width: double.infinity,
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
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 5.0),
                                              child: Wrap(
                                                spacing: 6.0, // khoảng cách ngang giữa các phần tử
                                                runSpacing: 4.0, // khoảng cách dọc giữa các dòng
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
                                            )
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
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
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
  late ListSearchViewModel _listSearchViewModel;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    gridController.addListener(_onScroll);
    _listSearchViewModel = Provider.of<ListSearchViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    gridController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (gridController.position.pixels == gridController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      _listSearchViewModel.insertpage();
      _listSearchViewModel.fetchSearchStories(_listSearchViewModel.sourceBook)!.then((_) {
        setState(() {
          isLoadingMore = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListSearchViewModel>(
      builder: (context, storyNotifier, _) {
        if (storyNotifier.stories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            controller: gridController,
            itemCount: storyNotifier.stories.length,
            itemBuilder: (context, index) {
              final listStoryName = storyNotifier.stories.keys.elementAt(index);
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
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: listStoryName.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            const TextSpan(
                              text: ' List Story',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: listStories.length + (isLoadingMore ? 1 : 0),
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

