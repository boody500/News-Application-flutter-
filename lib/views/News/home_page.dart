import 'package:flutter/material.dart';
import 'package:hagora/model/news.dart';
import 'package:hagora/providers/account_provider.dart';
import 'package:hagora/views/Account/accountView.dart';
import 'package:hagora/views/Favorites/news_local_view.dart';
import 'package:hagora/providers/new_provider_db.dart';
import 'package:hagora/providers/news_provider_api.dart';
import 'package:hagora/views/News/search_page.dart';
import 'package:provider/provider.dart';
import 'package:hagora/views/News/detailed_news.dart';

class NewsPage extends StatelessWidget {
  final NewsProviderDb providerDb = NewsProviderDb();
  final AuthProvider authProvider = AuthProvider();
  late final String currentUser;

  NewsPage(String user, {super.key}){
    currentUser = user;
    providerDb.init(currentUser);
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/bb.png",width: 200,height: 150,),
        backgroundColor: Colors.red,
        centerTitle: true,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 25),
        leading: IconButton(
            onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => NewsLocalPage(currentUser)),);
            },

            icon: Icon(Icons.list,color: Colors.white,)),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchPage(currentUser)),
          );}, icon: Icon(Icons.search,color: Colors.white,)),
          IconButton(onPressed: () async{
            //Navigator.pop(context);
              if(currentUser != "Guest"){
                Map<String, dynamic> userInfo = await authProvider.getUserInfo(currentUser);
                Navigator.push(context,MaterialPageRoute(builder: (context) => AccountPage(currentUser,userInfo['firstname'],userInfo['lastname'])));
              }
              else{
                Navigator.push(context,MaterialPageRoute(builder: (context) => AccountPage(currentUser,"Guest","Guest")));

              }



          }, icon: Icon(Icons.account_circle_rounded,color: Colors.white,))
        ],

      ),
      body: Container(

        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.red.shade50,

            ],
          ),
        ),

        child: Consumer<NewsProviderApi>(

          builder: (context, NewsProviderApi, child) {
            if (NewsProviderApi.IsLoading) {
              return const Center(child: CircularProgressIndicator()); // Loading indicator
            }

            if (NewsProviderApi.getTopNews.isEmpty) {
              return const Center(child: Text('No News Found'));
            }

            return ListView.builder(
              itemCount: NewsProviderApi.getTopNews.length,
              itemBuilder: (context, index) {
                final news = NewsProviderApi.getTopNews[index];
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
                          ), width: 100,height: 100,),


                          trailing: currentUser != "Guest"? IconButton(onPressed: (){

                              providerDb.insertData(News(title: news.title??"", author: news.author??"", description: news.description??"", urlToImage: news.urlToImage??"", url: news.url??""));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved")));


                          },
                              icon: Icon(Icons.star,color: Colors.black,)) : null,
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

        ),
      ),
    ));
  }
}

