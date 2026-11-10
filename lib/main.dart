import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'repository/profile_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = ProfileRepository();
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final ProfileRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo Home Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(repository: repository),
    );
  }
}
