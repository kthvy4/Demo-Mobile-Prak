import 'package:demo_mobile/app/data/service/service_api.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> _catImagesFuture;

  @override
  void initState() {
    super.initState();
    _catImagesFuture = CatApiService().fetchCatImages(limit: 5); // Fetch 5 cat images
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CatCare'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications'); // Navigate to notifications page
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Welcome in CatCare!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          // Horizontal scrollable cat images
          FutureBuilder<List<String>>(
            future: _catImagesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return Container(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.network(snapshot.data![index]),
                      );
                    },
                  ),
                );
              } else {
                return Center(child: Text('No data found'));
              }
            },
          ),
          SizedBox(height: 16),

          // Recommended cat food section
          Text(
            'Recommended',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          // Cat food grid view
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildRecommendedItem('Whiskas Junior', 'https://path-to-image.jpg', '\$36/kg'),
              _buildRecommendedItem('Snack Cat', 'https://path-to-image.jpg', '\$36/kg'),
              _buildRecommendedItem('Felix Cat', 'https://path-to-image.jpg', '\$35/kg'),
              _buildRecommendedItem('Vitamin Cat', 'https://path-to-image.jpg', '\$35/kg'),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.black,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            backgroundColor: Colors.black,
            label: 'Article',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            backgroundColor: Colors.black,
            label: 'Shopping',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            backgroundColor: Colors.black,
            label: 'Profile',
          ),
        ],
        currentIndex: 0, // Current page index
        onTap: (index) {
          switch (index) {
            case 0:
              // Home
              break;
            case 1:
              Navigator.pushNamed(context, '/articles');
              break;
            case 2:
              Navigator.pushNamed(context, '/shopping');
              break;
            case 3:
              Navigator.pushNamed(context, '/profiles');
              break;
          }
        },
      ),
    );
  }

  // Function to build each recommended item widget
  Widget _buildRecommendedItem(String title, String imageUrl, String price) {
    return Column(
      children: [
        Image.network(imageUrl, height: 100),
        SizedBox(height: 8),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(price),
      ],
    );
  }
}