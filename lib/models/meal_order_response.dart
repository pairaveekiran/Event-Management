class MealOrderResponse {
  final bool
      status;
  final String
      message;
  final String?
      userName;
  final String?
      drinksCount;
  final String?
      membershipNo;
  final String?
      mealType;

  MealOrderResponse({
    required this.status,
    required this.message,
    this.userName,
    this.drinksCount,
    this.membershipNo,
    this.mealType,
  });

  factory MealOrderResponse.fromJson(
      Map<String, dynamic> json) {
    final orderDetails =
        json['order_details'];
    final mealOrdered =
        json['mealOrdered'];
    final dynamic userInfo = json['userInfo'] ??
        (orderDetails is Map ? orderDetails['userInfo'] : null) ??
        (mealOrdered is Map ? mealOrdered['userInfo'] : null);
    final dynamic drinksCountValue = json['drinks_count'] ??
        (orderDetails is Map ? orderDetails['drinks_count'] : null) ??
        (mealOrdered is Map ? mealOrdered['drinks_count'] : null);

    return MealOrderResponse(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      userName: userInfo is Map && userInfo['name'] != null ? userInfo['name'].toString() : null,
      drinksCount: drinksCountValue?.toString(),
      membershipNo: orderDetails != null && orderDetails['event_register_member_id'] != null ? orderDetails['event_register_member_id'].toString() : null,
      mealType: orderDetails != null && orderDetails['meal_type'] != null ? orderDetails['meal_type'].toString() : null,
    );
  }
}
