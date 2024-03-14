import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cepbusca/models/cepItem.dart';

class CepRepository {
  Future<List<CepItem>> fetchCeps() async {
    final response = await http.get(
      Uri.parse('https://parseapi.back4app.com/classes/correios'),
      headers: {
        "X-Parse-Application-Id": "N7OXYaA1M8rszPF1VCqGSk0lHuIbQCsojhoPkQMM",
        "X-Parse-REST-API-Key": "hwE7EfkX70cM9kXZpykI4YegrNhOsLP86hmBzGMV",
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['results'];
      return jsonResponse.map((item) => CepItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load CEPs');
    }
  }

  Future<CepItem> fetchCepCode(String cep) async {
    final response = await http.get(
      Uri.parse(
          'https://parseapi.back4app.com/classes/correios/?where={"cep":"$cep"}'),
      headers: {
        "X-Parse-Application-Id": "N7OXYaA1M8rszPF1VCqGSk0lHuIbQCsojhoPkQMM",
        "X-Parse-REST-API-Key": "hwE7EfkX70cM9kXZpykI4YegrNhOsLP86hmBzGMV",
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse == null) {
        return CepItem(cep: "null", objectId: 'null', logradouro: 'null');
      }
      if (jsonResponse['results'].isNotEmpty) {
        return CepItem.fromJson(jsonResponse['results'][0]);
      } else {
        return CepItem(cep: "null", objectId: 'null', logradouro: 'null');
      }
    } else {
      return CepItem(cep: "null", objectId: 'null', logradouro: 'null');
    }
  }

  Future<CepItem> fetchCepId(String id) async {
    final response = await http.get(
      Uri.parse('https://parseapi.back4app.com/classes/correios/$id'),
      headers: {
        "X-Parse-Application-Id": "N7OXYaA1M8rszPF1VCqGSk0lHuIbQCsojhoPkQMM",
        "X-Parse-REST-API-Key": "hwE7EfkX70cM9kXZpykI4YegrNhOsLP86hmBzGMV",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return CepItem.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load CEP');
    }
  }

  Future<void> deleteCep(String objectId) async {
    final response = await http.delete(
      Uri.parse('https://parseapi.back4app.com/classes/correios/$objectId'),
      headers: {
        "X-Parse-Application-Id": "N7OXYaA1M8rszPF1VCqGSk0lHuIbQCsojhoPkQMM",
        "X-Parse-REST-API-Key": "hwE7EfkX70cM9kXZpykI4YegrNhOsLP86hmBzGMV",
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete CEP');
    }
  }

  Future<void> createCep(String cep, String logradouro) async {
    final response = await http.post(
      Uri.parse('https://parseapi.back4app.com/classes/correios'),
      headers: {
        "X-Parse-Application-Id": "N7OXYaA1M8rszPF1VCqGSk0lHuIbQCsojhoPkQMM",
        "X-Parse-REST-API-Key": "hwE7EfkX70cM9kXZpykI4YegrNhOsLP86hmBzGMV",
        "Content-Type": "application/json",
      },
      body: jsonEncode(<String, String>{
        'cep': cep,
        'logradouro': logradouro,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create CEP');
    }
  }
}
