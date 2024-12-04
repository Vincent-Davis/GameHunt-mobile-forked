import 'package:flutter/material.dart';
import 'package:gamehunt/models/news_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; 
import 'package:provider/provider.dart';
import 'package:gamehunt/screens/news_detail.dart'; 

// import 'package:gamehunt/widgets/left_drawer.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<List<News>> fetchNews(CookieRequest request) async {
    // Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    final response = await request.get('http://127.0.0.1:8000/json/');
    
    // Melakukan decode response menjadi bentuk json
    var data = response;
    
    // Melakukan konversi data json menjadi object NewsEntry
    List<News> listNews = [];
    for (var d in data) {
      if (d != null) {
        listNews.add(News.fromJson(d));
      }
    }
    return listNews;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('News List'),
      ),
      // drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchNews(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'Slow news day...',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
  itemCount: snapshot.data!.length,
  itemBuilder: (_, index) {
    final news = snapshot.data![index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetail(news: news),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news.fields.title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(news.fields.author),
            const SizedBox(height: 10),
            Text(news.fields.updateDate),
            const SizedBox(height: 10),
            Text(news.fields.article),
          ],
        ),
      ),
    );
  },
);
            }
          }
        },
      ),
    );
  }
}