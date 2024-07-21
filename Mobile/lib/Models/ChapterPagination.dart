import 'Chapter.dart';

class ChapterPagination {
  List<Chapter>? listChapter;
  int maxChapter;
  int currentPage;
  int maxPage;
  int chapterPerPage;

  ChapterPagination(
      {required this.listChapter,
      required this.maxChapter,
      required this.currentPage,
      required this.maxPage,
      required this.chapterPerPage,});

  ChapterPagination.defaults()
      : listChapter = [Chapter.defaults()],
        maxChapter = 0,
        currentPage = 0,
        maxPage = 0,
        chapterPerPage =0;

  factory ChapterPagination.fromJson(Map<String, dynamic> json) {
    List<Chapter>? listChapterFromApi = json['listChapter'] != null
        ? (json['listChapter'] as List<dynamic>)
            .map((chapter) => Chapter.fromJson(chapter))
            .toList()
        : null;

    return ChapterPagination(
        listChapter: listChapterFromApi,
        maxChapter: json['maxChapter'],
        currentPage: json['currentPage'],
        maxPage: json['maxPage'],
        chapterPerPage: json['chapterPerPage']);
  }

  @override
  String toString() {
    String? str = listChapter?.join(" === ");
    return 'ChapterPagination{chapterPerPage: $chapterPerPage, maxChapter: $maxChapter, currentPage: $currentPage, maxPage: $maxPage, listChapter: $str}';
  }
}
