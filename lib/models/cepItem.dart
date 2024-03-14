class CepItem {
  final String objectId;
  final String cep;
  final String logradouro;

  CepItem(
      {required this.objectId, required this.cep, required this.logradouro});

  factory CepItem.fromJson(Map<String, dynamic> json) {
    return CepItem(
      objectId: json['objectId'],
      cep: json['cep'],
      logradouro: json['logradouro'],
    );
  }
}
