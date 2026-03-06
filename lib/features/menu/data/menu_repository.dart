import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/api/api_client.dart';
import 'package:tiffinmate/core/api/api_endpoints.dart';
import 'package:tiffinmate/features/menu/domain/entities/menu_item.dart';

class MenuRepository {
  final ApiClient _apiClient;

  MenuRepository(this._apiClient);

  Future<List<MenuItem>> getWeeklyMenu() async {
    // Try /menu first, then /recipes, no Hive fallback (always real API data)
    try {
      return await _fetchFromPath(ApiEndpoints.menu);
    } catch (_) {
      // If /menu fails, try /recipes once
      return await _fetchFromPath(ApiEndpoints.recipes);
    }
  }

  Future<List<MenuItem>> _fetchFromPath(String path) async {
    final response = await _apiClient.get(path);
    final data = response.data;

    List<dynamic>? rawList;
    if (data is Map<String, dynamic> && data['data'] is List) {
      rawList = data['data'] as List;
    } else if (data is List) {
      rawList = data;
    }

    if (rawList == null) {
      throw Exception('Invalid menu response from server');
    }

    return rawList.map<MenuItem>((dynamic raw) {
      final map = Map<String, dynamic>.from(raw as Map);
      return MenuItem(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        price: (map['price'] as num).toDouble(),
        category: map['category'] as String,
        image: (map['image'] ?? '') as String,
      );
    }).toList();
  }
}

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return MenuRepository(apiClient);
});

final weeklyMenuProvider = FutureProvider<List<MenuItem>>((ref) async {
  final repo = ref.read(menuRepositoryProvider);
  return repo.getWeeklyMenu();
});
