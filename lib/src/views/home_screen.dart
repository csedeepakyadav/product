import 'dart:collection';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:product/src/constants/constants.dart';
import 'package:product/src/models/category_model.dart';
import 'package:product/src/providers/connectivity_provider.dart';
import 'package:product/src/providers/product_provider.dart';
import 'package:product/src/repositories/product_repository.dart';
import 'package:product/src/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _expiry = TextEditingController();
  String productExpiry = "";
  TextEditingController _description = TextEditingController();

  List<PlatformFile>? _paths;
  List<String> imagePaths = [];
  String selectedCategoryId = "";

  ProductRepository productRepository = new ProductRepository();

  _getImages() async {
    List<String> pickedImagePaths = [];
    try {
      _paths = (await FilePicker.platform.pickFiles(
        allowCompression: true,
        type: FileType.image,
        allowMultiple: true,
      ))!
          .files;

      for (var item in _paths!) {
        pickedImagePaths.add(item.path);
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      if (ex.toString().contains("The getter 'files' was called on null")) {}
    }
    return pickedImagePaths;
  }

  Future _onSelectionChanged(DateRangePickerSelectionChangedArgs args) async {
    setState(() {
      if (args.value is DateTime) {
        var formatter = new DateFormat('dd/MM/yyyy');
        _expiry.text = formatter.format(args.value).toString();
        productExpiry = formatter.format(args.value).toString();
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  getCategoryData() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    if (productProvider.getCategoryListData().length == 0) {
      productProvider.getCategories().then((res) {
        print(res.length);
        //      categoryList = res;
        isLoading = false;
      });
    } else {
      //  categoryList = productProvider.getCategoryListData();
      isLoading = false;
    }
  }

  @override
  void initState() {
    getCategoryData();
    // print(categoryList.length);
    super.initState();
  }

  //List<CategoryModel> categoryList = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var width = SizeConfig.screenWidth;
    var height = SizeConfig.screenHeight;
    final productProvider = Provider.of<ProductProvider>(context, listen: true);

    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Add Product",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Container(
              width: width,
              height: height,
              child: ListView(
                children: [
                  SizedBox(
                    height: height! * 0.025,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: width! * 0.05),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: DropdownButtonFormField(
                                items: productProvider
                                    .getCategoryListData()
                                    .map((CategoryModel? category) {
                                  return new DropdownMenuItem(
                                      value: category,
                                      child: Row(
                                        children: <Widget>[
                                          Text(category!.name!),
                                        ],
                                      ));
                                }).toList(),
                                onChanged: (CategoryModel? cat) {
                                  setState(() {
                                    selectedCategoryId = cat!.id!;
                                  });
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF2F2F2),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                      borderSide: BorderSide(
                                          width: 1, color: primaryBlue)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: primaryBlue,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                      borderSide: BorderSide(
                                          width: 1, color: primaryBlue)),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: "Select Category",
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFB3B1B1),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'First Name is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              width: width,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name"),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Container(
                                    width: width,
                                    child: TextFormField(
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        letterSpacing: 1.5,
                                      ),
                                      decoration: InputDecoration(
                                        //  prefixIcon: Icon(FontAwesomeIcons.envelope, size: 20),

                                        filled: true,
                                        fillColor: Color(0xFFF2F2F2),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                            borderSide: BorderSide(
                                                width: 1, color: primaryBlue)),

                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: primaryBlue,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                            borderSide: BorderSide(
                                                width: 1, color: primaryBlue)),

                                        isDense: true,
                                        contentPadding: EdgeInsets.all(10),
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFB3B1B1),
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Product Name is required';
                                        }
                                        return null;
                                      },
                                      controller: _name,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              width: width,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Product Description"),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Container(
                                    width: width,
                                    child: TextFormField(
                                      maxLines: 5,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        letterSpacing: 1.5,
                                      ),
                                      decoration: InputDecoration(
                                        //  prefixIcon: Icon(FontAwesomeIcons.envelope, size: 20),

                                        filled: true,
                                        fillColor: Color(0xFFF2F2F2),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                            borderSide: BorderSide(
                                                width: 1, color: primaryBlue)),

                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: primaryBlue,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                            borderSide: BorderSide(
                                                width: 1, color: primaryBlue)),

                                        isDense: true,
                                        contentPadding: EdgeInsets.all(10),
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFB3B1B1),
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Description  is required';
                                        }
                                        return null;
                                      },
                                      controller: _description,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              width: width,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Expiry"),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: this.context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors.blue,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)), //this right here
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: height * 0.6,
                                                    width: width * 0.85,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: SfDateRangePicker(
                                                        onSelectionChanged:
                                                            (_) {
                                                          _onSelectionChanged(_)
                                                              .then((value) {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        selectionMode:
                                                            DateRangePickerSelectionMode
                                                                .single,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      right: 0,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Card(
                                                          shape: CircleBorder(),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Icon(
                                                                Icons.close),
                                                          ),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      width: width,
                                      child: TextFormField(
                                        enabled: false,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          letterSpacing: 1.5,
                                        ),
                                        decoration: InputDecoration(
                                          //  prefixIcon: Icon(FontAwesomeIcons.envelope, size: 20),

                                          filled: true,
                                          fillColor: Color(0xFFF2F2F2),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: primaryBlue)),

                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                            borderSide: BorderSide(
                                              width: 1,
                                              color: primaryBlue,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: primaryBlue)),
                                          suffixIcon: GestureDetector(
                                            onTap: () {},
                                            child: Icon(
                                              Icons.calendar_today,
                                              color: Colors.blue,
                                            ),
                                          ),

                                          isDense: true,
                                          contentPadding: EdgeInsets.all(10),
                                          //    hintText: "02/09/2021",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFFB3B1B1),
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        /*  validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Expiry date is required';
                                          }
                                          return null;
                                        }, */
                                        controller: _expiry,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Product Images"),
                                      imagePaths.length != 0
                                          ? Container(
                                              child: MaterialButton(
                                                  height: 30,
                                                  //minWidth: SizeConfig.screenWidth * 0.6,
                                                  clipBehavior: Clip.antiAlias,
                                                  color: Colors.blue,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadiusDirectional
                                                              .circular(8.0)),
                                                  onPressed: () {
                                                    if (mounted) {
                                                      _getImages().then(
                                                          (finalImageList) async {
                                                        if (finalImageList
                                                                .length !=
                                                            0) {
                                                          for (var item
                                                              in finalImageList) {
                                                            imagePaths
                                                                .add(item);
                                                          }

                                                          setState(() {});
                                                        }
                                                      });
                                                    }
                                                  },
                                                  child: Text('Add More Images',
                                                      style: TextStyle(
                                                        letterSpacing: 2,
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ))),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                imagePaths.length != 0
                                    ? Container(
                                        width: width,
                                        height: height * 0.1,
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: imagePaths.length,
                                            itemBuilder: (context, i) {
                                              return Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(5),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                height: height * 0.1,
                                                width: height * 0.1,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                  color: Colors.blue,
                                                )),
                                                child: Stack(
                                                  children: [
                                                    Image.file(
                                                      File(
                                                        imagePaths[i],
                                                      ),
                                                      height: height * 0.2,
                                                      width: height * 0.2,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if (mounted) {
                                                            imagePaths.removeWhere(
                                                                (item) =>
                                                                    item ==
                                                                    imagePaths[
                                                                        i]);
                                                            setState(() {});
                                                          }
                                                        },
                                                        child: Card(
                                                          elevation: 2,
                                                          shape: CircleBorder(),
                                                          color: Colors.black,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1.0),
                                                            child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                              size: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }))
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              height: height * 0.15,
                                              width: height * 0.25,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      height: height * 0.2,
                                                      width: height * 0.2,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                        color: Colors.blue,
                                                      )),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height:
                                                                height * 0.02,
                                                          ),
                                                          Icon(
                                                            Icons.image,
                                                            size: 30,
                                                            color: Colors.blue,
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child:
                                                                MaterialButton(
                                                                    height: 30,
                                                                    //minWidth: SizeConfig.screenWidth * 0.6,
                                                                    clipBehavior:
                                                                        Clip
                                                                            .antiAlias,
                                                                    color: Colors
                                                                        .blue,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadiusDirectional.circular(
                                                                                4.0)),
                                                                    onPressed:
                                                                        () {
                                                                      if (mounted) {
                                                                        _getImages()
                                                                            .then((newImages) {
                                                                          if (newImages.length !=
                                                                              0) {
                                                                            imagePaths.addAll(newImages);
                                                                            List<String>
                                                                                result =
                                                                                LinkedHashSet<String>.from(imagePaths).toList();
                                                                            imagePaths =
                                                                                result;
                                                                            setState(() {});
                                                                          }
                                                                        });
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                        'select Image',
                                                                        style:
                                                                            TextStyle(
                                                                          letterSpacing:
                                                                              2,
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              10,
                                                                        ))),
                                                          ),
                                                        ],
                                                      )),
                                                ],
                                              )),
                                        ],
                                      ),
                              ],
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: height * 0.07,
                  ),
                  Container(
                    height: height * 0.1,
                    width: width,
                    margin: EdgeInsets.symmetric(horizontal: width * 0.065),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              if (productExpiry == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Expiry is required")));
                              } else if (imagePaths.length == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "At least one image required")));
                              } else {
                                connectivityProvider
                                    .checkInternet()
                                    .then((hasInternet) async {
                                  if (hasInternet) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    await productRepository
                                        .saveProduct(
                                            categoryId: selectedCategoryId,
                                            name: _name.text,
                                            desc: _description.text,
                                            expiry: _expiry.text,
                                            imagesPathList: imagePaths)
                                        .then((res) {
                                      if (res.status == "success") {
                                        setState(() {
                                          selectedCategoryId = "";
                                          _name.text = "";
                                          _description.text = "";
                                          _expiry.text = "";
                                          imagePaths = [];
                                          isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text(res.message.toString())),
                                        );
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text(res.message.toString())),
                                        );
                                      }
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                      "No internet connectivity found",
                                    )));
                                  }
                                });
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: height * 0.05),
                            height: 40,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.15),
                            decoration: BoxDecoration(
                                gradient: buttonBgGradient,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 3,
                                      color: Colors.grey,
                                      offset: Offset(0, 2),
                                      spreadRadius: 2)
                                ]),
                            child: Center(
                                child: Text(
                              "Save",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? Container(
                    width: width,
                    height: height,
                    color: Colors.grey.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
