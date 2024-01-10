import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mobile/pages/show_items.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;

import '../auth/AuthProvider.dart';
import '../auth/login_page.dart';
import 'cart_screen.dart';

const String _baseURL = 'https://zakdeliveryapp.000webhostapp.com/';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;
  List<Map<String, dynamic>> _categories = [];

  void update(bool success) {
    setState(() {
      _loading = false; // show category list
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load data'),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the method to get categories when the widget is created
    updateCategories(update);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Category List'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                // Perform logout action
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                authProvider.logout();

                // Navigate to the login page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                // Navigate to the cart screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
              },
            ),
          ],
        ),
        body: _loading
            ? CircularProgressIndicator()
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigate to the ShowItems screen with the selected category ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowItems(selectedCategoryId: _categories[index]['cid']),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        _categories[index]['image'],
                        fit: BoxFit.cover, // Adjust the fit as needed
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(_categories[index]['name']),
                  ],
                ),
              ),
            );
          },
        ));
  }

  void updateCategories(Function(bool success) update) async {
    try {
      final url = Uri.parse('$_baseURL/getCategories.php');
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      _categories.clear(); // clear old categories

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        for (var row in jsonResponse) {
          _categories.add({
            'cid': row['cid'],
            'name': row['cname'],
            'image': '$_baseURL/assets/categories/${row['cimage']}',
          });
        }
        print(_categories); // Improved error message

        update(true);
      }
    } catch (e) {
      print('Error during updateCategories: $e'); // Improved error message
      update(false);
    }
  }
}
