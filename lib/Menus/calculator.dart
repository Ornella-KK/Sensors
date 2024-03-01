import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:navigation/theme.dart';
import 'package:provider/provider.dart';

class Calculator extends StatefulWidget {
  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String userInput = "";
  String result = "0";

  List<String> buttonList = [
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    '*',
    '1',
    '2',
    '3',
    '-',
    '0',
    'AC',
    '.',
    '+',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: themeProvider.getTheme.scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(
                      userInput,
                      style: TextStyle(
                        fontSize: 36,
                        color: themeProvider.getTheme.brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerRight,
                    child: Text(
                      result,
                      style: TextStyle(
                        fontSize: 48,
                        color: themeProvider.getTheme.brightness == Brightness.dark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.black),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton('7'),
                      CustomButton('8'),
                      CustomButton('9'),
                      CustomButton('/'),
                      CustomButton('C'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton('4'),
                      CustomButton('5'),
                      CustomButton('6'),
                      CustomButton('*'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton('1'),
                      CustomButton('2'),
                      CustomButton('3'),
                      CustomButton('-'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton('0'),
                      CustomButton('AC'),
                      CustomButton('.'),
                      CustomButton('='),
                      CustomButton('+'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget CustomButton(String value) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: getBgColor(value),
          onPrimary: getColor(value),
        ),
        onPressed: () => handleButtons(value),
        child: Text(
          value,
          style: TextStyle(
            fontSize: value == 'AC' || value == '.' ? 9.0 : 24.0,
            color: getColor(value),
          ),
        ),
      ),
    );
  }

  Color getColor(String text) {
    if (_isOperator(text)) {
      return Color.fromARGB(255, 252, 100, 100);
    }
    return Colors.black;
  }

  Color getBgColor(String text) {
    if (text == 'C' || text == 'AC') {
      return Color.fromARGB(255, 252, 100, 100);
    }
    return Color.fromRGBO(250, 250, 250, 1);
  }

  void handleButtons(String text) {
    if (text == 'AC') {
      setState(() {
        userInput = '';
        result = '0';
      });
      return;
    }

    if (text == 'C') {
      if (userInput.isNotEmpty) {
        setState(() {
          userInput = userInput.substring(0, userInput.length - 1);
          result = calculate();
        });
        return;
      } else {
        return null;
      }
    }

    if (text == '=') {
      setState(() {
        result = calculate();
        userInput = result;

        if (userInput.endsWith('.0')) {
          userInput = userInput.replaceAll('.0', '');
          return;
        }

        if (result.endsWith('.0')) {
          result = result.replaceAll('.0', '');
          return;
        }
      });
    } else {
      setState(() {
        userInput = userInput + text;
      });
    }
  }

  String calculate() {
    try {
      var exp = Parser().parse(userInput);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      return 'Error';
    }
  }

  bool _isOperator(String value) {
    return value == '/' || value == '*' || value == '+' || value == '-';
  }
}
