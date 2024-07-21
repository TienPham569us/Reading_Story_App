import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_login/Services/StoryService.dart';
import 'package:project_login/ViewModels/ListSearchViewModel.dart';
import 'package:project_login/Views/ListSearchView.dart';
import 'package:provider/provider.dart';

import '../ViewModels/SearchViewModel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchViewModel _searchViewModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchViewModel=Provider.of<SearchViewModel>(context,listen: false);
    _searchViewModel.fetchHistoryList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded( // Expand TextField to fill available space
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: Colors.grey,
                      hintText: 'Search here...',
                      contentPadding: const EdgeInsets.only(top: 2),
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onSubmitted: (searchTerm){
                      _searchViewModel.insertHistory(searchTerm);
                      _searchViewModel.saveAll();
                      Navigator.push(
                          context,MaterialPageRoute(
                          builder: (context)=>ChangeNotifierProvider(
                            create: (context)=>ListSearchViewModel(storyService: StoryService()),
                            child: ListSearchScreen(searchString:searchTerm),
                          )
                      )
                      );
                    },
                  ),
                ),
                TextButton( // Use TextButton for cancel button
                  onPressed: () {
                    _searchViewModel.saveAll();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(width: 30),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text("History", style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _searchViewModel.deleteAll();
                      });
                    },
                    icon: const Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 30),
            // Add the ListView here
            Consumer<SearchViewModel>(
                builder: (context,historyListViewModel,_){
                  if(historyListViewModel.historylist.isEmpty){
                    return const Center(
                        child: Text('No search history yet',style: TextStyle(color: Colors.white)));
                  }
                  else{
                    return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(historyListViewModel.historylist.length, (index) => GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,MaterialPageRoute(
                                builder: (context)=>ChangeNotifierProvider(
                                  create: (context)=>ListSearchViewModel(storyService: StoryService()),
                                  child: ListSearchScreen(searchString: _searchViewModel.historylist[index]),
                                )
                            )
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(historyListViewModel.historylist[index], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          ),
                        )));
                  }
                }
            )
          ],
        ),
      ),
    );
  }
}