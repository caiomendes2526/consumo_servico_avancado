import 'package:consumo_servico_avancado/Post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'Post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperarPostagens() async {
    http.Response response = await http.get(Uri.parse(_urlBase + "/posts"));
    var dadosJson = json.decode(response.body);

    List<Post> postagens = [];
    for (var post in dadosJson) {
      print("post: " + post["title"]);
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(p);
    }
    return postagens;
    //print( postagens.toString() );
  }

  // Método post
  String Titulo = "Teste Teste";
  _post() async {
    var corpo = json.encode(
      {
        "userId": 120,
        "id": null,
        "title": Titulo,
        "body": "Corpo da Postagem"
      },
    );
    http.Response response = await http.post(
      Uri.parse(_urlBase + "/posts"),
      headers: {
        "Content-type": "application/json; charset=UTF-8"
      },
      body: corpo
    );
    print("resposta:  ${response.statusCode}");
    print("resposta:  ${response.body}");
  }

  // Método Put
  _put() async {
    var corpo = json.encode(
      {
        "userId": 120,
        "id": null,
        "title": "Titulo Atualizado",
        "body": "Corpo da Postagem Atualizada"
      },
    );
    http.Response response = await http.put(
        Uri.parse(_urlBase + "/posts/2"),
        headers: {
          "Content-type": "application/json; charset=UTF-8"
        },
        body: corpo
    );
    print("resposta:  ${response.statusCode}");
    print("resposta:  ${response.body}");
  }

  // Método Patch
  _patch() async {
    // o método patch atualiza apenas um campo especifico, ja o put atualiza todos
    // os campos
    var corpo = json.encode(
      {
        "userId": 120,
        "body": "Corpo da Postagem Atualizada Patch"
      },
    );
    http.Response response = await http.patch(
        Uri.parse(_urlBase + "/posts/2"),
        headers: {
          "Content-type": "application/json; charset=UTF-8"
        },
        body: corpo
    );
    print("resposta:  ${response.statusCode}");
    print("resposta:  ${response.body}");

  }

  // Método Delete
  _delete() async {

    var corpo = json.encode(
      {
        "userId": 120,
        "body": "Corpo da Postagem Atualizada Patch"
      },
    );
    http.Response response = await http.delete(
        Uri.parse(_urlBase + "/posts/2"),
    );
    print("resposta:  ${response.statusCode}");
    print("resposta:  ${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text("Salvar"),
                  onPressed: _post,
                ),
                RaisedButton(
                  child: Text("Atualizar"),
                  onPressed: _patch,
                ),
                RaisedButton(
                  child: Text("Remover"),
                  onPressed: _delete,
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _recuperarPostagens(),
                builder: (context, snapshot) {
                  var retorno;

                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      retorno = Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        print("lista: Erro ao carregar ");
                      } else {
                        retorno = ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              List<Post>? lista = snapshot.data;
                              Post post = lista![index];

                              return ListTile(
                                title: Text(post.title),
                                subtitle: Text(post.id.toString()),
                              );
                            });
                      }
                      break;
                  }

                  return retorno;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
