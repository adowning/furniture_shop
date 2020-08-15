import 'package:app/global.dart';

import 'package:meta/meta.dart';

class User {
  String jwt,
      username,
      email,
      id,
      cartId,
      stripeId,
      companyName,
      personName,
      empCode,
      avatarUrl;
  User({
    @required this.email,
    @required this.id,
    @required this.jwt,
    @required this.username,
    @required this.cartId,
    @required this.stripeId,
    @required this.companyName,
    @required this.personName,
    @required this.empCode,
    @required this.avatarUrl,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        id: json['_id'],
        username: json['username'],
        cartId: json['cart_id'],
        stripeId: json['stripe_id'],
        stripeId: json['companyName'],
        stripeId: json['personName'],
        stripeId: json['empCode'],
        jwt: json['jwt'],
        avatarUrl: "$baseServerUrl${json['avatar']['url']}");
  }
}
// class Category {
//   final String name, iconUrl;
//   final int id;

//   Category({this.id, this.name, this.iconUrl});

//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: json['id'],
//       iconUrl: "$baseServerUrl${json['icon']['url']}",
//       name: json['name'],
//     );
//   }
// }
