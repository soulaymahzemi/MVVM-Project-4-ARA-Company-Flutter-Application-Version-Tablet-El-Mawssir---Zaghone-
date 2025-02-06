import 'dart:async';
import 'dart:convert';

import 'package:elmawssir/Views/Colors_pages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Declation extends StatefulWidget {
  final int id;
  final String name;
  final String url;
  const Declation({
    super.key,
    required this.id,
    required this.name,
    required this.url,
  });

  @override
  State<Declation> createState() => _DeclationState();
}

class _DeclationState extends State<Declation> {
  int _selectedForm = -1;
  String? selectedCause;
  String? selectedCause2;
  final _formKey = GlobalKey<FormState>();

  TextEditingController quantityController = TextEditingController();
  TextEditingController quantityController2 = TextEditingController();
  List<Map<String, dynamic>> dataNc =
      []; // Liste des données récupérées pour le tableau
  List<Map<String, dynamic>> datadechet =
      []; // Liste des données récupérées pour le tableau
  int? _lastDuree;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchData2();
    fetchLastDuree();
  }
String formatDuration(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int secs = seconds % 60;
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
}


  void _submitForm2() async {
    if (selectedCause2 != null && quantityController2.text.isNotEmpty) {
      // Construire l'URL spécifique en ajoutant le chemin Nc à l'URL de base
      String fullUrl =
          '${widget.url}/dechet'; // Concatenation de l'URL de base et du chemin spécifique
      print("URL : $fullUrl");

      // Construire les données à envoyer
      final response = await http.post(
        Uri.parse(fullUrl), // Utilisation de l'URL complète
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'Type':
              selectedCause2, // Assurez-vous que 'Type' est bien la clé attendue par votre API
          'Quantite': int.parse(quantityController2.text) ??
              0, // Quantité saisie par l'utilisateur
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Données envoyées avec succès');
        setState(() {
          selectedCause2 = null; // Réinitialiser la sélection
          quantityController2.clear(); // Effacer le champ de texte
        });
        _fetchData2(); // Appel de la méthode pour récupérer les données mises à jour
      } else {
        print('Échec de l\'envoi des données : ${response.statusCode}');
        print('Réponse : ${response.body}');
      }
    }
  }

  void _fetchData2() async {
    String fullUrl = '${widget.url}/dechet'; // URL pour récupérer les données
    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Si la requête est réussie, analyser la réponse JSON
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        datadechet =
            jsonData.map((item) => item as Map<String, dynamic>).toList();
      });
    } else {
      print('Erreur lors de la récupération des données');
    }
  }



  Future<void> fetchLastDuree() async {
    final fullUrl = Uri.parse('${widget.url}/arret');

    final response = await http.get(fullUrl);

    if (response.statusCode == 200) {
      print('Response from backend: ${response.body}');
      List<dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.isNotEmpty) {
        setState(() {
          _lastDuree = jsonResponse.last["Duree"] as int;
        });
      } else {
        setState(() {
          _lastDuree = null; // Si aucune donnée
        });
      }
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  }




  void _fetchData() async {
    String fullUrl = '${widget.url}/nc';
    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        dataNc = jsonData.map((item) => item as Map<String, dynamic>).toList();
      });
    } else {
      print('Erreur lors de la récupération des données');
    }
  }

  void _submitForm1() async {
    if (selectedCause != null && quantityController.text.isNotEmpty) {
      String fullUrl = '${widget.url}/nc';
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'Type': selectedCause,
          'Quantite': int.parse(quantityController.text),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Données envoyées avec succès');
        setState(() {
          selectedCause = null; // Réinitialiser la sélection
          quantityController.clear(); // Effacer le champ de texte
        });
        _fetchData(); // Attendre que les données soient rafraîchies
      } else {
        print('Échec de l\'envoi des données : ${response.statusCode}');
        print('Réponse : ${response.body}');
      }
    }
  }

  void _deleteItem(int id) async {
    String fullUrl = '${widget.url}/nc/$id'; // URL to delete the item

    final response = await http.delete(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      print('Item deleted successfully');
      setState(() {
        dataNc.removeWhere(
            (item) => item['Id'] == id); // Remove the item from the local list
      });
    } else {
      print('Failed to delete item: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    quantityController.dispose();
    quantityController2.dispose();
    super.dispose();
  }

  void _showForm(int formIndex) {
    setState(() {
      _selectedForm = formIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Déclaration de ${widget.name} ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )),
        backgroundColor: navbar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Les 3 boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          _selectedForm == 0 ? Colors.white : Colors.black,
                      backgroundColor: _selectedForm == 0
                          ? Colors.blue
                          : Colors.white, // Bouton actif en bleu
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      textStyle: TextStyle(fontSize: 25),
                    ),
                    onPressed: () => _showForm(0),
                    child: Text("Déclaration Non Conforme"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          _selectedForm == 1 ? Colors.white : Colors.black,
                      backgroundColor: _selectedForm == 1
                          ? Colors.blue
                          : Colors.white, // Bouton actif en bleu
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      textStyle: TextStyle(fontSize: 25),
                    ),
                    onPressed: () => _showForm(1),
                    child: Text("Déclaration déchet"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          _selectedForm == 2 ? Colors.white : Colors.black,
                      backgroundColor: _selectedForm == 2
                          ? Colors.blue
                          : Colors.white, // Bouton actif en bleu
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      textStyle: TextStyle(fontSize: 25),
                    ),
                    onPressed: () => _showForm(2),
                    child: Text("Déclaration Alerte d'arrêt"),
                  ),
                ],
              ),

              SizedBox(height: 20),
              // Affichage des formulaires
              if (_selectedForm == 0) _buildForm1(),
              if (_selectedForm == 1) _buildForm2(),
              if (_selectedForm == 2) _buildForm3(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm1() {
    return Container(
      color: Color(0xFFFEBD00), // Fond global en jaune
      padding: EdgeInsets.all(10), // Espacement autour du formulaire
      child: Center(
        child: Container(
          // Largeur à 90% de l'écran
          padding: EdgeInsets.all(32), // Espacement interne du formulaire
          decoration: BoxDecoration(
            color: Colors.white, // Fond blanc pour le formulaire
            borderRadius: BorderRadius.circular(15), // Coins arrondis
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 5), // Ombre sous le formulaire
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Déclaration Non Conforme - ${widget.name}",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Form(
                    key: _formKey, // Ajoutez une GlobalKey<FormState>

                    child: Column(
                      children: [
                        // Champ de sélection avec taille fixe
                        SizedBox(
                            width: 400, // Taille fixe du champ
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Sélectionnez Cause",
                                border: OutlineInputBorder(),
                              ),
                              value: selectedCause != null &&
                                      [
                                        'Sur diamétre',
                                        'Ovalité',
                                        'Manque diamétre',
                                        'Epaisseur max',
                                        'Epaisseur min',
                                        'Longueur NC',
                                        'Poids/mètre NC',
                                        'défaut marquage'
                                      ].contains(selectedCause)
                                  ? selectedCause
                                  : null,
                              items: <String>[
                                'Sur diamétre',
                                'Ovalité',
                                'Manque diamétre',
                                'Epaisseur max',
                                'Epaisseur min',
                                'Longueur NC',
                                'Poids/mètre NC',
                                'défaut marquage'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCause = newValue;
                                });
                              },
                            )),
                        SizedBox(height: 20),
                        // Champ de texte avec taille fixe
                        SizedBox(
                          width: 400, // Taille fixe du champ
                          child: TextField(
                            controller: quantityController,
                            decoration: InputDecoration(
                              labelText: "Saisir la quantité",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(height: 30),
                        // Bouton soumis
                        ElevatedButton(
                          onPressed: _submitForm1,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Couleur du bouton
                            padding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 50), // Taille du bouton
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Valider",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 150,
                  ),
                  Image.asset('assets/images/mach.png')
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Les données Validées:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: 
                
                DataTable(
                  columnSpacing: 30.0,
                  headingRowColor: WidgetStateColor.resolveWith(
                    (states) => const Color.fromARGB(255, 0, 0, 0),
                  ),
                  dataRowColor: WidgetStateColor.resolveWith(
                    (states) => const Color.fromARGB(255, 255, 255, 255),
                  ),
                  border: TableBorder.all(
                    color: const Color.fromARGB(255, 175, 174, 174),
                    width: 1,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  columns: const <DataColumn>[
                    DataColumn(
                        label: Expanded(
                            child: Text('Date',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                )))),
                    DataColumn(
                        label: Expanded(
                            child: Text('Quantité',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                )))),
                    DataColumn(
                        label: Expanded(
                            child: Text('Cause',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                )))),
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      'Action',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ))),
                  ],
                  rows: dataNc.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item['Date'].toString())),
                      DataCell(Text(item['Quantite'].toString())),
                      DataCell(Text(item['Type'])),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                            
                              },
                            ),
                            IconButton(
                                onPressed: () {
                                  _deleteItem(item['Id']);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm2() {
    return Container(
      color: Color(0xFFFEBD00), // Fond global en jaune
      padding: EdgeInsets.all(10), // Espacement autour du formulaire
      child: Center(
        child: Container(
          // Largeur à 90% de l'écran
          padding: EdgeInsets.all(32), // Espacement interne du formulaire
          decoration: BoxDecoration(
            color: Colors.white, // Fond blanc pour le formulaire
            borderRadius: BorderRadius.circular(15), // Coins arrondis
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 5), // Ombre sous le formulaire
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Déclaration Déchet - ${widget.name}",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Form(
                    child: Column(
                      children: [
                        // Champ de sélection avec taille fixe
                        SizedBox(
                            width: 400, // Taille fixe du champ
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Sélectionnez Cause",
                                border: OutlineInputBorder(),
                              ),
                              value: selectedCause2 != null &&
                                      ['object 1', 'object2', 'object3']
                                          .contains(selectedCause2)
                                  ? selectedCause2
                                  : null,
                              items: <String>['object 1', 'object2', 'object3']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCause2 = newValue;
                                });
                              },
                            )),
                        SizedBox(height: 20),
                        // Champ de texte avec taille fixe
                        SizedBox(
                          width: 400, // Taille fixe du champ
                          child: TextField(
                            controller: quantityController2,
                            decoration: InputDecoration(
                              labelText: "Saisir la quantité",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        // Bouton soumis
                        ElevatedButton(
                          onPressed: _submitForm2,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Couleur du bouton
                            padding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 50), // Taille du bouton
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Valider",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 150,
                  ),
                  Image.asset('assets/images/mach.png')
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Les données Validées:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: 30.0,
                  headingRowColor: WidgetStateColor.resolveWith(
                    (states) => const Color.fromARGB(255, 0, 0, 0),
                  ),
                  dataRowColor: WidgetStateColor.resolveWith(
                    (states) => Colors.white,
                  ),
                  border: TableBorder.all(
                    color: const Color.fromARGB(255, 175, 174, 174),
                    width: 1,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  columns: const <DataColumn>[
                    DataColumn(
                        label: Expanded(
                            child: Text('Quantité',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                )))),
                    DataColumn(
                        label: Expanded(
                            child: Text('Cause',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                )))),
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      'Action',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ))),
                  ],
                  rows: datadechet.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item['Quantite'].toString())),
                      DataCell(Text(item['Type'])),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Ajouter ici la logique pour supprimer une entrée, si nécessaire
                          },
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
 Widget _buildForm3() {
    return Container(
      color: Color(0xFFFEBD00),
      padding: EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Container(
            width: 500,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Alerte De Production - ${widget.name}",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    SizedBox(width: 18),
                    Icon(Icons.warning, color: Colors.red, size: 20),
                  ],
                ),
                SizedBox(height: 20),
                Text("Cause d'arrêt:", style: TextStyle(color: Colors.red, fontSize: 18)),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Sélectionnez Cause",
                    border: OutlineInputBorder(),
                  ),
                  items: <String>[
                    'Panne électrique',
                    'Panne mécanique',
                    'Changement de série',
                    'Réglage',
                    'Nettoyage',
                    'Coupure utilité',
                    'Absence programme',
                    'Rupture MP',
                    'Maintenance préventive',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                ),
                SizedBox(height: 8),
           
               Text(
                "Durée d'arrêt: ${_lastDuree != null ? formatDuration(_lastDuree!) : '00:00:00'}",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
              
                SizedBox(height: 8),
               
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Valider L'alerte",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
  