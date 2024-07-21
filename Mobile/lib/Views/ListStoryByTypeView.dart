import 'package:flutter/material.dart';
import 'package:project_login/ViewModels/DetailStoryViewModel.dart';
import 'package:project_login/ViewModels/ListStoryByTypeViewModel.dart';
import 'package:project_login/Views/DetailStoryView.dart';
import 'package:provider/provider.dart';

class ListStoryByTypeScreen extends StatefulWidget {
  final String listStoryType;
  final String datasource;

  const ListStoryByTypeScreen({super.key, required this.listStoryType, required this.datasource});

  @override
  _ListStoryByTypeScreenState createState() => _ListStoryByTypeScreenState();
}

class _ListStoryByTypeScreenState extends State<ListStoryByTypeScreen> {
  late ListStoryByTypeViewModel _listStoryByTypeViewModel;

  @override
  void initState() {
    super.initState();

    _listStoryByTypeViewModel = Provider.of<ListStoryByTypeViewModel>(context, listen: false);
    _listStoryByTypeViewModel.fetchListStoryByType(widget.listStoryType, 1, widget.datasource);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Expanded(
            child:Consumer<ListStoryByTypeViewModel>(
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
                                child: DetailStoryScreen(storyTitle: story.title, datasource: widget.datasource,),
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
