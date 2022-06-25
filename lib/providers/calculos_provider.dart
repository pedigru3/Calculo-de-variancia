import 'dart:math';
import 'package:flutter/material.dart';

class CalculoProvider extends ChangeNotifier {
  List<double> listaX = [16, 30, 35, 70, 90, 120, 160, 237, 379];
  List<double> listaY = [14, 16, 19, 30, 31, 33, 35, 43, 50];

  // Quantidade Amostral
  int _n = 0;

// gl = Grau de liberdade
  int _glRegressao = 1;

  set n(int? value) {
    value != null ? _n = value : _n = 0;
  }

  int get n => _n;

  set glRegressao(int? value) {
    value != null ? _glRegressao = value : _glRegressao = 0;
  }

  int get glRegressao => _glRegressao;

  bool isEqual() {
    return listaX.length == listaY.length ? true : false;
  }

  bool isValidated() {
    if (listaX.isNotEmpty &&
        listaY.isNotEmpty &&
        isEqual() &&
        _n != 0 &&
        _glRegressao != 0) {
      return true;
    } else {
      return false;
    }
  }

  String seeXList() {
    String phrase = 'Lista de X: ';
    for (var i = 0; i < listaX.length; i++) {
      if (i == listaX.length - 1 && listaX.isNotEmpty) {
        phrase += '${listaX[i]}.';
      } else {
        phrase += '${listaX[i]}, ';
      }
    }
    return phrase;
  }

  String seeYList() {
    String phrase = 'Lista de Y: ';
    for (var i = 0; i < listaY.length; i++) {
      if (i == listaY.length - 1 && listaY.isNotEmpty) {
        phrase += '${listaY[i]}.';
      } else {
        phrase += '${listaY[i]}, ';
      }
    }
    return phrase;
  }

  void addX(double? value) {
    if (value != null) {
      listaX.add(value);
    }
    notifyListeners();
  }

  void addY(double? value) {
    if (value != null) {
      listaY.add(value);
    }
    notifyListeners();
  }

  void removeX(index) {
    listaX.removeAt(index);
    notifyListeners();
  }

  void removeY(index) {
    listaY.removeAt(index);
    notifyListeners();
  }

  void removeAll() {
    listaX.clear();
    listaY.clear();
    notifyListeners();
  }

  int glResidual() {
    return _n - 2;
  }

  int glTotal() {
    return _n - 1;
  }

  double somaListaX() {
    if (listaX.isNotEmpty) {
      return listaX.reduce((accumulated, element) => accumulated + element);
    } else {
      return 0;
    }
  }

  double somaListaY() {
    if (listaY.isNotEmpty) {
      return listaY.reduce((accumulated, element) => accumulated + element);
    } else {
      return 0;
    }
  }

  double listaXvezeslistaY() => somaListaX() * somaListaY();

  double somaXQuadrado() {
    double soma = 0;
    for (var element in listaX) {
      soma += pow(element, 2);
    }
    return soma;
  }

  double somaYQuadrado() {
    double soma = 0;
    for (var element in listaY) {
      soma += pow(element, 2);
    }
    return soma;
  }

  double sqRegressao() {
    double somaXvezesY = 0;
    for (var i = 0; i < listaX.length; i++) {
      somaXvezesY += (listaX[i] * listaY[i]);
    }
    return pow(somaXvezesY - (listaXvezeslistaY() / _n), 2) /
        (somaXQuadrado() - (pow(somaListaX(), 2) / _n));
  }

  double sqTotal() {
    return somaYQuadrado() - (pow(somaListaY(), 2) / _n);
  }

  double sqResidual() {
    return sqTotal() - sqRegressao();
  }

  double quadradoMedioRegressao() {
    return sqRegressao() / _glRegressao;
  }

  double quadradoMedioResidual() {
    return sqResidual() / glResidual();
  }

  double fCalculado() {
    return quadradoMedioRegressao() / quadradoMedioResidual();
  }

  //shared Preferencs

}
