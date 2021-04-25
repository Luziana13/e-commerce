import 'package:dio/dio.dart';
import 'package:e_commerce/helpers/products_class.dart';
import 'package:e_commerce/helpers/user_class.dart';
import 'package:e_commerce/ui/home_adm.dart';
import 'package:flutter/material.dart';

class DeleteProduct extends StatefulWidget {
  User user;
  Product prod;
  DeleteProduct(this.user, this.prod);
  @override
  _DeleteProduct createState() => _DeleteProduct();
}

class _DeleteProduct extends State<DeleteProduct> {
  Future<void> deleteProd(BuildContext context, Product prod) async {
    Response response;
    var id = prod.id;
    print(id);
    var dio = Dio();
    final url =
        'https://restful-ecommerce-ufma.herokuapp.com/api/v1/products/$id';
    try {
      response = await dio.delete(url,
          options: Options(
              headers: {"Authorization": "Bearer " + widget.user.token}));

      await Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomeAdm(widget.user)));
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Deletar o produto",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      body: Column(
        children: [
          Text(
            "Deseja deletar o produto " + widget.prod.title + "?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(),
          TextButton(
            onPressed: () {
              deleteProd(context, widget.prod);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
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
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Deletar produto',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
