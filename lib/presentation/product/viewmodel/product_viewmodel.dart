import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/network/api_clients.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/sources/remote/product_api_service.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(
    remoteSource: ProductApiService(apiClient: ApiClient()),
  ),
);

final productViewModelProvider = StateNotifierProvider<
  ProductViewModel,
  ProductState
>((ref) => ProductViewModel(repository: ref.read(productRepositoryProvider)));

class ProductState {
  final List<ProductModel> products;
  final bool isInitialLoading;
  final bool isPaginationLoading;
  final bool hasMore;
  final String? initialError;
  final String? paginationError;
  final int limit;
  final int skip;

  const ProductState({
    required this.products,
    required this.isInitialLoading,
    required this.isPaginationLoading,
    required this.hasMore,
    required this.initialError,
    required this.paginationError,
    required this.limit,
    required this.skip,
  });

  factory ProductState.initial() {
    return const ProductState(
      products: [],
      isInitialLoading: true,
      isPaginationLoading: false,
      hasMore: true,
      initialError: null,
      paginationError: null,
      limit: 10,
      skip: 0,
    );
  }

  ProductState copyWith({
    List<ProductModel>? products,
    bool? isInitialLoading,
    bool? isPaginationLoading,
    bool? hasMore,
    String? initialError,
    bool clearInitialError = false,
    String? paginationError,
    bool clearPaginationError = false,
    int? limit,
    int? skip,
  }) {
    return ProductState(
      products: products ?? this.products,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      hasMore: hasMore ?? this.hasMore,
      initialError:
          clearInitialError ? null : (initialError ?? this.initialError),
      paginationError:
          clearPaginationError
              ? null
              : (paginationError ?? this.paginationError),
      limit: limit ?? this.limit,
      skip: skip ?? this.skip,
    );
  }
}

class ProductViewModel extends StateNotifier<ProductState> {
  final ProductRepository repository;

  ProductViewModel({required this.repository}) : super(ProductState.initial()) {
    fetchInitialProducts();
  }

  Future<void> fetchInitialProducts() async {
    state = state.copyWith(
      isInitialLoading: true,
      products: [],
      hasMore: true,
      skip: 0,
      clearInitialError: true,
      clearPaginationError: true,
    );

    try {
      final page = await repository.fetchProducts(limit: state.limit, skip: 0);
      final hasMore = page.products.length < page.total;

      state = state.copyWith(
        products: page.products,
        isInitialLoading: false,
        hasMore: hasMore,
        skip: page.products.length,
        clearInitialError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isInitialLoading: false,
        initialError: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> loadMoreProducts() async {
    if (state.isInitialLoading || state.isPaginationLoading || !state.hasMore) {
      return;
    }

    state = state.copyWith(
      isPaginationLoading: true,
      clearPaginationError: true,
    );

    try {
      final page = await repository.fetchProducts(
        limit: state.limit,
        skip: state.skip,
      );

      final updatedProducts = [...state.products, ...page.products];
      final hasMore = updatedProducts.length < page.total;

      state = state.copyWith(
        products: updatedProducts,
        isPaginationLoading: false,
        hasMore: hasMore,
        skip: updatedProducts.length,
        clearPaginationError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isPaginationLoading: false,
        paginationError: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}
