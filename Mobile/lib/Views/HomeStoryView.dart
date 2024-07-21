import 'package:flutter/material.dart';
import 'package:project_login/Services/StoryService.dart';
import 'package:project_login/ViewModels/HomeStoryViewModel.dart';
import 'package:provider/provider.dart';
import '../ViewModels/DetailStoryViewModel.dart';
import 'DetailStoryView.dart';
import '../ViewModels/DetailStoryViewModel.dart';
import './DetailStoryView.dart';
import 'SearchStoryView.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeStoryViewModel _homeStoryViewModel;

  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _homeStoryViewModel = Provider.of<HomeStoryViewModel>(context, listen: false);

    //TODO: need to change
    _homeStoryViewModel.fetchHomeStories("Truyenfull");
  }


  void navigateToSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(),
        // builder: (context) => SearchScreen(searchQuery: _searchController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stories'),
      ),
      body: Column(
          children: [
      Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 16.0),
          ElevatedButton(
            onPressed: navigateToSearchScreen,
            child: Text('Search'),
          ),
          ElevatedButton(onPressed: () => {new StoryService().fetchListNameDataSource()}, child: Text('source names'))
        ],
      ),
    ),
    Expanded(
    child:Consumer<HomeStoryViewModel>(
        builder: (context, storyListViewModel, _) {
          if (storyListViewModel.stories.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: storyListViewModel.stories.length,
              itemBuilder: (context, index) {
                final category = storyListViewModel.stories.keys.elementAt(index);
                final categoryStories = storyListViewModel.stories[category]!;
                return Column(
                  children: [
                    Text('$category List Stories'),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: categoryStories.length,
                      itemBuilder: (context, index) {
                        final story = categoryStories[index];
                        return ListTile(
                          title: Text(story.name),
                          subtitle: Text(story.link),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => DetailStoryViewModel(),
                                  child: DetailStoryScreen(storyTitle: story.title, datasource: "Truyenfull",),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    ),
          ],
    ),
    );
  }

}
