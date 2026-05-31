class MealOrderResponse {
  final bool
      status;
  final String
      message;
  final String?
      membershipNo;
  final String?
      mealType;

  MealOrderResponse({
    required this.status,
    required this.message,
    this.membershipNo,
    this.mealType,
  });

  factory MealOrderResponse.fromJson(
      Map<String, dynamic> json) {
    final orderDetails =
        json['order_details'];

    return MealOrderResponse(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      membershipNo: orderDetails != null && orderDetails['event_register_member_id'] != null ? orderDetails['event_register_member_id'].toString() : null,
      mealType: orderDetails != null && orderDetails['meal_type'] != null ? orderDetails['meal_type'].toString() : null,
    );
  }
}
