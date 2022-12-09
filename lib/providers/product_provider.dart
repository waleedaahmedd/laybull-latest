// ignore_for_file: equal_keys_in_map, iterable_contains_unrelated_type

import 'dart:developer';
import 'dart:io' as io;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:laybull_v3/globals.dart';
import 'package:laybull_v3/locale/app_localization.dart';
import 'package:laybull_v3/models/brand_model.dart';
import 'package:laybull_v3/models/categories_detail_model.dart';
import 'package:laybull_v3/models/categories_model.dart';
import 'package:laybull_v3/models/color_model.dart';
import 'package:laybull_v3/models/dashboard_model.dart';
import 'package:laybull_v3/models/home_category_model.dart';
import 'package:laybull_v3/models/image_model.dart';
import 'package:laybull_v3/models/product_detail_model.dart';
import 'package:laybull_v3/models/products_model.dart';
import 'package:laybull_v3/models/size_list_model.dart';
import 'package:laybull_v3/providers/bidding_provider.dart';
import 'package:laybull_v3/providers/currency_provider.dart';
import 'package:laybull_v3/screens/category_products.dart';
import 'package:laybull_v3/screens/home_product_view_all_screen.dart';
import 'package:laybull_v3/screens/product_detail_screen.dart';
import 'package:laybull_v3/util_services/http_service.dart';
import 'package:laybull_v3/extensions.dart';
import 'package:laybull_v3/util_services/service_locator.dart';
import 'package:laybull_v3/util_services/utilservices.dart';
import 'package:laybull_v3/widgets/myCustomProgressDialog.dart';
import 'package:image_picker/image_picker.dart' as img;
import 'package:provider/provider.dart';

class ProductProvider with ChangeNotifier {
  DashboardModel? homeData;
  ProductDetail? productDetail;
  MyProgressDialog? pr;
  List<ProductsModel> favoriteProducts = [];
  CategoryDetail? categoryDetail;
  List<CategoriesModel> categories = [];
  List<CategoriesModel> homeSlider = [];
  List<Brand> brands = [];
  List<SlideSizeClass> sizes = [];
  List<ProductsModel> searchedProducts = [];
  img.ImagePicker obj = img.ImagePicker();
  List<HomeCategoryModel>? homeAllProductList = [];
  List<Map<String, int>> changeImagesVar = [];
  Brand? selectedBrand;
  var http = locator<HttpService>();
  var utilService = locator<UtilService>();
  CategoriesModel? selectedCategory;
  List<ProductDetailImageClass> networkImages = [];

  double filedHeight = 40.0;
  TextEditingController prodName = TextEditingController();
  TextEditingController prodPrice = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final TextEditingController bidController = TextEditingController();

  String selectedCondition = "";

  SlideSizeClass? selectedSize;
  ColorClass? selectedColor;

  bool isBidding = false;
  bool isFetchingProducts = false;
  bool isCategory = false;
  bool ispaginationDataLoading = false;
  bool isAddingProduct = false;
  bool isSearching = false;
  bool isFetchingViewAll = false;

  int categorySelected = 1;

  setProductCategory(int cId) {
    categorySelected = cId;
    notifyListeners();
  }

  List<String> imageFrameTextList = ['Appearance', 'Front', 'Left Shot', 'Right Shot', 'Back Shot', 'Box Label', 'Extras', 'Other'];

  List<String> listCondition = <String>[
    "Select Condition",
    "New",
    "Used",
    "Lightly Used",
    "Semi Used",
    "Very Used",
  ];
  List<io.File>? changedImages = [];
  List<io.File>? newImages = [];
  List<MultipartFile>? changeFilesData = [];
  List<MultipartFile>? newFilesData = [];

  Future clearAddProductFormData() async {
    prodName.text = '';
    prodPrice.text = '';
    selectedBrand = null;
    selectedCategory = null;
    selectedCondition = '';
    selectedColor = null;
    selectedSize = null;
    sizes = [];
    descriptionController.text = '';
    changedImages!.clear();
    newImages!.clear();
    changeFilesData!.clear();
    newFilesData!.clear();

    imgeFiles = [
      ImageClass(isPicked: false, image: null),
      ImageClass(isPicked: false, image: null),
      ImageClass(isPicked: false, image: null),
      ImageClass(isPicked: false, image: null),
      ImageClass(isPicked: false, image: null),
      ImageClass(isPicked: false, image: null),
      ImageClass(isPicked: false, image: null),
      ImageClass(isPicked: false, image: null),
    ];
    notifyListeners();
  }

  List<ImageClass> imgeFiles = [
    ImageClass(isPicked: false, image: null),
    ImageClass(isPicked: false, image: null),
    ImageClass(isPicked: false, image: null),
    ImageClass(isPicked: false, image: null),
    ImageClass(isPicked: false, image: null),
    ImageClass(isPicked: false, image: null),
    ImageClass(isPicked: false, image: null),
    ImageClass(isPicked: false, image: null),
  ];

  List<String> get listCond => listCondition;

  clearData() {
    homeData = null;
    productDetail = null;
    favoriteProducts = [];
    categoryDetail = null;
    homeAllProductList = [];
    networkImages = [];
    homeSlider = [];
    changeImagesVar = [];
    selectedBrand = null;
    changeImagesVar.clear();
    changeFilesData!.clear();
    changedImages!.clear();
    newImages!.clear();
    newFilesData!.clear();
    selectedSize = null;
    categories = [];
    bidController.clear();
    descriptionController.clear();
    brands = [];
    sizes = [];
    isBidding = false;
    isFetchingProducts = false;
    isCategory = false;
    searchedProducts = [];
    ispaginationDataLoading = false;
    isSearching = false;
    isAddingProduct = false;
    isFetchingViewAll = false;
    imgeFiles = [
      ImageClass(isPicked: false, image: null),
      ImageClass(isPicked: false, image: null),
      ImageClass(isPicked: false, image: null),
      ImageClass(isPicked: false, image: null),
      ImageClass(isPicked: false, image: null),
      ImageClass(isPicked: false, image: null),
      ImageClass(isPicked: false, image: null),
      ImageClass(isPicked: false, image: null),
    ];
    notifyListeners();
  }

  getHomeSlider() async {
    try {
      var response = await http.getSlider();
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        homeSlider.clear();
        for (int i = 0; i < response.data['data'].length; i++) {
          homeSlider.add(
            CategoriesModel(
              id: response.data['data'][i]['id'],
              image: response.data['data'][i]['img_url'],
              name: response.data['data'][i]['title'],
              description: response.data['data'][i]['description'],
              category_to_redirect: response.data['data'][i]['category_to_redirect'],
            ),
          );
        }
      }
      notifyListeners();
    } catch (err) {
      utilService.showToast('Internal Server Error', ToastGravity.BOTTOM);
      if (kDebugMode) {
        print(err);
      }
    }
    notifyListeners();
  }

  deleteProduct(int id, BuildContext context) async {
    try {
      var response = await http.deleteProduct(id);
      if (response.data['status'] == 'success') {
        utilService.showToast('Product deleted Successfully', ToastGravity.BOTTOM);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  getCategoriesAndBrand() async {
    try {
      var response = await http.getCategoriesAndBrand();
      if (response.data['status'] == 'success') {
        if (response.data['data']['brand'] != null) {
          brands.clear();
          notifyListeners();
          for (int i = 0; i < response.data['data']['brand'].length; i++) {
            brands.add(Brand(
              name: response.data['data']['brand'][i]['name'] ?? '',
              image: response.data['data']['brand'][i]['image'] ?? '',
              isSelected: false,
              id: response.data['data']['brand'][i]['id'] ?? 0,
            ));
          }
        }
        if (response.data['data']['category'] != null) {
          categories.clear();
          notifyListeners();
          for (int i = 0; i < response.data['data']['category'].length; i++) {
            categories.add(
              CategoriesModel(
                id: response.data['data']['category'][i]['id'] ?? 0,
                name: response.data['data']['category'][i]['name'] ?? '',
                image: response.data['data']['category'][i]['image'] ?? '',
              ),
            );
          }
        }
        // selectedCategory = categories[0];
        // await getSizes(categories[0].id!);
        notifyListeners();
      } else {
        utilService.showToast(response.data['message'], ToastGravity.CENTER);
      }
    } catch (err) {
      rethrow;
    }
    notifyListeners();
  }

  getSizes(int id) async {
    try {
      var response = await http.getSizesOfCategories(id);
      if (response.data['data'] != null && response.data['data'].length > 0) {
        sizes.clear();
        if (kDebugMode) {
          print(response.data['data'].length);
        }
        for (int i = 0; i < response.data['data'].length; i++) {
          sizes.add(
            SlideSizeClass(
              id: response.data['data'][i]['id'],
              size: response.data['data'][i]['text'],
              isSelected: false,
            ),
          );
          notifyListeners();
        }
        notifyListeners();
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    notifyListeners();
  }

  getHomeProducts() async {
    try {
      var response = await http.homeProducts();

      if (response.data['categories'].length > 0) {
        homeData = null;
        homeData = DashboardModel.fromJson(response.data);
      } else {
        utilService.showToast('No Data Found', ToastGravity.BOTTOM);
      }

      if (kDebugMode) {
        print(homeData);
      }
    } catch (err) {
      utilService.showToast('Internal Server Error', ToastGravity.BOTTOM);
      if (kDebugMode) {
        print(err);
      }
    }
    notifyListeners();
  }

  getGuestHomeProducts() async {
    try {
      var response = await http.homeGuestProducts();

      if (response.data['categories'].length > 0) {
        homeData = null;
        homeData = DashboardModel.fromJson(response.data);
      } else {
        utilService.showToast('No Data Found', ToastGravity.BOTTOM);
      }

      if (kDebugMode) {
        print(homeData);
      }
    } catch (err) {
      utilService.showToast('Internal Server Error', ToastGravity.BOTTOM);
      if (kDebugMode) {
        print(err);
      }
    }
    notifyListeners();
  }

  getProductDetail(
      int id,
      BuildContext context,
      bool fromBid,
      ) async {
    try {
      if (fromBid == false) {
        productDetail = null;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ProductDetailScreen(),
          ),
        );
      }
      var response = await http.productDetail(id);
      if (response.data['data']['id'] != null) {
        productDetail = null;
        productDetail = ProductDetail.fromJson(response.data['data']);
        // pr = MyProgressDialog(context);
        // pr!.hide();

      }
    } catch (err) {
      if (kDebugMode) {
        // pr = MyProgressDialog(context);
        // pr!.hide();
        print(err);
      }
    }
    notifyListeners();
  }

  getGuestProductDetail(
      int id,
      BuildContext context,
      bool fromBid,
      ) async {
    try {
      if (fromBid == false) {
        productDetail = null;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ProductDetailScreen(),
          ),
        );
      }
      var response = await http.productGuestDetail(id);
      if (response.data['data']['id'] != null) {
        productDetail = null;
        productDetail = ProductDetail.fromJson(response.data['data']);
        notifyListeners();
        // pr = MyProgressDialog(context);
        // pr!.hide();

      }
    } catch (err) {
      if (kDebugMode) {
        // pr = MyProgressDialog(context);
        // pr!.hide();
        print(err);
      }
    }
    notifyListeners();
  }

  getCategoryDetail(int id, BuildContext context) async {
    try {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const CategoryProducts()));
      categoryDetail = null;
      var response = await http.getCategoryDetail(id);
      if (response.data['data']['id'] != null) {
        categoryDetail = CategoryDetail.fromJson(response.data['data']);
        // pr = MyProgressDialog(context);
        // pr!.hide();

      }
    } catch (err) {
      // pr = MyProgressDialog(context);
      // pr!.hide();
      if (kDebugMode) {
        print(err);
      }
    }
    notifyListeners();
  }

  addToFavoriteProducts(int id) async {
    try {
      var response = await http.setFavoriteProducts(id);

      if (response.data['status'] == 'success') {
        utilService.showToast(response.data['message'], ToastGravity.BOTTOM);
        await getFavoriteProducts();
        await getHomeProducts();
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    notifyListeners();
  }

  removingFromFavLocall(int id) {
    favoriteProducts.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  addingIntoFavLocall(ProductsModel product) {
    if (!favoriteProducts.contains(product.id)) {
      favoriteProducts.add(product);
    }

    notifyListeners();
  }

  removeFromFavoriteProducts(int id) async {
    try {
      var response = await http.removeFavoriteProduct(id);
      if (response.data['status'] == 'success') {
        favoriteProducts.removeWhere((element) => element.id == id);
        await getFavoriteProducts();
        await getHomeProducts();
        utilService.showToast(response.data['message'], ToastGravity.BOTTOM);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    notifyListeners();
  }

  getFavoriteProducts() async {
    try {
      isFetchingProducts = true;
      var response = await http.getFavoriteProducts();
      if (response.statusCode == 200) {
        favoriteProducts.clear();
        favoriteProducts = [];
        notifyListeners();

        for (int i = 0; i < response.data['data'].length; i++) {
          favoriteProducts.add(ProductsModel.fromJson(response.data['data'][i]));
        }
        notifyListeners();
      }
      if (response.statusCode == 501) {
        utilService.showToast('Internal Server Error', ToastGravity.CENTER);
      }
      isFetchingProducts = false;
    } catch (err) {
      isFetchingProducts = false;
      if (kDebugMode) {
        print(err);
      }
    }
    notifyListeners();
  }

  imgFromCamera(int index, bool fromedit) async {
    img.XFile? image = await obj.pickImage(
      source: img.ImageSource.camera,
    ) as img.XFile;
    if (image != null) {
      /// Image Compression
      imgeFiles[index].image = await utilService.imageCompression(io.File(image.path));
      imgeFiles[index].isPicked = true;
      // if (fromedit == true) {
      //   if (index < productDetail!.images!.length) {
      //     if (changeImagesVar
      //             .contains((element) => element['ui_id'] == index) ==
      //         false) {
      //       changeImagesVar.add({
      //         'product_id': productDetail!.images![index].id!,
      //         'ui_id': index,
      //       });
      //     }
      //   }
      // }
      if (fromedit == true) {
        if (index < productDetail!.images!.length) {
          if (changeImagesVar.any((element) => element.values.contains(index)) == false) {
            changeImagesVar.add({
              'product_id': productDetail!.images![index].id!,
              'ui_id': index,
            });
          }
          if (!changedImages!.contains(imgeFiles[index].image!)) {
            changedImages!.add(imgeFiles[index].image!);
          }
        } else {
          if (!newImages!.contains(imgeFiles[index].image!)) {
            newImages!.add(imgeFiles[index].image!);
          }
        }
      }
    }
    notifyListeners();
  }

  imgFromGallery(File productImage, int index, bool fromedit) async {
    // img.XFile image = await obj.pickImage(
    //   source: img.ImageSource.gallery,
    // ) as img.XFile;

    /// Image Compression
    imgeFiles[index].image = await utilService.imageCompression(productImage);
    imgeFiles[index].isPicked = true;
    if (fromedit == true) {
      if (index < productDetail!.images!.length) {
        if (changeImagesVar.any((element) => element.values.contains(index)) == false) {
          changeImagesVar.add({
            'product_id': productDetail!.images![index].id!,
            'ui_id': index,
          });
        }
        if (!changedImages!.contains(imgeFiles[index].image!)) {
          changedImages!.add(imgeFiles[index].image!);
        }
      } else {
        if (!newImages!.contains(imgeFiles[index].image!)) {
          newImages!.add(imgeFiles[index].image!);
        }
      }
    }

    notifyListeners();
  }

  updateProduct(ProductsModel updatedProduct, BuildContext context) async {
    try {
      isAddingProduct = true;
      notifyListeners();

      changeFilesData = [];
      if (changedImages!.isNotEmpty) {
        for (int i = 0; i < changedImages!.length; i++) {
          changeFilesData!.add(await MultipartFile.fromFile(
            changedImages![i].path,
            filename: changedImages![i].path.split('/').last,
          ));
        }
      }
      newFilesData = [];
      if (newImages!.isNotEmpty) {
        for (int i = 0; i < newImages!.length; i++) {
          newFilesData!.add(await MultipartFile.fromFile(
            newImages![i].path,
            filename: newImages![i].path.split('/').last,
          ));
        }
      }
      List<int> changeImagesIds = [];
      if (changeImagesVar.isNotEmpty) {
        for (int i = 0; i < changeImagesVar.length; i++) {
          changeImagesIds.add(changeImagesVar[i]['product_id']!);
        }
      }
      FormData data = FormData.fromMap({
        'category_id': updatedProduct.category_id,
        'brand_id': updatedProduct.brand_id,
        'name': updatedProduct.name,
        if (changeFilesData!.isNotEmpty) 'change_image[]': changeFilesData!,
        if (newFilesData!.isNotEmpty) 'new_image[]': newFilesData!,
        if (changeImagesIds.isNotEmpty) 'image_id[]': changeImagesIds,
        'price': updatedProduct.price!,
        'description': updatedProduct.description,
        if (imgeFiles[0].isPicked == true && imgeFiles[0].image != null)
          'feature_image': await MultipartFile.fromFile(
            imgeFiles[0].image!.path,
            filename: imgeFiles[0].image!.path.split('/').last,
          ),
        'color': updatedProduct.color,
        'size_id': updatedProduct.size_id,
        'condition': updatedProduct.condition,
        // 'sold': updatedProduct.sold,
      });
      var response = await http.updateProduct(data, updatedProduct.id!);
      if (response.data['status'] == 'success') {
        //  utilService.showToast(response.data['message'], ToastGravity.BOTTOM);

        await getProductDetail(updatedProduct.id!, context, true);

        isAddingProduct = false;
        notifyListeners();
        // Navigator.of(context).pop();
        // }

        if (kDebugMode) {
          // pr = MyProgressDialog(context);
          // pr!.hide();
          print(data);
        }
      }
    } catch (err) {
      // pr = MyProgressDialog(context);
      // pr!.hide();
      if (kDebugMode) {
        print(err);
      }
    }
    notifyListeners();
  }

  addProduct(ProductsModel product, BuildContext context) async {
    try {
      isAddingProduct = true;
      notifyListeners();
      List<io.File>? imageFiles = [];
      List<MultipartFile>? filesData = [];
      for (int i = 0; i < imgeFiles.length; i++) {
        if (imgeFiles[i].image != null) {
          imageFiles.add(imgeFiles[i].image!);
        }
      }
      filesData = [];
      for (int i = 0; i < imageFiles.length; i++) {
        // if (imageFiles[i]. != null) {

        filesData.add(await MultipartFile.fromFile(
          imageFiles[i].path,
          filename: imageFiles[i].path.split('/').last,
        ));
        // }
      }

      FormData data = FormData.fromMap({
        'category_id': product.category_id,
        'brand_id': product.brand_id,
        'name': product.name,
        'price': product.price!.convertToEuro(context),
        'description': product.description,
        'feature_image': await MultipartFile.fromFile(
          imageFiles[0].path,
          filename: imageFiles[0].path.split('/').last,
        ),
        'color': product.color,
        'size_id': product.size_id,
        'condition': product.condition,
        'sold': product.sold,
        'size_id': product.size_id,
        'images[]': filesData,
      });
      log('------------------------------------');
      log(data.toString());
      var response = await http.addProduct(data);
      if (response.data['status'] == 'success') {
        log(response.data.toString());
        log('------------------------------------');
        // utilService.showToast(response.data['message'], ToastGravity.CENTER);

        clearAddProductFormData();
        isAddingProduct = false;
        notifyListeners();
        successSheet(context);
        // Navigator.of(context).pop();
        // successSheet(context);
      }

      if (kDebugMode) {
        // pr = MyProgressDialog(context);
        // pr!.hide();
        print(data);
      }
    } catch (err) {
      // pr = MyProgressDialog(context);
      // pr!.hide();
      if (kDebugMode) {
        print(err);
      }
    }
    notifyListeners();
  }

  makeProductBid(int price, int id, BuildContext context) async {
    try {
    //  isBidding = true;
     // notifyListeners();
      Map<String, dynamic> data = {
        'product_id': id,
        'price': double.parse(price.toString()).convertToEuro(context),
      };
      bidController.clear();
     // notifyListeners();

      var response = await http.makeProductBid(data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data['data']['status'] == 'pending') {
          utilService.showToast(AppLocalizations.of(context).translate('offerSent'), ToastGravity.TOP);
          // productDetail =
          //     ProductDetail.fromJson(response.data['data']['product']);
          Navigator.of(context).pop();
          await getProductDetail(id, context, true);
          await context.read<BidProvider>().getRecievedOffers(false);
          await context.read<BidProvider>().getSentOffer(false);
          notifyListeners();
        }
      }
    //  isBidding = false;
   //   notifyListeners();
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    //  isBidding = false;
    }
   // notifyListeners();
  }

  viewAllProductWithPagination({
    required int pageNumber,
    required String type,
    required BuildContext context,
    String? navigationTitle,
    required bool alreadyOnScreen,
  }) async {
    try {
      if (alreadyOnScreen == false) {
        isFetchingViewAll = true;
        notifyListeners();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => HomeProductViewAllScreen(
              title: navigationTitle!,
              type: type,
            )));
      }
      Map<String, String> data = {
        'type': type,
      };

      if (pageNumber == 1) {
        homeAllProductList = null;
      }
      if (pageNumber > 1) {
        ispaginationDataLoading = true;
        notifyListeners();
      }
      var response = await http.getViewAllProducts(pageNumber, data);
      if (response.data['status'] == 'success') {
        if (response.data['data']['data'].length > 0) {
          if (pageNumber == 1) {
            homeAllProductList = [];
          }
          for (int i = 0; i < response.data['data']['data'].length; i++) {
            homeAllProductList!.add(
              HomeCategoryModel(
                id: response.data['data']['data'][i]['id'],
                featured_image: response.data['data']['data'][i]['featured_image'],
                name: response.data['data']['data'][i]['name'],
                price: response.data['data']['data'][i]['price'].toDouble(),
                size: response.data['data']['data'][i]['size_id'] != null ? response.data['data']['data'][i]['size']['text'] : 'Not Mentioned',
                condition: response.data['data']['data'][i]['condition'],
              ),
            );
          }
          if (alreadyOnScreen == false) {
            isFetchingViewAll = false;
            notifyListeners();
          }
          if (pageNumber > 1) {
            ispaginationDataLoading = false;
            notifyListeners();
          }
        } else {
          if (alreadyOnScreen == false) {
            isFetchingViewAll = false;
            notifyListeners();
          }
          if (pageNumber > 1) {
            ispaginationDataLoading = false;
            notifyListeners();
          }

          utilService.showToast('No more data!', ToastGravity.CENTER);
        }
      } else {
        if (alreadyOnScreen == false) {
          isFetchingViewAll = false;
          notifyListeners();
        }
        if (pageNumber > 1) {
          ispaginationDataLoading = false;
          notifyListeners();
        }
        utilService.showToast('Ends Here', ToastGravity.CENTER);
      }
    } catch (err) {
      if (alreadyOnScreen == false) {
        isFetchingViewAll = false;
        notifyListeners();
      }
      if (pageNumber > 1) {
        ispaginationDataLoading = false;
        notifyListeners();
      }
      rethrow;
    }
  }

  viewAllProductWithPaginationGuest({
    required int pageNumber,
    required String type,
    required BuildContext context,
    String? navigationTitle,
    required bool alreadyOnScreen,
  }) async {
    try {
      if (alreadyOnScreen == false) {
        isFetchingViewAll = true;
        notifyListeners();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => HomeProductViewAllScreen(
              title: navigationTitle!,
              type: type,
            )));
      }
      Map<String, String> data = {
        'type': type,
      };

      if (pageNumber == 1) {
        homeAllProductList = null;
      }
      if (pageNumber > 1) {
        ispaginationDataLoading = true;
        notifyListeners();
      }
      var response = await http.getGuestViewAllProducts(pageNumber, data);
      if (response.data['status'] == 'success') {
        if (response.data['data']['data'].length > 0) {
          if (pageNumber == 1) {
            homeAllProductList = [];
          }
          for (int i = 0; i < response.data['data']['data'].length; i++) {
            homeAllProductList!.add(
              HomeCategoryModel(
                id: response.data['data']['data'][i]['id'],
                featured_image: response.data['data']['data'][i]['featured_image'],
                name: response.data['data']['data'][i]['name'],
                price: response.data['data']['data'][i]['price'].toDouble(),
                size: response.data['data']['data'][i]['size_id'] != null ? response.data['data']['data'][i]['size']['text'] : 'Not Mentioned',
                condition: response.data['data']['data'][i]['condition'],
              ),
            );
          }
          if (alreadyOnScreen == false) {
            isFetchingViewAll = false;
            notifyListeners();
          }
          if (pageNumber > 1) {
            ispaginationDataLoading = false;
            notifyListeners();
          }
        } else {
          if (alreadyOnScreen == false) {
            isFetchingViewAll = false;
            notifyListeners();
          }
          if (pageNumber > 1) {
            ispaginationDataLoading = false;
            notifyListeners();
          }

          utilService.showToast('No more data!', ToastGravity.BOTTOM);
        }
      } else {
        if (alreadyOnScreen == false) {
          isFetchingViewAll = false;
          notifyListeners();
        }
        if (pageNumber > 1) {
          ispaginationDataLoading = false;
          notifyListeners();
        }
        utilService.showToast('Ends Here', ToastGravity.CENTER);
      }
    } catch (err) {
      if (alreadyOnScreen == false) {
        isFetchingViewAll = false;
        notifyListeners();
      }
      if (pageNumber > 1) {
        ispaginationDataLoading = false;
        notifyListeners();
      }
      rethrow;
    }
  }

  searchProduct(String s_text) async {
    try {
      isSearching = true;
      notifyListeners();
      var response = await http.searchProduct(s_text);
      if (response.data['status'] == 'success') {
        if (response.data['data'].length > 0) {
          searchedProducts.clear();
          for (int i = 0; i < response.data['data'].length; i++) {
            searchedProducts.add(
              ProductsModel(
                id: response.data['data'][i]['id'],
                feature_image: response.data['data'][i]['featured_image'],
                name: response.data['data'][i]['name'],
                condition: response.data['data'][i]['condition'],
                category: response.data['data'][i]['category']['name'],
                price: double.parse(response.data['data'][i]['price'].toString()),
                size: response.data['data'][i]['size_id'] != null ? response.data['data'][i]['size']['text'] : '',
              ),
            );
          }
          notifyListeners();
        } else {
          searchedProducts.clear();
          notifyListeners();
        }
        isSearching = false;
        notifyListeners();
      }
    } catch (err) {
      if (kDebugMode) {
        isSearching = false;
        notifyListeners();
        utilService.showToast('Try Again Please', ToastGravity.CENTER);
        print(err);
      }
    }
  }

  searchProductWithFilter(
      {String categoryid = '', String brandId = '', String sizeId = '', String color = '', String maxPrice = '', String minPrice = ''}) async {
    try {
      isSearching = true;
      notifyListeners();
      var response = await http.searchProductWithFiltes(
        categoryid: categoryid,
        brandId: brandId,
        sizeId: sizeId,
        color: color,
        maxPrice: maxPrice,
        minPrice: minPrice,
      );

      if (response.data['status'] == 'success') {
        if (response.data['data'].length > 0) {
          searchedProducts.clear();
          for (int i = 0; i < response.data['data'].length; i++) {
            searchedProducts.add(
              ProductsModel(
                id: response.data['data'][i]['id'],
                feature_image: response.data['data'][i]['featured_image'],
                name: response.data['data'][i]['name'],
                condition: response.data['data'][i]['condition'],
                category: response.data['data'][i]['category']['name'],
                price: double.parse(response.data['data'][i]['price'].toString()),
                size: response.data['data'][i]['size_id'] != null ? response.data['data'][i]['size']['text'] : '',
              ),
            );
          }

          notifyListeners();
        } else {
          searchedProducts.clear();
          notifyListeners();
        }
        isSearching = false;
        notifyListeners();
      }
    } catch (err) {
      if (kDebugMode) {
        isSearching = false;
        notifyListeners();
        utilService.showToast('Try Again Please', ToastGravity.CENTER);
        print(err);
      }
    }
  }
}
