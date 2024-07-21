import 'package:flutter/material.dart';
import 'package:project_login/ViewModels/ListTypeViewModel.dart';
import 'package:project_login/Views/ListTypeView.dart';
import 'package:provider/provider.dart';

import '../Services/StoryService.dart';
import '../ViewModels/DetailStoryViewModel.dart';
import '../ViewModels/HomeStoryViewModel.dart';
import '../ViewModels/SearchViewModel.dart';
import 'DetailStoryView.dart';
import 'SearchScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeStoryViewModel _homeStoryViewModel;

  @override
  void initState() {
    super.initState();
    _homeStoryViewModel = Provider.of<HomeStoryViewModel>(context, listen: false);
    _homeStoryViewModel.fetchHomeSourceBooks();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        _homeStoryViewModel.fetchHomeSourceBooks();
        _homeStoryViewModel.changeIndex(0);
        _homeStoryViewModel.changeCategory("All");
        _homeStoryViewModel.changeIsLoading(true);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body:
        Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: IconButton(onPressed: (){
                   /* Navigator.push(
                        context,MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) => SearchViewModel(),
                          child: AudioPlayerPage(),
                        )
                    )
                    );*/
                  },
                      icon: Image.asset('assets/images/Logo.png',height:60,),
                ),),
                const Spacer(),
                IconButton(onPressed: () {
                  Navigator.push(
                      context,MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) => SearchViewModel(),
                          child: const SearchScreen(),
                        )
                    )
                  );
                },icon: const Icon(
                  Icons.search,color: Colors.white,),
                ),
                IconButton(onPressed: () {
                  _homeStoryViewModel.fetchHomeSourceBooks();
                  _homeStoryViewModel.changeIndex(0);
                  _homeStoryViewModel.changeCategory("All");
                  _homeStoryViewModel.changeIsLoading(true);
                  print('reload');
                },icon: const Icon(
                  Icons.refresh_outlined,color: Colors.white,),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10
              ),
              alignment: Alignment.centerLeft,
              child: Consumer<HomeStoryViewModel>(builder: (context,storyListViewModel,_){
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
                              Provider.of<HomeStoryViewModel>(context,listen: false).changeIndex(i);
                              storyListViewModel.changeSourceBook(storyListViewModel.sourceBooks[i]);
                              Provider.of<HomeStoryViewModel>(context,listen: false).fetchHomeStories(storyListViewModel.sourceBooks[i]);
                              storyListViewModel.changeCategory("All");
                              storyListViewModel.changeIsLoading(true);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Provider.of<HomeStoryViewModel>(context).indexSourceBook==i ? Colors.red : Colors.yellow, width: 2),
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
              }),
            ),
            Container(
              color: Colors.black,
              child: Row(
                children: [
                  if (Provider.of<HomeStoryViewModel>(context).sourceBooks.isEmpty)
                    const CircularProgressIndicator()
                  else
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "${Provider.of<HomeStoryViewModel>(context).sourceBook} "
                            "- ${Provider.of<HomeStoryViewModel>(context).screenType=='Home'?Provider.of<HomeStoryViewModel>(context).screenType:Provider.of<HomeStoryViewModel>(context).category}",
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
                Provider.of<HomeStoryViewModel>(context,listen: false).changeListOrGrid(true);
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
                Provider.of<HomeStoryViewModel>(context,listen: false).changeListOrGrid(false);// Đặt trạng thái nút danh sách không được nhấn
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
    return Provider.of<HomeStoryViewModel>(context).listOn
        ? const ListViewBook()
        : const GridViewBook();
  }
}

class ListViewBook extends StatelessWidget {
  const ListViewBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeStoryViewModel>(
      builder: (context, storyNotifier, _) {
        if (storyNotifier.stories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: storyNotifier.stories.length,
            itemBuilder: (context, index) {
              final liststoryname = storyNotifier.stories.keys.elementAt(index);
              final liststorys = storyNotifier.stories[liststoryname]!;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: liststoryname.toUpperCase(),
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
                              color: Colors.white, // Adjust color if needed
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: liststorys.length,
                    itemBuilder: (context, index) {
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
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => ListTypeViewModel(storyService: StoryService()),
                              child: ListTypeScreen(
                                type: liststoryname,
                                source: storyNotifier.sourceBook,
                              ),
                            ),
                          ),
                        );
                      },
                      label: const Text('More'),
                      icon: const Icon(Icons.playlist_add_sharp),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}




class GridViewBook extends StatelessWidget {
  const GridViewBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeStoryViewModel>(
      builder: (context, storyNotifier, _) {
        if (storyNotifier.stories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: storyNotifier.stories.length,
            itemBuilder: (context, index) {
              final listStoryName = storyNotifier.stories.keys.elementAt(index);
              final listStories = storyNotifier.stories[listStoryName]!;
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
                    itemCount: listStories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Số lượng cột trong grid view
                      mainAxisSpacing: 10, // Khoảng cách giữa các hàng
                      childAspectRatio: 110 / 150, // Tỷ lệ giữa chiều rộng và chiều cao của mỗi item
                    ),
                    itemBuilder: (context, gridIndex) {
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
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => ListTypeViewModel(storyService: StoryService()),
                              child: ListTypeScreen(
                                type: listStoryName,
                                source: storyNotifier.sourceBook,
                              ),
                            ),
                          ),
                        );
                      },
                      label: const Text('More'),
                      icon: const Icon(Icons.playlist_add_sharp),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}