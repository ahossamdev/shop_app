import 'dart:convert';
import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  Orders(this.authToken, this._orders, this.userId);
  List<OrderItem> _orders = [];
  final String userId;
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fechOrders() async {
    final url = Uri.parse(
      'https://flutter-update-fe608-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken',
    );
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title']))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
      'https://flutter-update-fe608-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken',
    );

    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'price': cartProduct.price,
                    'quantity': cartProduct.quantity,
                    'title': cartProduct.title,
                  })
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            dateTime: timeStamp,
            amount: total,
            products: cartProducts),
      );
      notifyListeners();
    } catch (err) {}
  }
}
