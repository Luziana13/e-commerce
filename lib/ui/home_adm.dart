import 'dart:convert';
import 'package:e_commerce/helpers/products_class.dart';
import 'package:e_commerce/ui/cadastrar_Product.dart';
import 'package:flutter/material.dart';
import '../helpers/user_class.dart';
import 'package:dio/dio.dart';

class HomeAdm extends StatefulWidget {
  User user;
  HomeAdm(this.user);
  @override
  _HomeAdmState createState() => _HomeAdmState();
}

class _HomeAdmState extends State<HomeAdm> {
  List<Product> list = [];
  Future<List<Product>> listProducts() async {
    var _token = widget.user.token;
    Response response;
    Dio dio = new Dio();
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

  void registerProduct(BuildContext context) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => RegisterProduct(widget.user)));
  }

  void deleteProd(BuildContext context, Product prod) {}
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
              registerProduct(context);
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
                    'Cadastrar produtos',
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
                                border:
                                    Border.all(color: Colors.grey, width: 2),
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
                                          deleteProd(context, e);
                                        },
                                        child: const Icon(Icons.delete,
                                            color: Colors.red),
                                        backgroundColor: Colors.white,
                                        mini: true,
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
              }),
        ]));
  }
}
