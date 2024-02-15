

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';

class SessionNotifier extends ChangeNotifier {
  JwtAuthenticationResponseDTO? session;

  void set(JwtAuthenticationResponseDTO session) {
    this.session = session;
    notifyListeners();
  }

  void clear() {
    session = null;
    notifyListeners();
  }

} 

final sessionProvider = ChangeNotifierProvider<SessionNotifier>((ref) => SessionNotifier());