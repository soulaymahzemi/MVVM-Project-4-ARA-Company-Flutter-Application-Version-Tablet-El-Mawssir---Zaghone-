

/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Declation2 extends StatefulWidget {
  final int id;
  final String name;
  final String url;

  const Declation2({
    Key? key,
    required this.id,
    required this.name,
    required this.url,
  }) : super(key: key);

  @override
  _DeclationState createState() => _DeclationState();
}

class _DeclationState extends State<Declation2> {
  late String _selectedType;
  late TextEditingController _quantiteController;

  @override
  void initState() {
    super.initState();
    _selectedType = "string";  // Default value for the type
    _quantiteController = TextEditingController();
  }

  Future<void> sendData() async {
    final uri = Uri.parse('${widget.url}/nc'); // Your backend URL
    final headers = {'Content-Type': 'application/json'};

    // Prepare the data to send
    final data = {
      "Quantite": int.tryParse(_quantiteController.text) ?? 0,  // Ensure it's an integer
      "Type": _selectedType,
    };

    // Send the POST request
    final response = await http.post(
      uri,
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('Data sent successfully: ${response.body}');
      // Handle success (e.g., show a confirmation message)
    } else {
      print('Failed to send data: ${response.statusCode}');
      // Handle error (e.g., show an error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _quantiteController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Quantite'),
            ),
            DropdownButton<String>(
              value: _selectedType,
              items: ['string', 'anotherType'].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendData,
              child: Text('Envoyer'),
            ),
          ],
        ),
      ),
    );
  }
}


*/





import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Declation2 extends StatefulWidget {
  final int id;
  final String name;
  final String url;

  const Declation2({
    Key? key,
    required this.id,
    required this.name,
    required this.url,
  }) : super(key: key);

  @override
  _DeclationState createState() => _DeclationState();
}

class _DeclationState extends State<Declation2> {
  late Future<int?> _lastDuree;

  @override
  void initState() {
    super.initState();
    _lastDuree = fetchLastDuree();
  }

  Future<int?> fetchLastDuree() async {
    final fullUrl = Uri.parse('${widget.url}/arret');

    final response = await http.get(fullUrl);

    if (response.statusCode == 200) {
      print('Response from backend: ${response.body}');
      List<dynamic> jsonResponse = json.decode(response.body);
      
      if (jsonResponse.isNotEmpty) {
        // Récupérer le dernier élément de la liste et extraire "Duree"
        return jsonResponse.first["Duree"] as int;
      }
      return null; // Si la liste est vide, renvoyer null
    } else {
      print('Failed to load data: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: FutureBuilder<int?>(
        future: _lastDuree,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            return Center(
              child: Text(
                'Dernière durée enregistrée : ${snapshot.data!}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          }
        },
      ),
    );
  }
}
