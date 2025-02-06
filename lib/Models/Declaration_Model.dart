class DeclarationModel {
 final int id ;
  final String type;
  final int quantite;
  final String data;
  DeclarationModel(
  {
     required this.id, 
     required this.type, 
     required this.quantite,
     required this.data,
  }
  );

  factory DeclarationModel.fromJson(Map<String, dynamic> json) {
    return DeclarationModel(
      id:json['Id'],
      type: json['Type'],
      quantite: json['Quantite'],
      data:json['Data'],
    );
  }

 
}
