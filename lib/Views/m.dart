import 'package:elmawssir/Views/Colors_pages.dart';
import 'package:elmawssir/Views/test_page.dart';
import 'package:flutter/material.dart';
import 'package:elmawssir/Views/Declation_pages.dart';
import 'package:elmawssir/Views/appbar_page.dart';

void main() {
  runApp(const Machine());
}
class Machine extends StatefulWidget {
  const Machine({
    super.key,
  });

  @override
  State<Machine> createState() => _MachinesPageState();
}

class _MachinesPageState extends State<Machine> {
  final ScrollController _listScrollController = ScrollController();
  bool _isScrolledToBottom = false;
  // Mapping entre les IDs de lignes et leurs URLs
  final Map<int, String> lineUrls = {
    6: 'http://localhost:3001/',
    7: 'http://localhost:3002/',
    9: 'http://localhost:3003/',
    10: 'http://localhost:3004/',
    11: 'http://localhost:3005/',
  };
  void _toggleScrollDirection() {
    if (_listScrollController.hasClients) {
      if (_isScrolledToBottom) {
        _listScrollController.animateTo(
          0.0,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      } else {
        final position = _listScrollController.position.maxScrollExtent;
        _listScrollController.animateTo(
          position,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }

      setState(() {
        _isScrolledToBottom = !_isScrolledToBottom;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: _toggleScrollDirection,
        tooltip: _isScrolledToBottom ? 'Scroll to Top' : 'Scroll to Bottom',
        child: Icon(
          _isScrolledToBottom ? Icons.arrow_upward : Icons.arrow_downward,
          size: 30,
        ),
      ),
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        controller: _listScrollController,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Utilisation de GridView pour afficher les cartes
              GridView.count(
                shrinkWrap: true, // Permet de ne pas occuper tout l'espace vertical
                crossAxisCount: 3, // Nombre de colonnes dans la grille
                crossAxisSpacing: 20, // Espacement horizontal entre les cartes
                mainAxisSpacing: 20, // Espacement vertical entre les cartes
                padding: EdgeInsets.all(16),
                children: [
                  _buildCard(
                    id: 6,
                    name: 'Ligne 6',
                    imagePath: 'assets/images/mach.png',
                  ),
                  _buildCard(
                    id: 7,
                    name: 'Ligne 7',
                    imagePath: 'assets/images/mach.png',
                  ),
                  _buildCard(
                    id: 9,
                    name: 'Ligne 9',
                    imagePath: 'assets/images/mach.png',
                  ),
                  _buildCard(
                    id: 10,
                    name: 'Ligne 10',
                    imagePath: 'assets/images/mach.png',
                  ),
                  _buildCard(
                    id: 11,
                    name: 'Ligne 11',
                    imagePath: 'assets/images/mach.png',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modification de _buildCard pour accepter l'ID et le nom de la ligne
  Widget _buildCard({
    required int id,
    required String name,
    required String imagePath,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: shadowcolor,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                color: navbar,
                boxShadow: [
                  BoxShadow(
                    color: shadowcolor,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: textcolor,
                  ),
                ),
                onTap: () {
                  // Récupérer l'URL associée à l'ID
                  final url = lineUrls[id];
                  if (url != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Declation2(
                          id: id,
                          name: name,
                          url: url, // Passer l'URL
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Image.asset(
              imagePath,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}



