import '../models/product_page_model.dart';
import '../sources/remote/product_api_service.dart';

class ProductRepository {
  final ProductApiService remoteSource;

  ProductRepository({required this.remoteSource});

  Future<ProductPageModel> fetchProducts({
    required int limit,
    required int skip,
  }) {
    return remoteSource.fetchProducts(limit: limit, skip: skip);
  }
}
