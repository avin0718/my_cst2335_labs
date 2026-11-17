import 'package:flutter/material.dart';
import '../db/app_database.dart';
import '../localization/app_localizations.dart';
import '../models/contact.dart';
import '../widgets/details_widget.dart';

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
  Contact? _selectedContact;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize Drift AppDatabase instance
    db = AppDatabase();
    // Load contacts from database
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

    int? id;
    try {
      // 1. Add newly created Contact item to Database using stored Drift saveContact function
      id = await db.saveContact(firstName, lastName, phone, email);
    } catch (e) {
      // Fallback
    }

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
  }

  /// 3. Deletes item from list and database
  Future<void> _deleteContact(Contact contact) async {
    final idToDelete = contact.id;

    if (mounted) {
      setState(() {
        _contacts.removeWhere((c) =>
            (idToDelete != null && c.id == idToDelete) ||
            (c.firstName == contact.firstName &&
                c.lastName == contact.lastName &&
                c.phoneNumber == contact.phoneNumber &&
                c.email == contact.email));

        if (_selectedContact?.id == contact.id ||
            (_selectedContact?.firstName == contact.firstName &&
                _selectedContact?.lastName == contact.lastName)) {
          // Clear selection when item is deleted so DetailsPage no longer shows
          _selectedContact = null;
        }
      });
    }

    if (idToDelete != null) {
      try {
        await db.deleteContact(idToDelete);
      } catch (e) {
        // Fallback
      }
    }
  }

  /// 4. Sets selectedItem variable back to null
  void _closeDetails() {
    setState(() {
      _selectedContact = null;
    });
  }

  /// 1 & 2. Handles item selection depending on screen orientation / layout
  void _onContactTapped(Contact contact, bool isWideScreen) {
    setState(() {
      _selectedContact = contact;
    });

    // 2. On phone / portrait mode, show details on a full page replacing list
    if (!isWideScreen) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(translate('Item Details')),
              backgroundColor: const Color(0xFFD8B4F8),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: DetailsWidget(
                contact: contact,
                onDelete: () async {
                  await _deleteContact(contact);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                onClose: () {
                  _closeDetails();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ),
      );
    }
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

  Widget _buildMasterList(bool isWideScreen) {
    return SingleChildScrollView(
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
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: translate('First name'),
                    hintText: translate('Type here'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: translate('Last name'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: translate('Phone Number'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: translate('Email Address'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
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

          // Contact ListView or Empty State
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

                final isSelected = _selectedContact?.id == contact.id ||
                    (_selectedContact?.firstName == contact.firstName &&
                        _selectedContact?.lastName == contact.lastName);

                return Card(
                  elevation: isSelected ? 4 : 1,
                  color: isSelected ? Colors.deepPurple.shade50 : null,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(
                      titleText.isNotEmpty ? titleText : translate('Contact'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.deepPurple : Colors.black87,
                      ),
                    ),
                    subtitle: Text(subtitleText),
                    // 1. Changed long-press to Tap gesture as required
                    onTap: () => _onContactTapped(contact, isWideScreen),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen layout mode (Tablet/Desktop/Landscape vs Phone/Portrait)
    final mediaQuery = MediaQuery.of(context);
    final isWideScreen = mediaQuery.size.width >= 600 ||
        mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate('Flutter Demo Home Page'),
          style: const TextStyle(color: Colors.black87),
        ),
        backgroundColor: const Color(0xFFD8B4F8),
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
      body: isWideScreen
          // 1. Tablet / Desktop / Landscape Mode: Master-Detail Two-Pane Layout
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Master Pane: Form and Contact List
                Expanded(
                  flex: 1,
                  child: _buildMasterList(true),
                ),
                const VerticalDivider(width: 1),
                // Right Detail Pane: Shows DetailsWidget when item selected
                Expanded(
                  flex: 1,
                  child: _selectedContact != null
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: DetailsWidget(
                            contact: _selectedContact!,
                            onDelete: () => _deleteContact(_selectedContact!),
                            onClose: _closeDetails,
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.touch_app_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  translate('Select a contact to view details'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            )
          // 2. Phone / Portrait Mode: Single-Pane Layout
          : _buildMasterList(false),
    );
  }
}
