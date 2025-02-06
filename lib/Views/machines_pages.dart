import 'package:elmawssir/Models/Machines_Model.dart';
import 'package:elmawssir/ViewModels/Machines_ViewModels.dart';
import 'package:elmawssir/Views/Declaration_pages.dart';
import 'package:elmawssir/Views/Declation_pages.dart';
import 'package:elmawssir/Views/test_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MachinesPage extends StatelessWidget {
  const MachinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MachinesViewModel(),
      child: Scaffold(
        floatingActionButton: Consumer<MachinesViewModel>(
          builder: (context, viewModel, child) {
            return FloatingActionButton.small(
              onPressed: viewModel.toggleScrollDirection,
              tooltip: viewModel.isScrolledToBottom
                  ? 'Scroll to Top'
                  : 'Scroll to Bottom',
              child: Icon(
                viewModel.isScrolledToBottom
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                size: 30,
              ),
            );
          },
        ),
        appBar: AppBar(title: Text("Machines")),
        body: Consumer<MachinesViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              controller: viewModel.scrollController,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: viewModel.machines.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        final machine = viewModel.machines[index];
                        return _buildCard(machine, context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(Machine machine, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                color:  Color(0xFFFEBD00),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  machine.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                    print("Navigating to ${machine.url}");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                        Declation(
                        id:machine.id,
                        name: machine.name,
                        url: machine.url, // Passer l'URL
                      ),
                    ),
                  );
                },
              ),
            ),
            Image.asset(
              machine.imagePath,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}
