import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String  author;
  final String url;
  DetailsPage({required this.title, required this.description, required this.imageUrl,required this.author,required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.red,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle:  TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),

      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.white,
              Colors.red.shade50
            ],
            //tileMode: TileMode.mirror,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News image
            if (imageUrl.isNotEmpty)
              Expanded(child: Image.network(imageUrl, height: 250, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Image.network("https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png");})),

            // News title
            Text(
              title.isNotEmpty? title : "No title found",
              style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
            ),

            //author
            Text(
              author.isNotEmpty? "Author: $author" : "No author found",
              style: const TextStyle(color: Colors.grey, fontSize: 16,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8,),
            // News description
            Expanded(child: Text(
              description.isNotEmpty ? "Description: $description" : "No Description Available",
              style: const TextStyle(color: Colors.black, fontSize: 16),
            )),
            const SizedBox(height: 20),
            Center(child: ElevatedButton(onPressed: (){
              _launchURL(url);
            },
              child: const Text("Read More",style: TextStyle(color: Colors.black)),
              style: ButtonStyle(backgroundColor:  WidgetStateProperty.all(Colors.red), ),
            ),)
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }
}


