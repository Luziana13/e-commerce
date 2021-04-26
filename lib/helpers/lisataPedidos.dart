import 'package:e_commerce/helpers/products_class.dart';

class Pedidos {
  List<dynamic> listaProd;
  int id;
  int userId;
  int grandTotal;
  String status;

  Pedidos.fromJson(Map json)
      : id = json['id'],
        userId = json['userId'],
        grandTotal = json['grandTotal'],
        status = json['status'],
        listaProd = json['items'];
}
