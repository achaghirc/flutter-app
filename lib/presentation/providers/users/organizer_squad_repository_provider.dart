import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/infraestructure/repositories/organizer_squad_respository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';

final orgSquadRepositoryProvider = Provider((ref) {
  final session = ref.read(sessionProvider).session;
  return OrganizerSquadRepositoryImpl(session);
});