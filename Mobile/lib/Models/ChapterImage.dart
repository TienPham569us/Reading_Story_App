class ChapterImage {
  late int imagePage;
  late String imagePath;

  ChapterImage({required this.imagePath, required this.imagePage});

  @override
  String toString() {
    return 'ChapterImage{imagePage: $imagePage, imagePath: $imagePath}';
  }

  factory ChapterImage.fromJson(Map<String, dynamic> json) {
    return ChapterImage(imagePath: json['image_file'], imagePage: json['image_page']);
  }
}