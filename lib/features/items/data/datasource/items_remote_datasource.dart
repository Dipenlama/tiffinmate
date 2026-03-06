import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/api/api_client.dart';
import 'package:tiffinmate/core/api/api_endpoints.dart';
import 'package:tiffinmate/features/items/data/models/item_api_model.dart';

abstract interface class IItemsRemoteDataSource {
  Future<(List<ItemApiModel>, int total, int page, int limit, int totalPages)>
      getItems({
    int page,
    int limit,
    String? query,
    String? category,
    bool? available,
  });

  Future<ItemApiModel> getItemById(String id);
}

final itemsRemoteDataSourceProvider = Provider<IItemsRemoteDataSource>((ref) {
  final client = ref.read(apiClientProvider);
  return ItemsRemoteDataSource(apiClient: client);
});

class ItemsRemoteDataSource implements IItemsRemoteDataSource {
  final ApiClient _apiClient;

  ItemsRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<(List<ItemApiModel>, int, int, int, int)> getItems({
    int page = 1,
    int limit = 10,
    String? query,
    String? category,
    bool? available,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.items,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (query != null && query.isNotEmpty) 'q': query,
        if (category != null && category.isNotEmpty) 'category': category,
        if (available != null) 'available': available.toString(),
      },
    );

    final data = response.data as Map<String, dynamic>;
    final itemsJson = data['items'] as List<dynamic>;
    final items =
        itemsJson.map((e) => ItemApiModel.fromJson(e as Map<String, dynamic>)).toList();

    final total = data['total'] as int;
    final currentPage = data['page'] as int;
    final pageLimit = data['limit'] as int;
    final totalPages = data['totalPages'] as int;

    return (items, total, currentPage, pageLimit, totalPages);
  }

  @override
  Future<ItemApiModel> getItemById(String id) async {
    final response = await _apiClient.get('${ApiEndpoints.items}/$id');
    final data = response.data as Map<String, dynamic>;
    return ItemApiModel.fromJson(data);
  }
}
