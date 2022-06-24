import 'package:calculo_varianca/providers/calculos_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CalculoProvider calc;
  late FocusNode myFocusNodeY;
  late FocusNode myFocusNodeX;

  final TextEditingController _nController = TextEditingController();
  final TextEditingController _glrController = TextEditingController();
  final TextEditingController _xController = TextEditingController();
  final TextEditingController _yController = TextEditingController();

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

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: textFieldBuilder(
                  'Quantidade Amostral', 'valor de n', _nController),
            ),
            Expanded(
              child:
                  textFieldBuilder('Grau de liberdade', 'GLR', _glrController),
            ),
          ],
        ),
        texFieldAndButtonBuilder('Adicione x', 'valor de x', _xController,
            myFocusNodeX, myFocusNodeY, calc.addX),
        texFieldAndButtonBuilder('Adicione y', 'valor de y', _yController,
            myFocusNodeY, myFocusNodeX, calc.addY),
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
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            calc.n = int.tryParse(_nController.text);
            calc.glRegressao = int.tryParse(_glrController.text);
          },
          child: const Text('Calcular'),
          style: ElevatedButton.styleFrom(
              fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 2),
              primary: Colors.black),
        )
      ],
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
            fixedSize: Size(20, 55),
          ),
          onPressed: () {
            setState(() {
              function(double.tryParse(controller.text));
              controller.text = '';
              focusNodeOut.requestFocus();
            });
          },
          child: Icon(Icons.add),
        ),
      ),
    ]);
  }

  Widget titleListBuilder(String title) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 2, top: 20),
        color: Colors.blue[200],
        child: ListTile(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget listBuilder(List calcList) {
    return Expanded(
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: calcList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
              color: Colors.blue[100],
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
}
