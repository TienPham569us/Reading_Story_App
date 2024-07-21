
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:project_login/Models/ContentStoryComics.dart';
import 'dart:convert';
import '../Models/ChapterPagination.dart';


import '../Models/ContentStory.dart';
import '../Models/Story.dart';
import '../Models/Category.dart' as categoryModel;



class StoryService {
  //avd: 10.0.2.2
  //final String ipAddress = "10.0.2.2";

  //physical device: localhost
  final String ipAddress = "localhost";
  final int port=3000;
  Future<List<String>> fetchListNameDataSource() async {
    final response = await http.get(Uri.parse('http://$ipAddress:$port/api/v1/listDataSource/'));

    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      List<String> result =  List<String>.from(jsonData['names']);
      return result;
    } else {
      throw Exception("Fail to fetch fetchListNameDataSource");
    }
  }

  Future<List<Story>> fetchSearchStory(String query, String datasource, int page) async {
    final response = await http.get(Uri.parse('http://$ipAddress:$port/api/v1/search/?datasource=$datasource&search=$query&page=$page'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Story.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch search story');
    }
  }
  Future<List<Story>> fetchSearchStoryByCategory(String query, String datasource, int page, String category) async {
    final response = await http.get(
        Uri.parse(
            'http://$ipAddress:$port/api/v1/search/?datasource=$datasource&search=$query&page=$page&category=$category'
        ));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Story.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch search story by category');
    }

  }
  Future<Story> fetchDetailStory(String title, String datasource) async {
    final response = await http.get(Uri.parse('http://$ipAddress:$port/api/v1/detailStory/?datasource=$datasource&title=$title'));

    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      Logger logger = Logger();
      logger.i(Story.fromJson(jsonData).toString());
      return Story.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch detail story');
    }
  }
  Future<Story?> fetchChangeDetailStoryToThisDataSource(String title, String datasource) async {
    final response = await http.get(Uri.parse('http://$ipAddress:$port/api/v1/changeDetailStoryDataSource/?datasource=$datasource&title=$title'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      String message = jsonData['message'];
      if (message!=null && message=="found") {

        Logger logger = Logger();
        logger.i(Story.fromJson(jsonData['data']).toString());
        return Story.fromJson(jsonData['data']);
      }
      return null;

    } else {
      throw Exception('Failed to fetch detail story');
    }
  }
  Future<ContentStory?> fetchChangeContentStoryToThisDataSource(String title, String datasource, int chap) async {
    final response = await http.get(Uri.parse('http://$ipAddress:$port/api/v1/changeContentStoryDataSource/?datasource=$datasource&title=$title&chap=$chap'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      String message = jsonData['message'];
      if (message!=null && message=="found") {

        Logger logger = Logger();
        logger.i(ContentStory.fromJson(jsonData['data']).toString());
        return ContentStory.fromJson(jsonData['data']);
      }
      return null;

    } else {
      throw Exception('Failed to fetch detail story');
    }
  }
  Future<ContentStory> fetchContentStory(String storyTitle, int chapNumber, String datasource) async {
    final response = await http.get(Uri.parse('http://$ipAddress:$port/api/v1/contentStory/?datasource=$datasource&title=$storyTitle&chap=$chapNumber'));

    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      return ContentStory.fromJson(jsonData);
    } else {
      throw Exception("Failed to fetch content of story");
    }
  }

  Future<Map<String, List<Story>>> fetchHomeStory(String datasource) async {
      final response = await http.get(Uri.parse('http://$ipAddress:$port/api/v1/home/?datasource=$datasource'));

      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        Map<String, List<Story>> mapStories = <String, List<Story>>{};

        jsonData.forEach((category, jsonList) {
          mapStories[category] = parseListStories(jsonList);
        });

        return mapStories;

      } else {
        throw Exception("Failed to fetch home of story");
      }
  }

  List<Story> parseListStories(List<dynamic> jsonList) {
    return jsonList.map((json) => Story.fromJson(json)).toList();
  }

  Future<List<categoryModel.Category>> fetchListCategory(String datasource) async {
    try {
      final response = await http.get(Uri.parse('http://$ipAddress:$port/api/v1/listCategory/?datasource=$datasource'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        if (jsonData.isNotEmpty) {
          List<categoryModel.Category> listCategories = jsonData.map((json) => categoryModel.Category.fromJson(json)).toList();

          return listCategories;
        } else {
          // Trường hợp danh sách trả về rỗng
          throw Exception("Empty list of categories");
        }
      } else {
        // Trường hợp không nhận được response 200 từ server
        throw Exception("Failed to fetch list of category: ${response.statusCode}");
      }
    } catch (e) {
      // Bắt các lỗi khác có thể xảy ra trong quá trình gọi API
      throw Exception("Failed to fetch list of category: $e");
    }
  }


  Future<ChapterPagination> fetchChapterPagination(String title, int pageNumber, String datasource) async {
    final response = await http.get(Uri.parse('http://$ipAddress:$port/api/v1/listChapter/?datasource=$datasource&title=$title&page=$pageNumber'));

    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      return ChapterPagination.fromJson(jsonData);
    } else {
      throw Exception("Failed to fetch Chapter Pagination");
    }
  }
  Future<List<Story>> fetchListStoryByType(String typeOfList, int pageNumber, String datasource) async {
    final response = await http.get(
        Uri.parse(
            'http://$ipAddress:$port/api/v1/listStory/?datasource=$datasource&type=$typeOfList&page=$pageNumber'
        ));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Story.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch list story by type');
    }
  }

  Future<ContentStoryComics> fetchContentStoryComics(String storyTitle, int chapNumber, String datasource) async {
    final response = await http.get(Uri.parse('http://$ipAddress:$port/api/v1/contentStory/?datasource=$datasource&title=$storyTitle&chap=$chapNumber'));

    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      return ContentStoryComics.fromJson(jsonData);
    } else {
      throw Exception("Failed to fetch content of story");
    }
  }

}

