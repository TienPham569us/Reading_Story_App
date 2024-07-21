import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_login/Models/Story.dart';
import 'package:project_login/ViewModels/DetailStoryViewModel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('DetailStoryViewModel',()   {
    final detailStoryViewModel = DetailStoryViewModel();
    test('Fetching story successfully',() async {
      final story = Story(name: "Tu vi dao" ,author: "Van Cao", authorLink: "ducthien.com.vn", description: "Hay",
          link: "examplelink.com.vn",cover: "example.com.vn",title: "Truyen moi",detail: "Nothing",view: "Sight",categories: []);
      final result = await detailStoryViewModel.fetchDetailsStory("van-co-than-de", "Truyen123");
      expect(result, true);
    });
    test('Check all attributes fectched right',() async {
      final story = Story(name: "Tu vi dao" ,author: "Van Cao", authorLink: "abc.com.vn", description: "Hay",
          link: "examplelink.com.vn",cover: "example.com.vn",title: "A",detail: "Perfect",view: "Nothing",categories: []);
      final result = await detailStoryViewModel.fetchDetailsStory("9891", "Truyenfull");
      expect(story.name.runtimeType, detailStoryViewModel.story?.name.runtimeType);
      expect(story.cover.runtimeType, detailStoryViewModel.story?.cover.runtimeType);
      expect(story.author.runtimeType, detailStoryViewModel.story?.author.runtimeType);
      expect(story.title.runtimeType, detailStoryViewModel.story?.title.runtimeType);
      expect(story.description.runtimeType, detailStoryViewModel.story?.description.runtimeType);
    });
  });
}