import 'dart:io' show Platform, Process;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../localization/app_localizations.dart';
import '../repository/profile_repository.dart';
import 'list_page.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final ProfileRepository repository;
  final VoidCallback? onLanguageChanged;

  const ProfilePage({
    super.key,
    required this.username,
    required this.repository,
    this.onLanguageChanged,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with pre-loaded data from repository
    _firstNameController =
        TextEditingController(text: widget.repository.firstName);
    _lastNameController =
        TextEditingController(text: widget.repository.lastName);
    _phoneController =
        TextEditingController(text: widget.repository.phoneNumber);
    _emailController = TextEditingController(text: widget.repository.email);

    // Add listeners to TextEditingControllers to save data to EncryptedSharedPreferences on change
    _firstNameController.addListener(() {
      widget.repository.firstName = _firstNameController.text;
      widget.repository.saveData();
    });

    _lastNameController.addListener(() {
      widget.repository.lastName = _lastNameController.text;
      widget.repository.saveData();
    });

    _phoneController.addListener(() {
      widget.repository.phoneNumber = _phoneController.text;
      widget.repository.saveData();
    });

    _emailController.addListener(() {
      widget.repository.email = _emailController.text;
      widget.repository.saveData();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Helper method to launch URLs (tel:, sms:, mailto:)
  /// Displays AlertDialog if phone/SMS is not supported on this device or if launching fails
  Future<void> _launchUrlScheme(String urlString) async {
    final Uri uri = Uri.parse(urlString);

    // Check if platform is Desktop (Windows/macOS/Linux) which does not support telephone dialer or SMS messaging
    bool isDesktop = defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS;

    bool isPhoneOrSms = uri.scheme == 'tel' || uri.scheme == 'sms';

    if (isDesktop && isPhoneOrSms) {
      if (mounted) {
        _showErrorDialog(urlString);
      }
      return;
    }

    try {
      if (await canLaunchUrl(uri)) {
        bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched) {
          launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
        if (!launched && mounted) {
          _showErrorDialog(urlString);
        }
      } else {
        if (mounted) {
          _showErrorDialog(urlString);
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(urlString);
      }
    }
  }

  /// Shows AlertDialog when URL scheme is not supported on this device
  void _showErrorDialog(String urlString) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translate('Error')),
        content: Text(
          '${translate("URL is not supported on this device.")}\n($urlString)',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(translate('OK')),
          ),
        ],
      ),
    );
  }

  void _launchTelephone() {
    final phone = _phoneController.text.trim();
    final url = phone.isNotEmpty ? 'tel:$phone' : 'tel:';
    _launchUrlScheme(url);
  }

  void _launchSms() {
    final phone = _phoneController.text.trim();
    final url = phone.isNotEmpty ? 'sms:$phone' : 'sms:';
    _launchUrlScheme(url);
  }

  Future<void> _launchMail() async {
    final email = _emailController.text.trim();

    // On Windows, explicitly launch Microsoft Outlook desktop app
    if (!kIsWeb && Platform.isWindows) {
      try {
        final result = await Process.run('cmd', [
          '/c',
          'start',
          'outlook.exe',
          '/c',
          'ipm.note',
          if (email.isNotEmpty) '/m',
          if (email.isNotEmpty) email,
        ]);

        if (result.exitCode == 0) {
          return;
        }
      } catch (e) {
        // Fallback to Outlook Web if desktop outlook.exe command fails
      }

      // Fallback: Open Outlook Web directly
      final outlookWebUrl = email.isNotEmpty
          ? 'https://outlook.live.com/default.aspx?rru=compose&to=${Uri.encodeComponent(email)}'
          : 'https://outlook.live.com/default.aspx?rru=compose';

      final Uri uri = Uri.parse(outlookWebUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }

    // Standard mailto: protocol for mobile/other platforms
    final url = email.isNotEmpty ? 'mailto:$email' : 'mailto:';
    _launchUrlScheme(url);
  }

  void _toggleLanguage() {
    setState(() {
      if (AppLocalizations.currentLanguage == 'en') {
        AppLocalizations.currentLanguage = 'es';
      } else {
        AppLocalizations.currentLanguage = 'en';
      }
    });
    if (widget.onLanguageChanged != null) {
      widget.onLanguageChanged!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final welcomeText = '${translate("Welcome Back")} ${widget.username}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate('Profile Page'),
          style: const TextStyle(color: Colors.black87),
        ),
        backgroundColor: const Color(0xFFD8B4F8),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Welcome Back Text Widget as required by Mark 1
            Container(
              padding: const EdgeInsets.all(12.0),
              color: Colors.deepPurple.shade50,
              child: Text(
                welcomeText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Green Border Container matching lab mockup
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  // 1. First Name TextField
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: translate('First Name'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Last Name TextField
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: translate('Last Name'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Phone Number TextField with Telephone and SMS buttons inside Row using Flexible
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: translate('Phone Number'),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _launchTelephone,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                          minimumSize: Size.zero,
                        ),
                        child: const Icon(Icons.phone),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: _launchSms,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                          minimumSize: Size.zero,
                        ),
                        child: const Icon(Icons.message),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 4. Email address TextField with Mail button inside Row using Flexible
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: translate('Email address'),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _launchMail,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                          minimumSize: Size.zero,
                        ),
                        child: const Icon(Icons.email),
                      ),
                    ],
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
