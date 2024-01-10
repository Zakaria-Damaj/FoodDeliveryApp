import 'package:flutter/material.dart';
import 'package:project_mobile/pages/place_order_screen.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review Your Order:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartProvider.cartItems[index];
                  return ListTile(
                    title: Text(cartItem['item_name']),
                    subtitle: Text('Price: \$${cartItem['item_price']}'),
                    leading: Image.network(cartItem['item_image']),
                    trailing: Text('Quantity: ${cartItem['quantity']}'),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Items: ${cartProvider.getTotalItems()}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total Price: \$${cartProvider.getTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlaceOrderScreen(items: cartProvider.cartItems, totalPrice: cartProvider.getTotalPrice())),
                );
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
