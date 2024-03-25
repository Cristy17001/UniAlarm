import 'dart:convert';
import 'dart:io' as io;

import 'package:html/dom.dart';
import 'package:html/parser.dart';

import 'Alarm.dart';

void main() async {
  var schedule = List.generate(30, (_) => List.filled(6, ""));
  List<String> hours = [];
  final file = io.File('bin\\horario_antonio.html');
  String contents = await file.readAsString(encoding: latin1);

  Document document = parse(contents);

  Element? table = document.querySelector('table.horario');

  int n_row = 0;
  int n_column = 0;

  for (Element column in table!.querySelectorAll('tr > td[class]')) {
    if (column.classes.contains('k')) {
      n_row++;
      n_column = 0;
      hours.add(column.text);
    }
    if (column.classes.contains('horas') && !column.classes.contains('k')) {
      // While the space was already visited
      while (schedule[n_row][n_column] == 'v') {n_column++;}
      schedule[n_row][n_column] = 'v';
    }
    // In case it is a theoretical class propagation need to occur
    else if (column.classes.contains('TE')) {
      int rowspan = int.parse(column.attributes['rowspan']!);
      while (schedule[n_row][n_column] == 'v') {n_column++;}
      // Construct the result
      var auxiliar = [];
      String result = "Teorica " + (rowspan*30).toString() + "min";
      for (Element data in column.querySelectorAll('a')) {
        auxiliar.add(data);
        result += '-' + data.text;
      }

      Alarm alarm = Alarm.new(auxiliar[0].text, "(T)", auxiliar[1].text, auxiliar[2].text, auxiliar[3].text, n_column, rowspan*30, hours[n_row-1]);
      alarm.draw();
      // Assign the value inside the schedule
      schedule[n_row][n_column] = result;

      // Propagate the rowSpan marking as visited
      for (int i = n_row+1; i < n_row+rowspan; i++) {
        schedule[i][n_column] = 'v';
      }
    }
    // In case it is a laboratorial propagation need to occur
    else if (column.classes.contains('PL')) {
      int rowspan = int.parse(column.attributes['rowspan']!);
      while (schedule[n_row][n_column] == 'v') {n_column++;}

      // Construct the result
      var auxiliar = [];
      String result = "Laboratoria " + (rowspan*30).toString() + "min";
      for (Element data in column.querySelectorAll('a')) {
        auxiliar.add(data);
        result += '-' + data.text;
      }

      Alarm alarm = Alarm.new(auxiliar[0].text, "(PL)", auxiliar[1].text, auxiliar[2].text, auxiliar[3].text, n_column, rowspan*30, hours[n_row-1]);
      alarm.draw();

      // Assign the value inside the schedule
      schedule[n_row][n_column] = result;

      // Propagate the rowSpan marking as visited
      for (int i = n_row+1; i < n_row+rowspan; i++) {
        schedule[i][n_column] = 'v';
      }
    }
    // In case it is a practical class propagation need to occur
    else if (column.classes.contains('TP')) {
      int rowspan = int.parse(column.attributes['rowspan']!);
      while (schedule[n_row][n_column] == 'v') {n_column++;}

      // Construct the result
      var auxiliar = [];
      String result = "Pratica " + (rowspan*30).toString() + "min";
      for (Element data in column.querySelectorAll('a')) {
        auxiliar.add(data);
        result += '-' + data.text;
      }

      Alarm alarm = Alarm.new(auxiliar[0].text, "(TP)", auxiliar[1].text, auxiliar[2].text, auxiliar[3].text, n_column, rowspan*30, hours[n_row-1]);
      alarm.draw();

      // Assign the value inside the schedule
      schedule[n_row][n_column] = result;

      // Propagate the rowSpan marking as visited
      for (int i = n_row+1; i < n_row+rowspan; i++) {
        schedule[i][n_column] = 'v';
      }
    }
    else {n_column--;}
    n_column++;
  }
}
