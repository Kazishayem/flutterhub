import 'product_model.dart';

class ProductPageModel {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  ProductPageModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductPageModel.fromJson(Map<String, dynamic> json) {
    final rawProducts = (json['products'] as List<dynamic>? ?? []);

    return ProductPageModel(
      products:
          rawProducts
              .map(
                (item) => ProductModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}
