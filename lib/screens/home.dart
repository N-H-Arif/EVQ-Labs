import 'package:flutter/material.dart';
import 'package:godd/models/university.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:passwordfield/passwordfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<University>? universities;
  bool boarding = true;
  String username = "";
  String password = "";
  String uniname = "";
  bool shouldDisplay = false;
  final textController = TextEditingController();
  String usernames = "";
  bool isSubmitDisabled = true;
  int i = 0;

  updateData({String name = "", String country = ""}) {
    setState(() {
      universities = null;
      boarding = false;
    });

    University.getData(name: name, country: country).then((value) {
      setState(() {
        universities = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void checkSubmitEnabled() {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    var passNonNullValue = password;
    setState(() {
      isSubmitDisabled = username.isEmpty ||
          password.isEmpty ||
          (password.length < 8) ||
          (!regex.hasMatch(passNonNullValue)) ||
          uniname.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("UniSearch"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Enter a university name to get the details",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.limeAccent,
                            hintText: ""),
                        onChanged: (String value) {
                          if (value.length >= 3) {
                            uniname = value;
                            updateData(name: value);
                          }
                          checkSubmitEnabled();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Enter a username",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.limeAccent,
                            hintText: ""),
                        onChanged: (String values) {
                          setState(() {
                            username = values;
                          });
                          checkSubmitEnabled();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Enter password",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: PasswordField(
                        backgroundColor: Colors.limeAccent.withOpacity(1.0),
                        errorMessage: '''
                  - A uppercase letter
                  - A lowercase letter
                  - A digit
                  - A special character
                  - A minimum length of 8 characters
                   ''',
                        hintText: "",
                        inputDecoration: PasswordDecoration(),
                        onChanged: (String value) {
                          if (value.length >= 8) {
                            setState(() {
                              password = value;
                            });
                          }
                          checkSubmitEnabled();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Submit"),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19.0),
                        ),
                        onPressed: isSubmitDisabled
                            ? null
                            : () {
                                setState(() {
                                  usernames = textController.text;
                                  shouldDisplay = !shouldDisplay;
                                });
                              },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    if (shouldDisplay) Text('username: $usernames'),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: boarding
                      ? const Center(child: Text(""))
                      : universities == null
                          ? const Center(child: CircularProgressIndicator())
                          : ListView(
                              padding: const EdgeInsets.only(top: 20),
                              children:
                                  universities!.map((University university) {
                                return Card(
                                  child: Column(
                                    children: [
                                      Text(
                                        university.name,
                                        style: textTheme.headline6,
                                      ),
                                      Text(university.country),
                                      ElevatedButton(
                                        onPressed: () {
                                          launch(university.webPage);
                                        },
                                        child: const Text("Go To Website"),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
