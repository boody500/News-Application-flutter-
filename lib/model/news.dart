class News{
  final String? title;
  final String? author;
  final String? description;
  final String? urlToImage;
  final String? url;


  News({required this.title, required this.author,required this.description,required this.urlToImage,required this.url});
  factory News.fromJson(Map<String, dynamic> json)
  {
    return News(
        title: json['title'],
        author: json['author'],
        description: json['description'],
        urlToImage: json['urlToImage'],
        url: json['url']
    );
  }
  toJson(){
    return {
      "title": title,
      "author":author,
      "description": description,
      "urlToImage": urlToImage,
      "url": url

    };
  }
}