import 'package:flutter/material.dart';
import '../db/app_database.dart';
import '../localization/app_localizations.dart';
import '../models/contact.dart';

class ListPage extends StatefulWidget {
  final VoidCallback? onLanguageChanged;

  const ListPage({super.key, this.onLanguageChanged});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  late AppDatabase db;
  List<Contact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize Drift AppDatabase instance as specified in lecture notes
    db = AppDatabase();
    // 2. Load contacts from Drift database whenever application restarts
    _loadContactsFromDB();
  }

  Future<void> _loadContactsFromDB() async {
    try {
      final contactsData = await db.getAllContacts().get();
      if (mounted) {
        setState(() {
          _contacts = contactsData
              .map(
                (c) => Contact(
                  id: c.id,
                  firstName: c.firstName,
                  lastName: c.lastName,
                  phoneNumber: c.phoneNumber,
                  email: c.email,
                ),
              )
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    db.close();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _addContact() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    if (firstName.isEmpty && lastName.isEmpty && phone.isEmpty && email.isEmpty) {
      return;
    }

    try {
      // 1. Add newly created Contact item to Database using stored Drift saveContact function
      final id = await db.saveContact(firstName, lastName, phone, email);

      if (mounted) {
        setState(() {
          _contacts.insert(
            0,
            Contact(
              id: id,
              firstName: firstName,
              lastName: lastName,
              phoneNumber: phone,
              email: email,
            ),
          );

          // Clear TextFields so previous values are gone
          _firstNameController.clear();
          _lastNameController.clear();
          _phoneController.clear();
          _emailController.clear();
        });
      }
    } catch (e) {
      // Graceful fallback
    }
  }

  void _confirmDeleteContact(int index) {
    final contactToDelete = _contacts[index];

    // Show AlertDialog asking if user wants to delete item
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(translate('Delete Contact')),
        content: Text(translate('Do you want to delete this item?')),
        actions: [
          TextButton(
            onPressed: () {
              // Selecting "No" does not remove item
              Navigator.of(dialogContext).pop();
            },
            child: Text(translate('No')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              // 3. Delete item from Drift database when long-pressed and confirmed Yes
              if (contactToDelete.id != null) {
                try {
                  await db.deleteContact(contactToDelete.id!);
                } catch (e) {
                  // Fallback
                }
              }

              if (mounted) {
                setState(() {
                  _contacts.removeAt(index);
                });
              }
            },
            child: Text(translate('Yes')),
          ),
        ],
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
    if (widget.onLanguageChanged != null) {
      widget.onLanguageChanged!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate('Flutter Demo Home Page'),
          style: const TextStyle(color: Colors.black87),
        ),
        backgroundColor: const Color(0xFFD8B4F8), // Light purple background
        actions: [
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
            // Green Border Container enclosing 4 TextFields and Submit button
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  // 1. First name TextField
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: translate('First name'),
                      hintText: translate('Type here'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. Last name TextField
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: translate('Last name'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. Phone Number TextField
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: translate('Phone Number'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 4. Email Address TextField
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: translate('Email Address'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Submit / Add Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _addContact,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(translate('Submit')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Loading indicator or Contact List View or Empty State
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_contacts.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    translate('There are no contacts in the list'),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  final titleText =
                      '${contact.firstName} ${contact.lastName}'.trim();
                  final subtitleText =
                      '${contact.phoneNumber}${contact.phoneNumber.isNotEmpty && contact.email.isNotEmpty ? " • " : ""}${contact.email}';

                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(
                        titleText.isNotEmpty ? titleText : translate('Contact'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(subtitleText),
                      onLongPress: () => _confirmDeleteContact(index),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
