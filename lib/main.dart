import 'package:calculo_varianca/pages/results_page.dart';
import 'package:calculo_varianca/providers/calculos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => CalculoProvider(),
    child: const MaterialWidget(),
  ));
}

class MaterialWidget extends StatelessWidget {
  const MaterialWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final skafoldKey = GlobalKey();
  int currentPage = 0;
  VoidCallback? onpressed = (() => print('olá mundo'));

  List<Widget> pages = [const HomePage(), const ResultsPage()];

  @override
  Widget build(BuildContext context) {
    final calc = Provider.of<CalculoProvider>(context);
    return Scaffold(
        key: skafoldKey,
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
                color: calc.isValidated ? Colors.black : Colors.grey,
              ),
              label: 'Resultados',
            )
          ],
          onDestinationSelected: (index) {
            setState(() {
              if (calc.isValidated || index == 0) {
                currentPage = index;
              } else {
                currentPage = 0;
                errorMessage(context);
              }
            });
          },
        ));
  }

  void errorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.blue,
      content: Text('Verifique as listas ou calcule.'),
      duration: Duration(seconds: 2),
    ));
  }
}
