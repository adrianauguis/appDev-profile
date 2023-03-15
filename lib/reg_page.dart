import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../auth.dart';
import 'home_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerid = TextEditingController();
  final TextEditingController _controllersection = TextEditingController();
  final TextEditingController _controllercalendar = TextEditingController();
  final TextEditingController _controlleraboutMe = TextEditingController();
  DateTime? addDate;
  bool checkedValue = false;
  bool checkboxValue = false;
  String? errorMessage = '';

  Widget _errorMessage(){
    return Text (errorMessage == '' ? '' : "Hmmmmm? $errorMessage");
  }

  Future<void> createUserWithEmailAndPassword() async{
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        id: int.parse(_controllerid.text),
        name: _controllerName.text,
        section: _controllersection.text,
        birthdate: addDate,
        aboutMe: _controlleraboutMe.text
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future _selectDate(DateTime date) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1990),
        lastDate: DateTime(2025));
    // if (picked != null) {
    //   final TimeOfDay? time =
    //   await showTimePicker(context: context, initialTime: TimeOfDay.now());
    //   if (time != null) {
    //     return DateTime(
    //       picked.year,
    //       picked.month,
    //       picked.day,
    //       time.hour,
    //       time.minute,
    //     );
    //   }
    // }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF1D6),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(25, 0, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30,),
                        const SizedBox(height: 30,),
                        const SizedBox(height: 30,),
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: InkWell(
                            child: Container(
                              child: const Image(
                                image: AssetImage("assets/logo.png"),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            controller: _controllerEmail,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              label: Text("Email")
                            ),
                            validator: (val) {
                              if(!(val!.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                return "Enter a valid email address";
                              }
                            },
                          ),

                        ),
                        const SizedBox(height: 10,),
                        Container(
                          child: TextFormField(
                            controller: _controllerPassword,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Password")
                            ),
                            validator: (value) {
                              return (value == '') ? 'Please enter your password' : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          child: TextFormField(
                            controller: _controllerName,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Name")),
                            validator: (value) {
                              return (value == '') ? 'Please enter your name' : null;
                            },
                          ),

                        ),
                        const SizedBox(height: 10,),
                        Container(
                          child: TextFormField(
                            controller: _controllerid,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("ID")),
                            validator: (value) {
                              return (value == '') ? 'Please enter your id' : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          height: 60,
                          child: TextFormField(
                            controller: _controllersection,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Section")),
                            validator: (value) {
                              return (value == '') ? 'Please enter your section' : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 60,
                          child: TextFormField(
                            readOnly: true,
                            controller: _controllercalendar,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Calendar',
                              prefixIcon: InkWell(
                                child: const Icon(Icons.calendar_today),
                                onTap: ()async{
                                  DateTime d = DateTime.now();
                                  addDate = await _selectDate(d);
                                  String formattedDate = DateFormat('E, d MMM yyyy').format(addDate!);
                                  _controllercalendar.text = formattedDate;
                                },
                              ),
                            ),
                            validator: (value) {
                              return (value == '')
                                  ? 'Please enter a date and time'
                                  : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: _controlleraboutMe,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "About me",
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValue = value!;
                                            state.didChange(value);
                                          });
                                        }),
                                    const Text("I accept all terms and conditions.", style: TextStyle(color: Colors.grey),),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Theme.of(context).errorColor,fontSize: 12,),
                                  ),
                                )
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'You need to accept terms and conditions';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Register".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () async{
                              if (_formKey.currentState!.validate()) {
                                await createUserWithEmailAndPassword();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const HomePage()
                                    ),
                                        (Route<dynamic> route) => false
                                );
                              }
                            },
                          ),
                        ),
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