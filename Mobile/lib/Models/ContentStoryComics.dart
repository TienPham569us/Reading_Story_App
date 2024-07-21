
import 'package:project_login/Models/ChapterImage.dart';

class ContentStoryComics {
  late String name;

  late String chap;
  late String title;
  late String? chapterTitle;
  late String author;
  late String cover;
  late List<ChapterImage>? content;

  ContentStoryComics({required this.name,
    required this.title,
    required this.chap,
    required this.content,
    this.chapterTitle,
    required this.author,
    required this.cover});

  ContentStoryComics clone() {
    return ContentStoryComics(
      name: this.name,
      title: this.title,
      chap: this.chap,
      content: this.content,
      chapterTitle: this.chapterTitle,
      author: this.author,
      cover: this.cover,
    );
  }


  @override
  String toString() {
    return 'ContentStory{name: $name, chap: $chap, title: $title, chapterTitle: $chapterTitle, author: $author, cover: $cover}';
  }

  factory ContentStoryComics.fromJson(Map<String, dynamic> json) {
    List<ChapterImage>? listChapterFromApi = json['content'] != null
        ? (json['content'] as List<dynamic>)
        .map((chapter) => ChapterImage.fromJson(chapter))
        .toList()
        : null;

    return ContentStoryComics(name: json['name'],
        title: json['title'],
        chap: json['chap'],
        content: listChapterFromApi,
        chapterTitle: json.containsKey("chapterTitle") ? json['chapterTitle'] : null,
        author: json['author'],
        cover: json['cover']);
  }
}