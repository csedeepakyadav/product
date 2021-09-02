import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:product/src/models/category_model.dart';
import 'package:product/src/repositories/product_repository.dart';

class ProductProvider with ChangeNotifier {

List<CategoryModel> categoryList = [];

List<CategoryModel> getCategoryListData() => categoryList;

ProductRepository productRepository = new ProductRepository();

Future<List<CategoryModel>> getCategories() async
{
   await productRepository.getCategoryList().then((res) {
       categoryList = res;
       notifyListeners();
   });
 return categoryList;
}
}
