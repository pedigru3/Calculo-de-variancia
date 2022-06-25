import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/calculos_provider.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calc = Provider.of<CalculoProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FractionColumnWidth(.25),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(),
        children: [
          TableRow(children: [
            cellTitleBuilder('CV'),
            cellTitleBuilder('GL'),
            cellTitleBuilder('SQ'),
            cellTitleBuilder('QM'),
            cellTitleBuilder('Fcalc'),
          ]),
          TableRow(children: [
            cellTitleBuilder('Regressão'),
            cellBuilder(calc.glRegressao.toStringAsFixed(2)),
            cellBuilder(calc.sqRegressao().toStringAsFixed(2)),
            cellBuilder(calc.quadradoMedioRegressao().toStringAsFixed(2)),
            cellBuilder(calc.fCalculado().toStringAsFixed(2)),
          ]),
          TableRow(children: [
            cellTitleBuilder('Residuo'),
            cellBuilder(calc.glResidual().toStringAsFixed(2)),
            cellBuilder(calc.sqResidual().toStringAsFixed(2)),
            cellBuilder(calc.quadradoMedioResidual().toStringAsFixed(2)),
            cellBuilder('--'),
          ]),
          TableRow(children: [
            cellTitleBuilder('Total'),
            cellBuilder(calc.glTotal().toStringAsFixed(2)),
            cellBuilder(calc.sqTotal().toStringAsFixed(2)),
            cellBuilder('--'),
            cellBuilder('--'),
          ]),
        ],
      ),
    );
  }

  Widget cellTitleBuilder(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      )),
    );
  }

  Widget cellBuilder(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: Center(
          child: Text(
        text,
      )),
    );
  }
}
