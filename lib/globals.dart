library globals;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final container = ProviderContainer();
//OPTIONS: LOCAL ; DEMO
const env = 'LOCAL'; //LOCAL
const stripePublishableKey = "pk_test_51OukblJxvaP5wmZfHJIUfobsBsZfy813IhQK6y41SFLIIgKt8XNpQHHHYAGMLY8cTccSHxmJRQLaLH1mAAed4ljo00cG8r9WHY";
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
    return 'http://192.168.0.35:8089';
  }else{
    return 'http://3.254.209.202:8080';
  }
}

stripeUrl() {
  if(env == 'LOCAL'){
    return 'http://192.168.0.35:9090';
  }else{
    return 'http://localhost:9090';
  }
}