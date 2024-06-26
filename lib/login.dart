import 'package:fypmerchant/Components/alertDialog_widget.dart';
import 'package:fypmerchant/Components/button_widget.dart';
import 'package:fypmerchant/Components/textTitle_widget.dart';
import 'package:fypmerchant/Components/inputField_widget.dart';
import 'package:fypmerchant/Firebase/retrieve_data.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned(
            top: 90,
            left: -90,
            child: TitleWidget.blueTitle('SIGN IN'),
          ),

          Container(
              margin: const EdgeInsets.only(top:50.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children:[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      child: InputWidget.inputField('Username', Icons.person_outline, username),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      child: InputWidget.inputField('Password', Icons.lock, password),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 15),
                      child: ButtonWidget.buttonWidget('LOG IN', (){
                        if(username.text.isNotEmpty && password.text.isNotEmpty){
                          Checking().checkCredential(context, username.text, password.text);
                        }
                        else if(username.text.isEmpty || password.text.isEmpty){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialogWidget(title: 'Error', content: 'Ensure credential is valid');
                            },
                          );
                        }
                        else{
                          showDialog(context: context, builder: (BuildContext context){
                            return const AlertDialogWidget(title: 'Error', content: 'Unknown error');
                          });
                        }
                      }),
                    ),
                  ]
              )
          )
        ],
      ),
    );
  }
}
