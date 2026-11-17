/// Contact model representing a contact entry in the SQLite database and list
class Contact {
  final int? id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;

  Contact({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
  });

  /// Convert Contact object to Map for SQLite insertion
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
    };
  }

  /// Create Contact object from Map retrieved from SQLite database
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int?,
      firstName: map['first_name'] as String? ?? '',
      lastName: map['last_name'] as String? ?? '',
      phoneNumber: map['phone_number'] as String? ?? '',
      email: map['email'] as String? ?? '',
    );
  }
}
