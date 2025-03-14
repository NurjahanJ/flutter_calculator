import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool isDarkMode = true;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: CalculatorScreen(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  CalculatorScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = "";
  String result = "0";
  List<String> history = [];
  bool resultCalculated =
      false; // Indicates that the last action was a calculation

  void onButtonClick(String value) {
    setState(() {
      if (value == "C") {
        input = "";
        result = "0";
        resultCalculated = false;
      } else if (value == "=") {
        try {
          result = evalExpression(input);
          history.add("$input = $result");
          input = result;
          resultCalculated = true; // Mark that we just calculated a result
        } catch (e) {
          result = "Error";
          input = "";
          resultCalculated = true;
        }
      } else {
        if (resultCalculated) {
          // If the last action was a calculation...
          if ("0123456789.".contains(value)) {
            // For digits (and decimal), start a new input
            input = value;
          } else {
            // For operators, continue the calculation with the current result
            input += value;
          }
          resultCalculated = false;
        } else {
          input += value;
        }
      }
    });
  }

  String evalExpression(String expression) {
    try {
      expression = expression.replaceAll("x", "*").replaceAll("÷", "/");
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return "Error";
    }
  }

  Widget buildButton(String text) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () => onButtonClick(text),
        child: Text(text, style: TextStyle(fontSize: 24)),
      ),
    );
  }

  void showHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Calculation History"),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: history.map((e) => Text(e)).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
        actions: [
          IconButton(
            icon: Icon(
                widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () => widget.toggleTheme(),
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: showHistoryDialog,
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(24),
              child: Text(
                input.isEmpty ? result : input,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(
            children: [
              Row(children: [
                buildButton("7"),
                buildButton("8"),
                buildButton("9"),
                buildButton("/")
              ]),
              Row(children: [
                buildButton("4"),
                buildButton("5"),
                buildButton("6"),
                buildButton("x")
              ]),
              Row(children: [
                buildButton("1"),
                buildButton("2"),
                buildButton("3"),
                buildButton("-")
              ]),
              Row(children: [
                buildButton("C"),
                buildButton("0"),
                buildButton("."),
                buildButton("+")
              ]),
              Row(children: [buildButton("=")]),
            ],
          ),
        ],
      ),
    );
  }
}
