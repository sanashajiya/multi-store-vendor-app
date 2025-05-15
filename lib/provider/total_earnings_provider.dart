
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/models/order.dart';
// A Class that extends StateNotifier to manage the state of total earnings

class TotalEarningsProvider extends StateNotifier<Map<String, dynamic>> {
  // Constructor that initializes the state to 0.0(Starting total earnings)
  TotalEarningsProvider() : super({'totalEarnings': 0.0, 'totalOrders': 0});
  

  // A method to calculate the total earnings based on the delivered status
  void calculateEarnings(List<Order> orders) {
    //initalize a local variable to accumulate earnings
    double earnings = 0.0;
    int orderCount = 0;
    //Loop through each orders in the list of orders
    for(Order order in orders){
      // Check if the order has been delivered
      if(order.delivered){
        orderCount++;
        earnings += order.productPrice*order.quantity;
    }

    // update the state with the calculated earnings , which will notifier listeners of this state
    state = {
      'totalEarnings': earnings,
      'totalOrders': orderCount,
    };
  }
  
}}


final totalEarningsProvider = StateNotifierProvider<TotalEarningsProvider,Map<String, dynamic>>(
  (ref) => TotalEarningsProvider(),
);
