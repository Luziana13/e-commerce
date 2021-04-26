import 'package:e_commerce/helpers/products_class.dart';
import 'package:e_commerce/ui/shopping_Cart2.dart';
import 'package:flutter/material.dart';
import '../helpers/user_class.dart';
import 'package:dio/dio.dart';

import 'lista_pedido.dart';

class HomePage extends StatefulWidget {
  User user;
  HomePage(this.user);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> list = [];
  Response response;
  Dio dio = new Dio();
  Future<List<Product>> listProducts() async {
    var _token = widget.user.token;
    response = await dio.get(
        'https://restful-ecommerce-ufma.herokuapp.com/api/v1/products',
        options: Options(headers: {"Authorization": _token}));

    if (response.data["success"] != true) {
      throw Exception("erro na requisição");
    }

    List<dynamic> lista = List<dynamic>.from(response.data["data"]);
    list.clear();
    for (var i in lista) {
      list.add(Product.fromJson(i));
    }
    print(list.length);
    return list;
  }

  void adicionarCarrinho(BuildContext context, Product prod) async {
    final url = 'https://restful-ecommerce-ufma.herokuapp.com/api/v1/cart/add';
    Map<String, dynamic> formData = {
      'productId': prod.id,
      'qty': 1,
    };
    try {
      response = await dio.post(url,
          options: Options(
              headers: {"Authorization": "Bearer " + widget.user.token}),
          data: formData);
      if (response.data["success"] == true) {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Shopping_cart2(widget.user, prod)));
      }
    } on DioError catch (err) {
      print(err);
    }
  }

  Future<void> listarPedido(BuildContext context) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ListarPedido(widget.user)));
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
      body: Column(children: [
        Divider(),
        TextButton(
          onPressed: () {
            listarPedido(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  'listar pedido',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
        Divider(),
        FutureBuilder(
            future: listProducts(),
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
                                Container(
                                    alignment: Alignment.bottomRight,
                                    child: FloatingActionButton(
                                      onPressed: () {
                                        adicionarCarrinho(context, e);
                                      },
                                      child:
                                          const Icon(Icons.add_shopping_cart),
                                      mini: true,
                                      backgroundColor: Colors.green,
                                    )),
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
            })
      ]),
    );
  }
}
