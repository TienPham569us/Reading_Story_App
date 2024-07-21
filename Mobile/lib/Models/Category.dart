
class Category {
  String content;
  String url;

  Category({required this.content, required this.url});

  @override
  String toString() {
    return 'Category{content: $content, url: $url}';
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(content: json['content'], url: json['href']);
  }

}
