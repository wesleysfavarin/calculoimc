import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _textInfo = "Informe seus dados.";
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
   void _resetField(){
     setState(() {
       weightController.text = "";
       heightController.text = "";
       _textInfo = "Informe seus dados.";
     });
   }

   void _calculate() {
     setState(() {

       double weight = double.parse(weightController.text);
       double height = double.parse(heightController.text) / 100;

            double imc = weight / (height *  height);
            if(imc < 18.6){
              _textInfo = "Abaixo do peso. (${imc.toStringAsPrecision(4)})";
            }

     });

   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aline Linda"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
              onPressed: _resetField,
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey ,
          child:   Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.person_outline,
                size: 120.0,
                color: Colors.deepOrange,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Peso (KG)",
                    labelStyle: TextStyle(color: Colors.deepOrange)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrange, fontSize: 25.0),
                controller: weightController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Informe seu peso.";
                    }
                  }
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Altura (cm)",
                    labelStyle: TextStyle(color: Colors.deepOrange)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrange, fontSize: 25.0),
                controller: heightController,
                validator: (value) {
                  if(value.isEmpty) {
                    return "Informe sua altura.";
                  }
                }
              ),
              Padding(
                padding:  EdgeInsets.only(top: 10.0, bottom:10.0),
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: (){
                      if(_formKey.currentState.validate())
                        _calculate();
                    },
                    child: Text("Calcular",style: TextStyle(color: Colors.white,fontSize: 22.0  )),
                    color: Colors.deepOrange,
                  ),
                ) ,
              ),Text(
                _textInfo,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrange,fontSize: 22.0),
              )
            ],
          ),
        )

      ),


    );
  }
}
