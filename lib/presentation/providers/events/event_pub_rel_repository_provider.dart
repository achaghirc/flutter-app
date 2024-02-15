import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/infraestructure/repositories/event_public_relations_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';

final eventPublicRleationsRepositoryProvider = Provider((ref) {
  final session = ref.read(sessionProvider).session;
  return EventPublicRelationsRepositoryImpl(session);
});