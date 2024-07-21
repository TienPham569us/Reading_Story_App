
import 'package:logger/logger.dart';

class Chapter {
  String content;
  String url;

  Chapter({required this.content, required this.url});

  Chapter.defaults()
      : content = '',
        url = '';

  @override
  String toString() {
    return 'Chapter{content: $content, url: $url}';
  }

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(content: json['content'], url: json['href']);
  }

}
