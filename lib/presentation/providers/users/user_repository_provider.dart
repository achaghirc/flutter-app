import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/infraestructure/repositories/user_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';

final userRepositoryProvider = Provider((ref) {
  final session = ref.watch(sessionProvider).session;
  return UserRepositoryImpl(session);
});