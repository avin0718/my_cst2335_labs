import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String imageSource = 'images/question-mark.jpg';
  bool isEnglish = true;

  void checkPassword() {
    String password = passwordController.text;

    setState(() {
      if (password == 'ASDF') {
        imageSource = 'images/login_light.png';
      } else {
        imageSource = 'images/loginStop.png';
      }
    });
  }

  void switchLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'Login Page' : 'Page de connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: loginController,
                decoration: InputDecoration(
                  labelText: isEnglish ? 'Login Name' : 'Nom de connexion',
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: isEnglish ? 'Password' : 'Mot de passe',
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: checkPassword,
                child: Text(isEnglish ? 'Login' : 'Connexion'),
              ),

              const SizedBox(height: 20),

              Image.asset(
                imageSource,
                width: 300,
                height: 300,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: switchLanguage,
                child: Text(
                  isEnglish ? 'Switch to French' : 'Passer à l\'anglais',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}