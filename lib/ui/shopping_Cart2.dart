import 'package:dio/dio.dart';
import 'package:e_commerce/helpers/products_class.dart';
import 'package:e_commerce/helpers/user_class.dart';
import 'package:flutter/material.dart';

class Shopping_cart2 extends StatefulWidget {
  User user;
  Product prod;
  Shopping_cart2(this.user, this.prod);
  @override
  _Shopping_cart createState() => _Shopping_cart();
}

class _Shopping_cart extends State<Shopping_cart2> {
  List<Product> list = [];
  Response response;
  Dio dio = new Dio();
  var amount = 0;
  Future<List<Product>> listPedidos() async {
    var _token = widget.user.token;
    response = await dio.get(
        'https://restful-ecommerce-ufma.herokuapp.com/api/v1/cart',
        options: Options(headers: {"Authorization": "Bearer " + _token}));
    if (response.data["success"] != true) {
      throw Exception("erro na requisição");
    } else {
      amount = response.data["data"]["cartItem"]["totalAmount"];
      List<dynamic> lista =
          List<dynamic>.from(response.data["data"]["cartItem"]["items"]);
      list.clear();
      for (var i in lista) {
        list.add(Product.fromJson(i));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Produtos no carrinho",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      body: FutureBuilder(
          future: listPedidos(),
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.hasError);
              return Text("Erro");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: snapshot.data
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 2),
                          ),
                          width: width,
                          height: 150,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(e.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: Text(e.price.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Text(e.description,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
