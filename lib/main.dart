import 'package:calculo_varianca/pages/results_page.dart';
import 'package:calculo_varianca/providers/calculos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => CalculoProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPage = 0;
  List<Widget> pages = [HomePage(), ResultsPage()];

  @override
  Widget build(BuildContext context) {
    final calc = Provider.of<CalculoProvider>(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cálculo de Variância'),
          actions: [
            IconButton(
                onPressed: () {
                  calc.removeAll();
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: SingleChildScrollView(child: pages[currentPage]),
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: currentPage,
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
              icon: Icon(
                Icons.calculate,
                color: calc.isValidated() ? Colors.black : Colors.grey,
              ),
              label: 'Resultados',
            )
          ],
          onDestinationSelected: (index) {
            setState(() {
              calc.isValidated() ? currentPage = index : currentPage = 0;
            });
          },
        ),
      ),
    );
  }
}
