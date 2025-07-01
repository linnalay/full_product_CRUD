import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductApiService {
 final String _baseUrl = "http://10.0.2.2:5000/products";

  Future<List<ProductModel>> getProductList() async {
    try {
      http.Response response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        return compute(productModelFromJson, response.body);
      } else {
        throw Exception(
            "Error during getting: ${response.statusCode} and ${response.body}");
      }
    } catch (e) {
      throw Exception("Network Error during getting: $e");
    }
  }

  Future<bool> insert(ProductModel item) async {
    try {
      final body = jsonEncode(item.toJson());
      debugPrint("Sending JSON body: $body");

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body,
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            "Error during inserting: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Network Error during inserting: $e");
    }
  }

  Future<bool> update(ProductModel item) async {
    final url = "$_baseUrl?id=${item.productid}";
    try {
      http.Response response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(item.toJson()),
      );
      if (response.statusCode == 200) {
        debugPrint("during updating response.body: ${response.body}");
        return true;
      } else {
        throw Exception(
            "Error during updating: ${response.statusCode} and ${response.body}");
      }
    } catch (e) {
      throw Exception("Network Error during updating: $e");
    }
  }

  Future<bool> delete(int id) async {
    final url = "$_baseUrl?id=$id";
    try {
      http.Response response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        debugPrint("Deleted: ${response.body}");
        return true;
      } else {
        throw Exception("Failed to delete: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}