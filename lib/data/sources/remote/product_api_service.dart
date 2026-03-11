import '../../../core/network/api_clients.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/product_page_model.dart';

class ProductApiService {
  final ApiClient apiClient;

  ProductApiService({required this.apiClient});

  Future<ProductPageModel> fetchProducts({
    required int limit,
    required int skip,
  }) async {
    final dynamic response = await apiClient.getRequest(
      endpoints: '${ApiEndpoints.products}?limit=$limit&skip=$skip',
    );

    if (response is Map<String, dynamic>) {
      return ProductPageModel.fromJson(response);
    }

    throw Exception('Invalid products response');
  }
}
