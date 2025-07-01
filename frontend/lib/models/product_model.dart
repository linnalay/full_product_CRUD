// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  int productid;
  String productname;
  double price;
  int stock;

  ProductModel({
    required this.productid,
    required this.productname,
    required this.price,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productid: json["PRODUCTID"],
        productname: json["PRODUCTNAME"],
        price: json["PRICE"].toDouble(),
        stock: json["STOCK"],
      );

  Map<String, dynamic> toJson() {
    return {
      'productname': productname,
      'price': price,
      'stock': stock,
    };
  }
}
