import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: new ThemeData(
                primarySwatch: Colors.blueGrey,
      ),
      home: new Calculator(),
    );
  }
}

class CalculatorLayout extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    final mainState= MainState.of(context);
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor:  Colors.red[400],
        title: new Text("Standard Calculator"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child:Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.black87,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    mainState.inputValue ?? '0',
                    style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 50.0,
                    fontStyle: FontStyle.italic
                  ),
                  )
                ],
            ) ,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                children: <Widget>[
                 // makeBtn('C<%/'),
                  makeBtn('789x'),
                  makeBtn('456-'),
                  makeBtn('123+'),
                  makeBtn('C0/='),
                ],
            ),
          )
          )
        ],
      ),
    );
  }

Widget makeBtn(String row) {
    List<String> token = row.split("");
    return Expanded(
      flex: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: token
            .map((e) => CalculatorBtn(
                  keyvalue: e == '_' ? "+/-" : e == '<' ? '<=' : e,
                ))
            .toList(),
      ),
    );
  }
}


class Calculator extends StatefulWidget {

   @override
  CalculatorState createState() => new CalculatorState();
}

class CalculatorState extends State<Calculator> {
 String inputString="";
 double prevValue;
 String value="";
 String op='z';

 bool isNumber(String str){
   if(str== null){
     return false;
   }
   return double.parse(str, (e) => null) != null;
 }

 void onPressed(keyvalue){
   switch(keyvalue){
     case "C":
        op = null;
        prevValue = 0.0;
        value ="";
        setState(()=> inputString= "");
        break;
     case ".":
        break;
     case "x":
     case "+":
     case "-":
     case "/":
        op=keyvalue;
        value = '';
        prevValue = double.parse(inputString);
        setState(() {
          inputString = inputString+keyvalue;
                  
                });
                break;
     case "=":
        if(op != null){
          setState(() {
                      switch(op){
                        case "x":
                        inputString=(prevValue * double.parse(value)).toStringAsFixed(2);

                        break;
                        case "+":
                        inputString=(prevValue + double.parse(value)).toStringAsFixed(2);

                        break;
                        
                        case "-":
                        inputString=(prevValue - double.parse(value)).toStringAsFixed(2);

                        break;
                        
                        case "/":
                        inputString=(prevValue / double.parse(value)).toStringAsFixed(3);

                        break;
                        
                      }
                    });
                    op = null;
                    prevValue = double.parse(inputString);
                    value='';
                    break;
        }
        break;
     default:
        if (isNumber(keyvalue)) {
          if (op != null) {
            setState(() => inputString = inputString + keyvalue);
            value = value + keyvalue;
          } else {
            setState(() => inputString = "" + keyvalue);
            op = 'z';
          }
        } else {
          onPressed(keyvalue);
        }

   }
 }


@override
Widget build(BuildContext context){
  return MainState(
    inputValue: inputString,
    prevValue: prevValue,
    value: value,
    op: op,
    onPressed: onPressed,
    child: CalculatorLayout(),

  );
}
}

class MainState extends InheritedWidget{
  MainState({
    Key key,
    this.inputValue,
    this.prevValue,
    this.value,
    this.op,
    this.onPressed,
    Widget child  ,

  }):super(key: key, child: child);

  final String inputValue;
  final double prevValue; //first value
  final String value;//second value
  final String op;//operator
  final Function onPressed;

  static MainState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(MainState);
  }

  @override
  bool updateShouldNotify(MainState oldWidget){
    return inputValue != oldWidget.inputValue;
  }

}


class CalculatorBtn extends StatelessWidget{
  CalculatorBtn({this.keyvalue});

  final String keyvalue;

  @override
  Widget build(BuildContext context) {
    final mainState = MainState.of(context);
    return Expanded(
      flex: 2,
      child: FlatButton(
        shape: Border.all(
          color: Colors.black87,
          width: 2.0,
          style: BorderStyle.solid
        ),
        color: Colors.red[400],
        child: Text(
          keyvalue,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 35.0,
            color: Colors.black,
            fontStyle: FontStyle.italic
          )
      ),
      onPressed:() {
        mainState.onPressed(keyvalue);
      },
      ),
    );
  }
}



//   Widget makeBtn(String row){
//     List<String> token = row.split("");
//     return Expanded(
//       flex: 1,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: token.map((e) {
//           CalculatorBtn(keyvalue: e,
//           );
//         }).toList(),
//       ),

//     );
//   }
// }

