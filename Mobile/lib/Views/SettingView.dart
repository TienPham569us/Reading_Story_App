import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_login/ViewModels/HomeStoryViewModel.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      border: Border(bottom:
                      BorderSide(
                          color: Colors.white,
                          width: 4.0
                      ))
                  ),
                  child: const Text('List Source Book',style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),)),
              const Expanded(
                child: SortSourceBook(),
              )
            ],
          )
      ),
    );
  }
}




class SortSourceBook extends StatefulWidget {
  const SortSourceBook({super.key});

  @override
  State<SortSourceBook> createState() => _SortSourceBookState();
}

class _SortSourceBookState extends State<SortSourceBook> {

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeStoryViewModel>(
      builder: (context, sourceBookNotifier, _) {
        return ReorderableListView(
          children: List.generate(
            sourceBookNotifier.sourceBooks.length,
                (index) => Container(
              key: Key('$index'),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red,width: 6),
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white
              ),
              child: Container(
                child: ListTile(
                  title: Container(
                    alignment: Alignment.center,
                    child: Text(
                      sourceBookNotifier.sourceBooks[index],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          onReorder: (int oldIndex, int newIndex) {
            sourceBookNotifier.reorder(oldIndex, newIndex);
            sourceBookNotifier.changeIndex(0);
            sourceBookNotifier.changeSourceBook(sourceBookNotifier.sourceBooks[0]);
            sourceBookNotifier.fetchHomeStories(sourceBookNotifier.sourceBooks[0]);
            sourceBookNotifier.saveStringList("LIST_SOURCE", sourceBookNotifier.sourceBooks);
            sourceBookNotifier.changeCategory("All");
          },
        );
      },
    );
  }
}

