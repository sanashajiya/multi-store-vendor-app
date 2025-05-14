import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vendor_app/global_variables.dart';
import 'package:vendor_app/models/order.dart';
import 'package:vendor_app/services/manage_http_response.dart';

class OrderController {
  
  // Method to GET Orders by vendorId
  Future<List<Order>> loadOrders({required String vendorId}) async {
    try {
      // Send an HTTP GET request to the orders by the buyerId
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/vendors/$vendorId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      // Check if the response status code is 200(OK)
      if (response.statusCode == 200) {
        // Parse the JSON response body into dynamic list
        // This convert the json data into a formate that can be further processed in dart
        List<dynamic> data = jsonDecode(response.body);        
        // Map the dynamic list  to list of Orders object using the fromJson factory method
        // this step converts the raw data into a list of orders instances, which are easier to work with in the application
        List<Order> orders = data.map((order) => Order.fromJson(order)).toList();
        // Return the list of orders
        return orders;
      }
      // If the response status code is not 200, throw an exception
      else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {      
      // If an error occurs, print the error message
      throw Exception('Error loading orders: $e');
    }
  }



   //delete order by ID
  Future<void> deleteOrder({required String id, required context}) async {
    try {
      // SharedPreferences preferences = await SharedPreferences.getInstance();
      // String? token = preferences.getString("auth_token");
      //send an HTTP Delete request to delete the order by _id
      http.Response response = await http.delete(
        Uri.parse("$uri/api/orders/$id"),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          // 'x-auth-token': token!,
        },
      );

      //handle the HTTP Response
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Order Deleted successfully');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }


   Future<void> updateDeliveryStatus(
      {required String id, required context}) async {
    try {
      // send an HTTP PUT request to the orders by the order ID
      http.Response response = await http.patch(
        Uri.parse('$uri/api/orders/$id/delivered'),
        body: jsonEncode({
          'delivered': true,
          'processing': false,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Order delivered successfully");
          });
    } catch (e) {
      throw Exception('Error updating delivery status: $e');
    }
  }

  Future<void> cancelOrder({required String id, required context}) async {
    try {
      // send an HTTP PUT request to the orders by the order ID
      http.Response response = await http.patch(
        Uri.parse('$uri/api/orders/$id/processing'),
        body: jsonEncode({
          'processing': false,
          'delivered': false,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Order Cancelled");
          });
    } catch (e) {
      throw Exception('Error updating delivery status: $e');
    }
  }
  
}
