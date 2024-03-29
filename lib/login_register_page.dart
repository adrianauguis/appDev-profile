import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';
import 'reg_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  bool _passwordVisible = true;
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async{
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text
      );
      print(_controllerEmail.text);
    } on FirebaseAuthException catch (e){
      setState(() {
        errorMessage = e.message;
      });
    }
  }


  Widget _errorMessage(){
    return Text (errorMessage == '' ? '' : "Hmmmmm? $errorMessage");
  }

  Widget _submitButton(BuildContext context){
    return Container(
        child: ElevatedButton(
          onPressed: (){
            if (_formKey.currentState!.validate()) {
              signInWithEmailAndPassword();
            }
          },
          child: Text('Login'.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )
          ),
        )
    );
  }

  Widget _loginOrRegisterButton(){
    return TextButton(
        onPressed: (){
          setState(() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RegistrationPage()));
          });
        },
        child: const Text("Register Instead")
    );
  }

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF1D6),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(25, 40, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key:_formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30,),
                        const SizedBox(height: 30,),
                        const SizedBox(height: 30,),
                        const SizedBox(
                          height: 300,
                          width: 300,
                          child: InkWell(
                            child: Image(
                              image: AssetImage("assets/logo.png"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            controller: _controllerEmail,
                            decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: const BorderSide(color: Colors.grey)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: const BorderSide(color: Colors.red, width: 2.0))),
                            validator: (val) {
                              if(!(val!.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            obscureText: !_passwordVisible,
                            controller: _controllerPassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: const BorderSide(color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                              // Here is key idea
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        _errorMessage(),
                        _submitButton(context),
                        _loginOrRegisterButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }
}