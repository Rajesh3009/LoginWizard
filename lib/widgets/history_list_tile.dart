import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/provider/password_provider.dart';
import 'package:loginwizard/database/appdatabase.dart';

class HistoryListTile extends StatefulWidget {
  final String password;
  final DateTime createdAt;
  final int id;
  final WidgetRef ref;
  final ProviderOrFamily provider;
  final Function(int id) deleteItemAction; // Add deleteItemAction parameter

  const HistoryListTile({
    Key? key,
    required this.password,
    required this.createdAt,
    required this.id,
    required this.ref,
    required this.provider,
    required this.deleteItemAction, // Require deleteItemAction
  }) : super(key: key);

  @override
  State<HistoryListTile> createState() => _HistoryListTileState();
}

class _HistoryListTileState extends State<HistoryListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: SelectableText(widget.password),
      subtitle: Text(widget.createdAt.toString()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.password));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.deleteItemAction(widget.id); // Use the passed delete action
              widget.ref.invalidate(widget.provider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Deleted successfully')),
              );
            },
          ),
        ],
      ),
    );
  }
}
