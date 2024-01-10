import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:provider/provider.dart';

import 'cart_provider.dart';
import 'cart_screen.dart';

class ShowItems extends StatefulWidget {
  final String selectedCategoryId;

  const ShowItems({Key? key, required this.selectedCategoryId}) : super(key: key);

  @override
  State<ShowItems> createState() => _ShowItemsState();
}

class _ShowItemsState extends State<ShowItems> {
  bool _loading = false;
  List<Map<String, dynamic>> _items = [];
  final String _baseURL = 'https://zakdeliveryapp.000webhostapp.com'; 

  @override
  void initState() {
    super.initState();
    updateItems(update);
  }

  void update(bool success) {
    setState(() {
      _loading = true;
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load data')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Items'),
        centerTitle: true,
        actions: <Widget>[
          // Cart Button
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
          ? ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item['item_name']),
            subtitle: Text('Price: \$${item['item_price']}'),
            leading: Image.network(item['item_image']),
            trailing: ElevatedButton(
              onPressed: () {
                addToCart(context,item);
                print(item);
              },
              child: Text('Add to Cart'),
            ),
          );
        },
      )
          : const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: Text('Data Loading...'),
        ),
      ),
    );
  }

  void updateItems(Function(bool success) update) async {
    try {
      final url = Uri.parse('$_baseURL/getItems.php?category_id=${widget.selectedCategoryId}');
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      _items.clear(); // Clear old items

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);

        for (var row in jsonResponse) {
          _items.add({
            'item_id':row['item_id'],
            'item_name': row['item_name'],
            'item_price': row['item_price'],
            'item_image': '$_baseURL/assets/items/${row['item_image']}',
          });
        }

        update(true); // Callback to inform that we completed retrieving data
      }
    } catch (e) {
      update(false); // Inform through callback that we failed to get data
    }
  }

  void addToCart(BuildContext context, Map<String, dynamic> item) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Check if the item is already in the cart based on both item_id and type
    if (!cartProvider.isItemInCart(item)) {
      // Item is not in the cart, add it
      cartProvider.addToCart(item);
      print(cartProvider.cartItems);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item is added in the cart')),);
    } else {
      print(cartProvider.cartItems);

      // Item is already in the cart, display a message or take appropriate action
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item is already in the cart')),
      );
    }
  }
}
