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
  List<Widget> pages = [const HomePage(), const ResultsPage()];

  @override
  Widget build(BuildContext context) {
    final calc = Provider.of<CalculoProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/background-calc.png'),
              ),
            ),
          ),
          elevation: 0,
          toolbarHeight: 100,
          centerTitle: true,
          title: const Text(
            'Cálculo de Variância',
            style: TextStyle(fontSize: 24),
          ),
        ),
        body: SingleChildScrollView(child: pages[currentPage]),
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: currentPage,
          destinations: [
            const NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
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
