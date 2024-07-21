import 'Category.dart';



//ip avd: 10.0.2.2
class Story {
  String name;
  String link;
  String title;
  String cover;
  String description;
  String author;
  String authorLink;
  String? view;
  String? detail;
  String? format;
  List<Category>? categories;

  Story({required this.name,
    required this.cover,
    required this.link,
    required this.title,
    required this.description,
    required this.author,
    required this.authorLink,
    this.view,
    required this.categories,
    this.detail,
    this.format});

  factory Story.fromJson(Map<String, dynamic> json) {

    List<Category>? categoryList = json['categoryList'] != null
        ? (json['categoryList'] as List<dynamic>).map(
            (category) => Category.fromJson(category)
    ).toList()
        : null;

    return Story(name: json['name'],
        cover: json['cover'],
        link: json['link'],
        author: json['author'],
        title: json['title'],
        view: json.containsKey('detail') ? json['view'] : null,
        description: json['description'],
        authorLink: json['authorLink'],
        categories: categoryList,
        detail: json.containsKey('detail') ? json['detail'] : null,
        format: json.containsKey('format') ? json['format'] : null);
  }

  @override
  String toString() {
    String? str = categories?.join(" === ");
    return 'Story{name: $name,detail: $detail,cover: $cover, format: $format, categories: $str}';
    //return 'Story{name: $name, link: $link, title: $title, cover: $cover, description: $description, author: $author, authorLink: $authorLink, view: $view, detail: $detail, categories: $str}';
  }
}
