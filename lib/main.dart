import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

var blue = Colors.blue[700];
var black = Colors.black;
var white = Colors.white;
var transparent = Colors.transparent;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Country _selected;
  String _selectedNum;
  int numberState = 0;
  final myController = TextEditingController();

  Widget buildHeaders() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Register',
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontSize: 28,
                  color: black,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 7,),
            Text(
              numberState==0?'What country are you currently in?':'Whats your phone number?',
              style: TextStyle(
                  fontSize: 18,
                  color: black
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSelector() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: CountryPicker(
            dense: false,
            showFlag: true,  //displays flag, true by default
            showDialingCode: true, //displays dialing code, false by default
            showName: true, //displays country name, true by default
            showCurrency: false, //eg. 'British pound'
            showCurrencyISO: false, //eg. 'GBP'
            onChanged: (Country country) {
              setState(() {
                _selected = country;
                _selectedNum = country.dialingCode;
              });
            },
            selectedCountry: _selected,
          ),
        ),
      ),
    );
  }

  Widget buildSelected() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CountryPicker(
                dense: true,
                showFlag: true,  //displays flag, true by default
                onChanged: (Country country) {
                  setState(() {
                    _selected = country;
                    _selectedNum = country.dialingCode;
                  });
                },
                selectedCountry: _selected,
              ),
              SizedBox(width: 2,),
              Text(
                _selectedNum,
                style: TextStyle(
                    fontSize: 18,
                    color: black
                ),
              ),
              SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.only(top:7, bottom: 7),
                child: VerticalDivider(thickness: .5, color: Colors.black,),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Center(
                  child: TextFormField(
                    controller: myController,
                    cursorColor: Colors.grey,
                    keyboardType: TextInputType.phone,
                    keyboardAppearance: Brightness.light,
                    style: TextStyle(
                        fontSize: 14,
                        color: black
                    ),
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '224 224 224',
                        hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[400]
                        )
                    ),
//                  validator: (value) {
//                    return value.length<10?'Please enter a correct phone number':null;
//                  },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInstruction() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
        child: Text(
          'You will be sent a Verification code via SMS, please ensure the \nnumber you used is yours',
          textAlign: TextAlign.justify,
          style: TextStyle(
              fontSize: 14,
              color: Colors.grey
          ),
        ),
      ),
    );
  }

  Widget buildButton() {
    return GestureDetector(
      onTap: () {
        print(_selected.asset);
        setState(() {
          if(numberState==0) {
            numberState=1;
          }
          else{
            numberState=0;
          }
        });

      },
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Container(
          height: 55,
          width: double.infinity,
          decoration: BoxDecoration(
              color: blue,
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          child: Center(
            child: Text(
              'NEXT',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: white
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 50,),
          buildHeaders(),
          SizedBox(height: 40,),
          numberState==0?buildSelector():buildSelected(),
          numberState==0?SizedBox(height: 40,):SizedBox(height: 20,),
          numberState==0?Container():buildInstruction(),
          numberState==0?Container():SizedBox(height: 20,),
          buildButton()
        ],
      ),
    );
  }
}
