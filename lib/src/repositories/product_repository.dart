import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:product/src/constants/api_constants.dart';
import 'package:product/src/models/category_model.dart';
import 'package:product/src/models/save_user_response_model.dart';

class ProductRepository {
  Dio _dio = new Dio();

  Future<SaveUserResponseModel> saveProduct({
    @required String? categoryId,
    @required String? name,
    @required String? desc,
    @required String? expiry,
    @required List<String>? imagesPathList,
  }) async {
    SaveUserResponseModel responseModel;
    var formData = FormData.fromMap({
      'category_id': categoryId,
      'name': name,
      'desc': desc,
      'expiry': expiry,
      'product_image': [
        [
          for (var image in imagesPathList!)
            {
              await MultipartFile.fromFile(File(image).path,
                  filename: File(image).path.split('/').last)
            }.toList()
        ]
      ]
    });
    try {
      var response = await _dio.post('$baseUrl/save_user.php', data: formData);
    //  print(response);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.data);
        if (data["status"] == "success") {
          responseModel = SaveUserResponseModel(
              status: data["status"], message: data["message"]);
          return responseModel;
        } else {
          responseModel = SaveUserResponseModel(
              status: data["status"], message: data["message"]);
          return responseModel;
        }
      } else {
        {
          responseModel = SaveUserResponseModel(
              status: "failed",
              message: "some error occured, Please try again later 1");
          return responseModel;
        }
      }
    } catch (e) {
      responseModel = SaveUserResponseModel(
          status: "failed",
          message: "some error occured, Please try again later 2");
      return responseModel;
    }
  }

  Future<List<CategoryModel>> getCategoryList() async {
    List<CategoryModel> categoryList = [];

    try {
      var response = await _dio.get(
        '$baseUrl/get_categories.php',
      );
      //   print(response);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.data);
        if (data["status"] == "success") {
          for (var item in data["categories"]) {
            CategoryModel categoryModel = new CategoryModel.fromJson(item);
            categoryList.add(categoryModel);
          }
        }
      }
      return categoryList;
    } catch (e) {
      return categoryList;
    }
  }
}
