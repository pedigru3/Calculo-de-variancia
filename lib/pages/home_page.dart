import 'package:calculo_varianca/providers/calculos_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CalculoProvider calc;
  late FocusNode myFocusNodeY;
  late FocusNode myFocusNodeX;

  final _nController = TextEditingController();
  final _glrController = TextEditingController();
  final _xController = TextEditingController();
  final _yController = TextEditingController();

  @override
  void initState() {
    super.initState();

    myFocusNodeY = FocusNode();
    myFocusNodeX = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNodeY.dispose();
    myFocusNodeX.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    calc = Provider.of<CalculoProvider>(context);
    _nController.text = calc.listaX.length.toString();
    _glrController.text = '1';

    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: textFieldBuilder(
                    'Quantidade Amostral', 'valor de n', _nController),
              ),
              Expanded(
                child: textFieldBuilder(
                    'Grau de liberdade', 'GLR', _glrController),
              ),
            ],
          ),
          texFieldAndButtonBuilder('Adicione x', 'valor de x', _xController,
              myFocusNodeX, myFocusNodeY, calc.addX),
          texFieldAndButtonBuilder('Adicione y', 'valor de y', _yController,
              myFocusNodeY, myFocusNodeX, calc.addY),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        calc.n = int.tryParse(_nController.text);
                        calc.glRegressao = int.tryParse(_glrController.text);
                        calc.setValidated();
                        if (!calc.isValidated) {
                          errorMessage(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      child: const Text('Calcular'),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    calc.removeAll();
                    calc.setValidated();
                  },
                  child: const Text('Limpar tudo'),
                ),
              ],
            ),
          ),
          const Divider(),
          Row(
            children: [
              titleListBuilder('Lista de X'),
              titleListBuilder('Lista de Y'),
            ],
          ),
          Row(
            children: [
              listBuilder(calc.listaX),
              listBuilder(calc.listaY),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              calc.isEqual() ? '' : 'As listas devem ser iguais!',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget textFieldBuilder(String text, String hintText, TextEditingController c,
      {FocusNode? f}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
          focusNode: f,
          controller: c,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: text,
              border: const OutlineInputBorder(),
              hintText: hintText)),
    );
  }

  Widget texFieldAndButtonBuilder(
    String label,
    String hintText,
    TextEditingController controller,
    FocusNode focusNodeIn,
    FocusNode focusNodeOut,
    Function function,
  ) {
    return Row(children: [
      Expanded(
          child: textFieldBuilder(label, hintText, controller, f: focusNodeIn)),
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(20, 55),
          ),
          onPressed: () {
            if (controller.text == '' ||
                double.tryParse(controller.text) == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.red,
                  content: Text('Valor inválido!')));
            } else {
              setState(() {
                function(double.tryParse(controller.text));
                controller.text = '';
                focusNodeOut.requestFocus();
              });
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    ]);
  }

  Widget titleListBuilder(String title) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 2, top: 20),
        child: ListTile(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromARGB(255, 9, 61, 103)),
          ),
        ),
      ),
    );
  }

  Widget listBuilder(List calcList) {
    return Expanded(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: calcList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
              child: ListTile(
                title: Text(
                  '${calcList[index]}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
    );
  }

  void errorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.blue,
      content: Text('Algo deu errado. Verifique os valores.'),
      duration: Duration(seconds: 2),
    ));
  }
}
