import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/contact.dart';

/// Details widget displaying Item Name, Quantity / Details, and Database ID
/// Contains "Delete" and "Close" buttons as specified in Week 9 / Lab 8 instructions.
class DetailsWidget extends StatelessWidget {
  final Contact contact;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const DetailsWidget({
    super.key,
    required this.contact,
    required this.onDelete,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final itemName = '${contact.firstName} ${contact.lastName}'.trim();

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    translate('Item Details'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: translate('Close'),
                  onPressed: onClose,
                ),
              ],
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 12),

            // 1. Database ID
            Row(
              children: [
                const Icon(Icons.key, color: Colors.deepPurple, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${translate("Database ID")}: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${contact.id ?? "N/A"}',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. Item Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.person, color: Colors.deepPurple, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${translate("Item Name")}: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    itemName.isNotEmpty ? itemName : translate('Contact'),
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 3. Phone Number
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.deepPurple, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${translate("Phone Number")}: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    contact.phoneNumber.isNotEmpty ? contact.phoneNumber : 'N/A',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 4. Email Address
            Row(
              children: [
                const Icon(Icons.email, color: Colors.deepPurple, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${translate("Email Address")}: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    contact.email.isNotEmpty ? contact.email : 'N/A',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Action Buttons: Delete & Close
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 3. Delete button
                ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: Text(translate('Delete')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                // 4. Close button
                OutlinedButton.icon(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                  label: Text(translate('Close')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
