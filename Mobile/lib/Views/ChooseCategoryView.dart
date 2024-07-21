import 'package:flutter/material.dart';
import 'package:project_login/Models/Category.dart';
import 'package:provider/provider.dart';

import '../ViewModels/ChooseCategoryViewModel.dart';

class ChooseCategoryScreen extends StatefulWidget {
  final String category;
  final String datasource;
  const ChooseCategoryScreen({super.key,required this.datasource,required this.category});
  @override
  State<ChooseCategoryScreen> createState() => _ChooseCategoryScreenState();
}

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {
  late ChoiseCategoryViewModel _choiseCategoryViewModel;
  bool firsttime=true;
  @override
  void initState() {
    super.initState();
    _choiseCategoryViewModel=Provider.of<ChoiseCategoryViewModel>(context,listen: false);
    _choiseCategoryViewModel.fetchCategories(widget.datasource);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading:  BackButton(
            onPressed: (){
              Navigator.pop(context,widget.category);
            },
          ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.black
              ),
            ),
            SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            border: Border(bottom:
                            BorderSide(
                              color: Colors.white,
                              width: 2.0
                            ))
                        ),
                        child:  const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.category,size: 28,color: Colors.white,),
                              Text("CATEGORIES",style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ))
                            ]
                        ),
                      ),
                      Expanded(
                          child: Consumer<ChoiseCategoryViewModel>(
                            builder: (context,sourceNotify,_) {
                              List<Category> categories=[Category(content: 'All', url: '')];
                              categories.addAll((sourceNotify.categories ?? []) as Iterable<Category>);
                              if(categories.length==1){
                                return const Center(child: CircularProgressIndicator());
                              }else{
                                return GridView.builder(
                                    itemCount: categories.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, // Số lượng cột trong grid view
                                      mainAxisSpacing: 1, // Khoảng cách giữa các hàng
                                      childAspectRatio: 3/2,
                                    ),
                                    itemBuilder: (context,index){
                                      return GestureDetector(
                                        onTap: (){
                                          sourceNotify.changeCategory(categories[index].content);
                                          firsttime=false;
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: categories[index].content == (firsttime ? widget.category: sourceNotify.choisedCategory) ? Colors.redAccent : Colors.black,
                                          ),
                                          child: Text(categories[index].content,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.white,
                                            ),),
                                        ),
                                      );
                                    }
                                );
                              }
                            },)),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Đảm bảo các nút được căng giữa và có khoảng cách giữa chúng
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context,widget.category);
                              },
                              child: Container(
                                width: 80,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context,_choiseCategoryViewModel.choisedCategory);
                              },
                              child: Container(
                                width: 80,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Apply',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
            )
          ],
        )
    );
  }
}
