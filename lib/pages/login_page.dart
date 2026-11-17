import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../repository/profile_repository.dart';
import 'list_page.dart';
import 'profile_page.dart';

class LoginPage extends StatefulWidget {
  final ProfileRepository repository;

  const LoginPage({super.key, required this.repository});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Image source variable initialized to question mark image as required by lab instructions
  String imageSource = 'images/question-mark.png';

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    // Load stored profile data and login credentials asynchronously
    await widget.repository.loadData();
    bool credentialsLoaded = await widget.repository.loadCredentials();

    if (credentialsLoaded && mounted) {
      setState(() {
        _usernameController.text = widget.repository.savedUsername;
        _passwordController.text = widget.repository.savedPassword;
        imageSource = widget.repository.savedImageSource;
      });

      // Show SnackBar informing user that previous credentials have been reloaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(translate('Previous login name and password loaded')),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      // Check if password is strictly "ASDF" as specified in lab instructions
      if (password != 'ASDF') {
        setState(() {
          imageSource = 'images/loginStop.png'; // Change image to stop sign
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(translate('Invalid password!')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      // Password is "ASDF" -> Correct password!
      setState(() {
        imageSource = 'images/login_light.png'; // Change image to light bulb
      });

      // Show AlertDialog asking user if they want to save username & password
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: Text(translate('Save Credentials')),
          content: Text(
            translate(
              'Would you like to save your username and password for next time?',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                // User chose NO: clear EncryptedSharedPreferences
                await widget.repository.clearCredentials();
                if (mounted) {
                  _navigateToProfile(username);
                }
              },
              child: Text(translate('No')),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                // User chose YES: save to EncryptedSharedPreferences including image state
                await widget.repository.saveCredentials(
                  username,
                  password,
                  imageSource: 'images/login_light.png',
                );
                if (mounted) {
                  _navigateToProfile(username);
                }
              },
              child: Text(translate('Yes')),
            ),
          ],
        ),
      );
    }
  }

  void _navigateToProfile(String username) {
    // Show SnackBar saying "Welcome Back" followed by login name
    final welcomeMessage = '${translate("Welcome Back")} $username';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(welcomeMessage),
        duration: const Duration(seconds: 3),
      ),
    );

    // Navigate to ProfilePage
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          username: username,
          repository: widget.repository,
          onLanguageChanged: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  void _toggleLanguage() {
    setState(() {
      if (AppLocalizations.currentLanguage == 'en') {
        AppLocalizations.currentLanguage = 'es';
      } else {
        AppLocalizations.currentLanguage = 'en';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate('Flutter Demo Home Page'),
          style: const TextStyle(color: Colors.black87),
        ),
        backgroundColor: const Color(0xFFD8B4F8), // Light purple as shown in screenshots
        actions: [
          IconButton(
            icon: const Icon(Icons.contacts, color: Colors.black87),
            tooltip: translate('Contact List'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ListPage(
                    onLanguageChanged: () {
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          ),
          TextButton.icon(
            onPressed: _toggleLanguage,
            icon: const Icon(Icons.language, color: Colors.black87),
            label: Text(
              AppLocalizations.currentLanguage.toUpperCase(),
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // 1. Username / Login TextField
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: translate('Login'),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return translate('Please enter username and password');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 2. Password TextField (obscureText: true)
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: translate('Password'),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return translate('Please enter username and password');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // 3. Login ElevatedButton
              Center(
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    translate('Login'),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // 4. 300x300 Image displaying imageSource (question mark -> light bulb / stop sign)
              Center(
                child: Image.asset(
                  imageSource,
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.help_outline,
                      size: 150,
                      color: Colors.deepPurple,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
