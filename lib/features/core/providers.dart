import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/data/auth_repo.dart';
import 'data/items_repo.dart';
import 'data/shelves_repo.dart';

final authRepoProvider = Provider<AuthRepo>((ref) => AuthRepo());
final shelvesRepoProvider = Provider<ShelvesRepo>((ref) => ShelvesRepo());
final itemsRepoProvider = Provider<ItemsRepo>((ref) => ItemsRepo());

final itemsQueryProvider = StateProvider<ItemsQuery>((ref) => const ItemsQuery());
