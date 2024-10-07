import 'package:flutter/material.dart';
import 'package:hagora/providers/new_provider_db.dart';

import 'package:provider/provider.dart';

import '../News/detailed_news.dart';
class NewsLocalPage extends StatelessWidget {
  late final String currentUser;

  NewsLocalPage(String user, {super.key}){
    currentUser = user;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text('Saved News'),
        backgroundColor: Colors.red,
        centerTitle: true,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 25),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.red.shade50

            ],
          ),
        ),

        child: Consumer<NewsProviderDb>(

          builder: (context, NewsProviderDb, child) {
            NewsProviderDb.init(currentUser);
            if (NewsProviderDb.getNewsLocal.isEmpty) {
              return const Center(child: Text('No News Found'));
            }

            return ListView.builder(
              itemCount: NewsProviderDb.getNewsLocal.length,
              itemBuilder: (context, index) {
                final news = NewsProviderDb.getNewsLocal[index];
                return Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,   // Set the border color
                            width: 2.0,          // Set the border width
                          ),
                          borderRadius: BorderRadius.circular(10),  // Optional: Rounded corners
                        ),
                        child: ListTile(
                          trailing: IconButton(onPressed: (){
                            NewsProviderDb.deleteData(news);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Removed")));



                          }, icon: Icon(Icons.delete,color: Colors.black,)),
                          leading: SizedBox(width: 100,height: 100,child: Image.network(news.urlToImage??"")) ,
                          title: SizedBox(width:100,height:100,child:
                          Center(child:
                          Text(news.title??"no news",
                            style: TextStyle(color: Colors.black),
                          )
                          )
                          ),
                          onTap: () {
                            // Navigate to the NewsDetailsPage with the selected news details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                    title: news.title??"",
                                    description: news.description??"",
                                    imageUrl: news.urlToImage??"",
                                    author: news.author??"",
                                    url:news.url??""
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  ],
                );

              },
            );
          },

        ),
      ),
    ));
  }
}