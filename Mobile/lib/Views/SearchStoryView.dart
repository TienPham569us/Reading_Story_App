import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/StoryService.dart';
import '../ViewModels/DetailStoryViewModel.dart';
import '../ViewModels/SearchStoryViewModel.dart';
import 'DetailStoryView.dart';
import '../Services/StoryService.dart';
import '../ViewModels/DetailStoryViewModel.dart';
import '../ViewModels/SearchStoryViewModel.dart';
import './DetailStoryView.dart';

class SearchScreen extends StatefulWidget {
  late String searchQuery;
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchStoryViewModel _searchStoryViewModel;
  late String searchQuery;
  @override
  void initState() {
    super.initState();
    _searchStoryViewModel = Provider.of<SearchStoryViewModel>(context, listen: false);

    //TODO: need to change datasource and page
    _searchStoryViewModel.fetchSearchStories(searchQuery, "Truyenfull",1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () => {StoryService().fetchListCategory("Truyen123")},
                    child: const Text('list categories'))
              ],
            ),
          ),
          Expanded(
            child:Consumer<SearchStoryViewModel>(
              builder: (context, storyListViewModel, _) {
                if (storyListViewModel.stories.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: storyListViewModel.stories.length,
                    itemBuilder: (context, index) {
                      final story = storyListViewModel.stories[index];
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

