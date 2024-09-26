import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
>>>>>>> 58e33d3 (Add eventlet)

class LibraryPage extends StatelessWidget {
  final bool fromBottomNavBar;
  const LibraryPage({super.key, this.fromBottomNavBar = true});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Articles',
      theme: ThemeData(
        primaryColor: const Color(0xFFF7C843),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          bodyMedium: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
          ),
          bodyLarge: TextStyle(
            color: Colors.grey[800],
            fontSize: 18,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.grey[800]),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Articles',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Handle search action
              },
            ),
          ],
          leading: fromBottomNavBar
              ? null
              : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
        ),
<<<<<<< HEAD
        body: Column(
          children: [
            const CategoryTabs(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  ArticleCard(
                    title: 'How to Handle Toddler Tantrums',
                    author: 'Jane Doe',
                    description:
                        'Learn effective strategies to calm your toddler during tantrums...',
                    onReadMore: () {
                      // Handle read more action
                    },
                  ),
                  ArticleCard(
                    title: 'Healthy Meal Ideas for Busy Moms',
                    author: 'John Smith',
                    description:
                        'Discover quick and nutritious meal ideas that fit into your busy schedule...',
                    onReadMore: () {
                      // Handle read more action
                    },
                  ),
                  ArticleCard(
                    title: 'Managing Stress as a New Parent',
                    author: 'Emily Johnson',
                    description:
                        'Tips and advice on how to manage stress and find balance as a new parent...',
                    onReadMore: () {
                      // Handle read more action
                    },
                  ),
                ],
              ),
            ),
=======
        body: const Column(
          children: [
            Expanded(
                child:
                    CategoryTabs()), // Moved Expanded to make tabs functional with content
>>>>>>> 58e33d3 (Add eventlet)
          ],
        ),
      ),
    );
  }
}

<<<<<<< HEAD
class CategoryTabs extends StatelessWidget {
  const CategoryTabs({super.key});

  @override
=======
class CategoryTabs extends StatefulWidget {
  const CategoryTabs({super.key});

  @override
  _CategoryTabsState createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  int currentTab = 0; // Tracks the selected tab
  bool isLoading = true;
  List<dynamic> articles = [];
  Future<void> fetchArticlesForTab(int index) async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'auth_token');
    if (token == null) {
      // Handle token not found
    } else {
      // Fetch articles for the selected tab
      if (index == 0) {
        fetchArticles('parenting', token);
      } else if (index == 1) {
        fetchArticles('health', token);
      } else {
        fetchArticles('mental-health', token);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchArticlesForTab(currentTab);
  }

  Future<void> fetchArticles(String topic, String token) async {
    setState(() {
      isLoading = true;
    });

    final url =
        'https://momhive-992deeb4847a.herokuapp.com/api/v1/articles/$topic';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Add this line
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          articles = json.decode(response.body);
        });
      } else {
        setState(() {
          articles = [];
        });
      }
    } catch (e) {
      setState(() {
        articles = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
>>>>>>> 58e33d3 (Add eventlet)
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicator: BoxDecoration(
                color: const Color(0xFFF7C843),
                borderRadius: BorderRadius.circular(20),
              ),
<<<<<<< HEAD
=======
              onTap: (index) {
                setState(() {
                  currentTab = index;
                  fetchArticlesForTab(index);
                });
              },
>>>>>>> 58e33d3 (Add eventlet)
              tabs: const [
                Tab(text: 'Parenting Tips'),
                Tab(text: 'Health & Wellness'),
                Tab(text: 'Mental Health'),
              ],
            ),
          ),
<<<<<<< HEAD
=======
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return ArticleCard(
                        title: article['title'] ?? 'No Title',
                        author: article['author'] ?? 'Unknown Author',
                        description: article['description'] ?? 'No Description',
                        onReadMore: () {
                          // Handle read more action, e.g., navigate to a details page
                        },
                      );
                    },
                  ),
          ),
>>>>>>> 58e33d3 (Add eventlet)
        ],
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final String title;
  final String author;
  final String description;
  final VoidCallback onReadMore;

  const ArticleCard({
    super.key,
    required this.title,
    required this.author,
    required this.description,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'by $author',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: onReadMore,
              child: const Text(
                'Read More',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
