import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        centerTitle: true,
      ),
      body: cartProvider.cartItems.isEmpty
          ? Center(
              child: Text('Your cart is empty.'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartProvider.cartItems[index];
                      return ListTile(
                        title: Text(cartItem['item_name']),
                        subtitle: Text('Price: \$${cartItem['item_price']}'),
                        leading: Image.network(cartItem['item_image']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                cartProvider.decreaseQuantity(cartItem);
                              },
                            ),
                            Text('${cartItem['quantity'] ?? 1}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                cartProvider.increaseQuantity(cartItem);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Remove the specific item when the delete button is pressed
                                removeFromCart(context, cartProvider, cartItem);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Items: ${cartProvider.getTotalItems()}'),
                      Text(
                          'Total Price: \$${cartProvider.getTotalPrice().toStringAsFixed(2)}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckoutScreen()),
                      );
                    },
                    child: Text('Checkout'),
                  ),
                ),
              ],
            ),
    );
  }
}

void removeFromCart(BuildContext context, CartProvider cartProvider,
    Map<String, dynamic> item) {
  cartProvider.removeFromCart(item);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Item removed from cart')),
  );
}
