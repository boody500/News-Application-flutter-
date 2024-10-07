import 'package:flutter/material.dart';
import 'package:hagora/providers/new_provider_db.dart';
import 'package:provider/provider.dart';
import 'package:hagora/providers/news_provider_api.dart';
import 'package:hagora/views/News/detailed_news.dart';
import 'package:hagora/model/news.dart'; // Import your provider

  class SearchPage extends StatelessWidget {
    final TextEditingController _searchController = TextEditingController();
    final NewsProviderDb providerDb = NewsProviderDb();
    late final String currentUser;

    SearchPage(String user, {super.key}){
      currentUser = user;
      providerDb.init(currentUser);
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Search News'),
          centerTitle: true,
          backgroundColor: Colors.red,
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 25),
          leading: IconButton(onPressed: (){
            Provider.of<NewsProviderApi>(context, listen: false).clearSearchNews();
            Navigator.pop(context);

          } , icon: Icon(Icons.arrow_back,color: Colors.white,)),
        ),
        body:Container(
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
            child: Column(
              children: [
                // Search input field
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),

                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search News',

                      border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), ),
                      suffixIcon: IconButton(onPressed: (){
                        String searchQuery = _searchController.text.trim();
                        if (searchQuery.isNotEmpty) {
                          Provider.of<NewsProviderApi>(context, listen: false).fetchNews(searchQuery);
                        }
                      }, icon: const Icon(Icons.search,color: Colors.black,)),

                    ),
                    style: const TextStyle(color: Colors.black),

                  ),
                ),
                const SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     // When the search button is pressed, pass the search term to the provider
                //     String searchQuery = _searchController.text.trim();
                //     if (searchQuery.isNotEmpty) {
                //       Provider.of<NewsProviderApi>(context, listen: false).fetchNews(searchQuery);
                //     }
                //   },
                //   child: Text('Search'),
                // ),
                
                Expanded(child: Consumer<NewsProviderApi>(
                  builder: (context, NewsProviderApi, child) {
                    if (NewsProviderApi.IsLoading) {
                      return const Center(child: CircularProgressIndicator()); // Loading indicator
                    }

                    if (NewsProviderApi.getNews.isEmpty) {
                      return const Center(child: Text('No News Found'));
                    }

                    return ListView.builder(
                      itemCount: NewsProviderApi.getNews.length,
                      itemBuilder: (context, index) {
                        final news = NewsProviderApi.getNews[index];
                        print(news.title);
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
                                  leading: SizedBox(child: Image.network(
                                      news.urlToImage??"",
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return Image.network("https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png");}


                                  ) ,width: 100,height: 100,),

                                  trailing: currentUser != "Guest" ? IconButton(onPressed: (){

                                      providerDb.insertData(News(title: news.title??"", author: news.author??"", description: news.description??"", urlToImage: news.urlToImage??"", url: news.url??""));
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved")));





                                  }, icon: const Icon(Icons.star,color: Colors.black,)) : null,
                                  title: SizedBox(width:100,height:100,child:

                                  Center(child:
                                  Text(news.title??"no news",
                                    style: const TextStyle(color: Colors.black),
                                  )
                                  )
                                  ),
                                  onTap: () {
                                    // Navigate to the NewsDetailsPage with the selected news details
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsPage(
                                            title: news.title ?? "",
                                            description: news.description ?? "",
                                            imageUrl: news.urlToImage ?? "",
                                            author: news.author??"",
                                            url:news.url??""//
                                        ),
                                      ),
                                    );
                                  },
                                  //subtitle: Text('see more.....'),
                                ),
                              ),
                            ),

                          ],
                        );

                      },
                    );
                  },

                ),)

              ],
            ),
            
          ),

      );
    }
  }
