import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:guess_age/api.dart';

class GuessAge extends StatefulWidget {
  const GuessAge({Key? key}) : super(key: key);

  @override
  _GuessAgeState createState() => _GuessAgeState();
}

class _GuessAgeState extends State<GuessAge> {
  int year = 0;
  int month = 0;
  bool end = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GUESS TEACHER'S AGE"),),

      body: Container(
        color: Colors.yellow.shade100,
        child: _buildBody(),
      ),
    );
  }

  _buildBody(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Text(end ? "YOU ARE CORRECT" : "MAKE A GUESS",
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black45,
              ),
            ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: end ? _buildCorrectPage() : Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SpinBox(
                    decoration: const InputDecoration(labelText: "Year(s)",),
                    textStyle: const TextStyle(fontSize: 30),
                    min: 0,
                    value: 0,
                    onChanged: (value){
                      setState(() {
                        year = value as int;
                      });
                    },
                  ),
                  const SizedBox(height: 10,),
                  SpinBox(
                    decoration: const InputDecoration(labelText: "Month(s)",),
                    textStyle: const TextStyle(fontSize: 30),
                    min: 0,
                    max: 11,
                    value: 0,
                    onChanged: (value){
                      setState(() {
                        month = value as int;
                      });
                    },
                  ),
                  const SizedBox(height: 20,),
                  _submitButton(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildCorrectPage(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
            child: Text(
              "$year year(s) $month month(s)",
              style: const TextStyle(fontSize: 30),
            )
        ),
        const Icon(Icons.check, color: Colors.green, size: 120,),
      ],
    );
  }

  _submitButton(){
    return ElevatedButton(
        onPressed: _callApi,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("SUBMIT", style: TextStyle(fontSize: 20),),
        ),
    );
  }

  _callApi() async {
    var result = await Api().submit("guess_teacher_age", {
      "year": year,
      "month": month,
    });

    if(result["value"]) {
      setState(() {
        end = true;
      });
    }
    else {
      _dialog(result["text"]);
    }
  }

  _dialog(String text){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Result"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }
}
