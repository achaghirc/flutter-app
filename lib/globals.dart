library globals;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final container = ProviderContainer();
//OPTIONS: LOCAL ; DEMO
const env = 'DEMO'; //LOCAL
const stripePublishableKey = "pk_test_51OfqoCDpDIFEod0t6usPrGrqahmMtmtUwtzYufKMY0k0j4lvjUXYgciwN3XiAaHl6xu4xfTKPAlOkIsoAxRKliKj00STRhV2P6";
RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

double buildTicketPrice(double price){
    List<String> parts = price.toString().split('.');
    if(int.parse(parts.last) == 0){
      return double.parse(parts.first);
    }
    return price;
}

url(){
  if(env == 'LOCAL'){
    return 'http://localhost:8089';
  }else{
    return 'http://3.254.209.202:8080';
  }
}

stripeUrl() {
  if(env == 'LOCAL'){
    return 'http://localhost:9090';
  }else{
    return 'http://localhost:9090';
  }
}