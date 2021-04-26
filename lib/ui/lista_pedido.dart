import 'package:e_commerce/helpers/lisataPedidos.dart';
import 'package:e_commerce/helpers/products_class.dart';
import 'package:e_commerce/ui/shopping_Cart2.dart';
import 'package:flutter/material.dart';
import '../helpers/user_class.dart';
import 'package:dio/dio.dart';

class ListarPedido extends StatefulWidget {
  User user;
  ListarPedido(this.user);
  @override
  _ListarPedido createState() => _ListarPedido();
}

class _ListarPedido extends State<ListarPedido> {
  List<Product> list = [];
  List<Pedidos> listPedidos = [];
  Response response;
  Dio dio = new Dio();
  Future<List<Pedidos>> listProducts() async {
    var _token = widget.user.token;
    response = await dio.get(
        'https://restful-ecommerce-ufma.herokuapp.com/api/v1/orders',
        options: Options(headers: {"Authorization": "Bearer " + _token}));

    if (response.data["success"] != true) {
      throw Exception("erro na requisição");
    }

    List<dynamic> listaPed = List<dynamic>.from(response.data["data"]);
    listPedidos.clear();
    for (var i in listaPed) {
      listPedidos.add(Pedidos.fromJson(i));
    }

    print(listPedidos[0].listaProd[0]);
    return listPedidos;
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
            "Produtos",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      body: FutureBuilder(
          future: listProducts(),
          builder: (context, AsyncSnapshot<List<Pedidos>> snapshot) {
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
                                child: Text(e.status,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: Text(e.grandTotal.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
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
