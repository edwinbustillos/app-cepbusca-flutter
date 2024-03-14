import 'package:cepbusca/widgets/ListaCep.dart';
import 'package:flutter/material.dart';
import 'package:cepbusca/models/cepModel.dart';
import 'package:cepbusca/services/cepService.dart';
import 'package:cepbusca/repository/cepRepository.dart';

class CepForm extends StatefulWidget {
  const CepForm({super.key});

  @override
  _CepFormState createState() => _CepFormState();
}

class _CepFormState extends State<CepForm> {
  final cepController = TextEditingController();
  final cepService = CepService();
  final cepRepository = CepRepository();
  Cep? cep;
  bool cadastraCep = false;

  void fetchCep() async {
    try {
      var cep = await cepService.fetchCep(cepController.text);
      if (cep.cep == "") {
        print("CEP não encontrado na ViaCep.");
        setState(() {
          this.cep = null;
        });
      } else {
        setState(() {
          this.cep = cep;
        });
        var cepVia = cep.cep.replaceAll('-', '').toString();
        var cepExists = await cepRepository.fetchCepCode(cepVia);
        if (cepExists.cep == "null") {
          print("Cep não encontrado no banco");
          setState(() {
            cadastraCep = false;
          });
        } else {
          print("Cep Existe agora: ${cepExists.cep}");
          setState(() {
            cadastraCep = true;
          });
        }
        print(cep.cep);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String dataToSend = "Dados para enviar";

    return Scaffold(
      backgroundColor: Colors.black,
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
                fit: BoxFit
                    .fitWidth, // make the image fit the width of the container
                //fit: BoxFit.cover, // use this if you want the image to cover the entire container
                // colorFilter: ColorFilter.mode(
                //   Color.fromARGB(255, 255, 255, 6)
                //       .withOpacity(0.1), // make the image semi-transparent
                //   BlendMode
                //       .dstATop, // this blend mode is used to put the image on top of the color
                // ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: cepController,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          decoration: const InputDecoration(
                            labelText: "CEP",
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                          onSubmitted: (value) => fetchCep(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                        onPressed: fetchCep,
                        child: const Text(
                          'Buscar CEP',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  if (cep != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Logradouro: ${cep!.rua}"),
                            Text("Bairro: ${cep!.bairro}"),
                            Text("Cidade: ${cep!.cidade}"),
                            Text("Estado: ${cep!.estado}"),
                            Text("CEP: ${cep!.cep}"),
                            Text("Complemento: ${cep!.complemento}"),
                            Text("IBGE: ${cep!.ibge}"),
                            Text("GIA: ${cep!.gia}"),
                            Text("DDD: ${cep!.ddd}"),
                            Text("SIAFI: ${cep!.siafi}"),
                            const SizedBox(
                              height: 20,
                            ),
                            cadastraCep
                                ? ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Listar Ceps cadastrados',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ListaCep(data: dataToSend),
                                        ),
                                      );
                                    },
                                  )
                                : ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Cadastrar CEP na base ?',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      await cepRepository.createCep(
                                          cep!.cep.replaceAll('-', ''),
                                          cep!.rua);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ListaCep(data: dataToSend),
                                        ),
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
