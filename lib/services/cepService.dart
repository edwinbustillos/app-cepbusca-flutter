import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cepbusca/models/cep_model.dart';

class CepService {
  Future<Cep> fetchCep(String cep) async {
    var resp = await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
    var json = jsonDecode(resp.body);
    print("JSON: ${json}");

    if (json["erro"] != null) {
      return Cep(
        rua: "",
        bairro: "",
        cidade: "",
        estado: "",
        cep: "",
        complemento: "",
        ibge: "",
        gia: "",
        ddd: "",
        siafi: "",
      );
    }

    return Cep(
      rua: json["logradouro"],
      bairro: json["bairro"],
      cidade: json["localidade"],
      estado: json["uf"],
      cep: json["cep"],
      complemento: json["complemento"],
      ibge: json["ibge"],
      gia: json["gia"],
      ddd: json["ddd"],
      siafi: json["siafi"],
    );
  }
}
