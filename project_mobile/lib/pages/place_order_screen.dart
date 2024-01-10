import 'package:flutter/material.dart';
import 'package:project_mobile/pages/category_screen.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final double totalPrice;

  const PlaceOrderScreen({
    Key? key,
    required this.items,
    required this.totalPrice,
  }) : super(key: key);

  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Items:'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.items.map((item) {
                return ListTile(
                  title: Text(item['item_name']),
                  subtitle: Text('Price: \$${item['item_price']}'),
                  // Add any other details you want to display for each item
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Text('Total Price: \$${widget.totalPrice.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            Text(
              'User Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                cartProvider.clearCart();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order placed successfully')),
                );
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      )),
    );
  }
}
