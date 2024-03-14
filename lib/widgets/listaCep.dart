import 'package:flutter/material.dart';
import 'package:cepbusca/models/cepItem.dart';
import 'package:cepbusca/repository/cepRepository.dart';

class ListaCep extends StatefulWidget {
  final String data;

  const ListaCep({Key? key, required this.data}) : super(key: key);

  @override
  _ListaCepState createState() => _ListaCepState();
}

class _ListaCepState extends State<ListaCep> {
  final CepRepository cepRepository = CepRepository();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Ceps Cadastrados',
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          backgroundColor: Colors.black,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/back.png'),
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder<List<CepItem>>(
                      future: cepRepository.fetchCeps(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(snapshot.data![index].logradouro),
                                  subtitle: Text(snapshot.data![index].cep),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      await cepRepository.deleteCep(
                                          snapshot.data![index].objectId);
                                      // Atualizar a lista após a exclusão
                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
