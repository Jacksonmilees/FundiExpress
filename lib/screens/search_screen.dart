import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search handymen...",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
        ),
      ),
      body: FutureBuilder(
        future: _fetchHandymen(), // Fetch from the backend later
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          List<Map<String, dynamic>> filteredList = snapshot.data!
              .where((handyman) =>
                  handyman['name'].toLowerCase().contains(searchQuery) ||
                  handyman['category'].toLowerCase().contains(searchQuery))
              .toList();

          return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              var handyman = filteredList[index];
              return ListTile(
                title: Text(handyman['name']),
                subtitle: Text(handyman['category']),
                leading: CircleAvatar(backgroundImage: NetworkImage(handyman['image'])),
              );
            },
          );
        },
      ),
    );
  }

  // Simulated data - replace with backend call
  Future<List<Map<String, dynamic>>> _fetchHandymen() async {
    return [
      {"name": "John Doe", "category": "Plumber", "image": "https://example.com/john.jpg"},
      {"name": "Jane Smith", "category": "Electrician", "image": "https://example.com/jane.jpg"},
      {"name": "Mike Johnson", "category": "Housemaid", "image": "https://example.com/mike.jpg"},
    ];
  }
}
