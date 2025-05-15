import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_app/controllers/category_controller.dart';
import 'package:vendor_app/controllers/product_controller.dart';
import 'package:vendor_app/controllers/subcategory_controller.dart';
import 'package:vendor_app/models/category.dart';
import 'package:vendor_app/models/subcategory.dart';
import 'package:vendor_app/provider/vendor_provider.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();
  late Future<List<Category>> futureCategories;
  Future<List<Subcategory>>? futureSubcategories;
  Subcategory? selectedSubcategory;
  late String name;
  Category? selectedCategory;
  late String productName;
  late double productPrice;
  late int quantity;
  late String description;
  bool isLoading = false;
  @override
  void initState() {
    futureCategories = CategoryController().loadCategories();
    super.initState();
  }

  // Create an instance of image picker to undo image selection
  final ImagePicker picker = ImagePicker();

  // Initialize an empty list to store the selected images
  List<File> images = [];

  // Define a function to choose image from the gallery
  chooseImage() async {
    //Use the picker to select the image from the gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    //Check if not image was picked
    if (pickedFile == null) {
      print("No Image Picked");
    } else {
      //if an image was picked, update the state and add image to the list
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  getSubcategoryByCategory(value) {
    // fetch subcategories based on the selected category
    futureSubcategories =
        SubcategoryController().getSubcategoriesByCategoryName(value.name);
    // reset the selectedSubcategory
    selectedSubcategory = null;
  }

  @override
  Widget build(BuildContext context) {
    // final fullName
    return Center(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                  itemCount: images.length +
                      1, // the number of items in the grid (+1 for the add button)
                  shrinkWrap:
                      true, // Allow the gridview to shrink to fit the content

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    // if the index is 0. display an iconButton to add a new image
                    return index == 0
                        ? Center(
                            child: IconButton(
                                onPressed: () {
                                  chooseImage();
                                },
                                icon: Icon(Icons.add)),
                          )
                        : SizedBox(
                            width: 50,
                            height: 40,
                            child: Image.file(images[index - 1]),
                          );
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        onChanged: (value) {
                          productName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Product Name";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Enter Product Name',
                            hintText: 'Enter Product Name',
                            border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          productPrice = double.parse(value);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Product Price";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Enter Product Price',
                            hintText: 'Enter Product Price',
                            border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          quantity = int.parse(value);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Product Quantity";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Enter Product Quantity',
                            hintText: 'Enter Product Quantity',
                            border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 200,
                      child: FutureBuilder<List<Category>>(
                          future: futureCategories,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              final stacktrace = snapshot.stackTrace;
                              print("📍 StackTrace: $stacktrace");
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                child: Text("No Category"),
                              );
                            } else {
                              return DropdownButton<Category>(
                                  value: selectedCategory,
                                  hint: Text('Select Category'),
                                  items:
                                      snapshot.data!.map((Category category) {
                                    return DropdownMenuItem(
                                      value: category,
                                      child: Text(category.name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = value;
                                    });
                                    getSubcategoryByCategory(selectedCategory);
                                    // print(selectedCategory!.name);
                                  });
                            }
                          }),
                    ),
                    SizedBox(
                      width: 200,
                      child: FutureBuilder<List<Subcategory>>(
                          future: futureSubcategories,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              final stacktrace = snapshot.stackTrace;
                              print("📍 StackTrace: $stacktrace");
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                child: Text("No Category"),
                              );
                            } else {
                              return DropdownButton<Subcategory>(
                                  value: selectedSubcategory,
                                  hint: Text('Select SubCategory'),
                                  items: snapshot.data!
                                      .map((Subcategory subcategory) {
                                    return DropdownMenuItem(
                                      value: subcategory,
                                      child: Text(subcategory.subCategoryName),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedSubcategory = value;
                                    });
                                    // getSubcategoryByCategory(selectedCategory);
                                    // print(selectedCategory!.name);
                                  });
                            }
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onChanged: (value) {
                          description = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Product Description";
                          } else {
                            return null;
                          }
                        },
                        maxLines: 3,
                        maxLength: 500,
                        decoration: InputDecoration(
                            labelText: 'Enter Product Description',
                            hintText: 'Enter Product Description',
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    final fullName = ref.read(vendorProvider)!.username;
                    final vendorId = ref.read(vendorProvider)!.id;
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      if (selectedCategory == null ||
                          selectedSubcategory == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Please select both Category and Subcategory")),
                        );
                        return;
                      }

                    await  _productController.uploadProduct(
                        productName: productName,
                        productPrice: productPrice,
                        quantity: quantity,
                        description: description,
                        category: selectedCategory!.name,
                        vendorId: vendorId,
                        fullName: fullName,
                        subCategory: selectedSubcategory!.subCategoryName,
                        pickedImages: images,
                        context: context,
                      ).whenComplete((){
                        setState(() {
                        isLoading = false;
                      });
                      selectedCategory = null;
                      selectedSubcategory = null;
                      images.clear();
                      });
                      
                     
                      print('Uploaded');
                    } else {
                      print("Please enter all the fields");
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Center(
                            child: Text(
                              "Upload Product",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                letterSpacing: 1.7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
