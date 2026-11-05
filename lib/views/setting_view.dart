import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/appdatabase.dart';
import '../provider/password_provider.dart';
import '../provider/pin_provider.dart';
import '../provider/theme_provider.dart';
import '../provider/username_history_provider.dart';
import '../utils/conts.dart';

class SettingView extends ConsumerStatefulWidget {
  const SettingView({super.key});

  @override
  ConsumerState<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends ConsumerState<SettingView> {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  bool _autoSave = true;
  int _clearClipboardSeconds = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final autoSave = await _prefs.getBool(autoSaveHistoryKey) ?? true;
    final clearSec = await _prefs.getInt(clipboardAutoClearSecondsKey) ?? 0;
    if (mounted) {
      setState(() {
        _autoSave = autoSave;
        _clearClipboardSeconds = clearSec;
      });
    }
  }

  Future<void> _updateAutoSave(bool val) async {
    setState(() => _autoSave = val);
    await _prefs.setBool(autoSaveHistoryKey, val);
  }

  Future<void> _updateClipboardSeconds(int seconds) async {
    setState(() => _clearClipboardSeconds = seconds);
    await _prefs.setInt(clipboardAutoClearSecondsKey, seconds);
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeModeProvider);
    final database = ref.read(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          // Section: Appearance
          const Text(
            'Appearance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.dark,
                        icon: Icon(Icons.dark_mode_outlined),
                        label: Text('Dark'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        icon: Icon(Icons.light_mode_outlined),
                        label: Text('Light'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.system,
                        icon: Icon(Icons.brightness_auto_outlined),
                        label: Text('System'),
                      ),
                    ],
                    selected: {currentTheme},
                    onSelectionChanged: (newSelection) {
                      ref.read(themeModeProvider.notifier).setThemeMode(newSelection.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section: Security & Clipboard
          const Text(
            'Security & Clipboard Guard',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.timer_outlined),
                    title: const Text('Auto-Clear Clipboard'),
                    subtitle: const Text('Automatically clears copied items to prevent snooping apps from reading them'),
                    trailing: DropdownButton<int>(
                      value: _clearClipboardSeconds,
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('Disabled')),
                        DropdownMenuItem(value: 30, child: Text('30 sec')),
                        DropdownMenuItem(value: 60, child: Text('60 sec')),
                        DropdownMenuItem(value: 120, child: Text('2 min')),
                      ],
                      onChanged: (val) {
                        if (val != null) _updateClipboardSeconds(val);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section: History & Privacy
          const Text(
            'History & Storage',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.history_toggle_off),
                  title: const Text('Auto-Save Generations to History'),
                  subtitle: const Text('Keep record of generated usernames, passwords, and PINs'),
                  value: _autoSave,
                  onChanged: _updateAutoSave,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.auto_delete_outlined),
                  title: const Text('Purge History Older Than 7 Days'),
                  subtitle: const Text('Deletes unstarred entries older than 1 week'),
                  trailing: TextButton(
                    onPressed: () async {
                      final count = await database.purgeHistoryOlderThan(const Duration(days: 7));
                      ref.invalidate(passwordHistoryProvider);
                      ref.invalidate(usernameHistoryProvider);
                      ref.invalidate(pinHistoryProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(count > 0
                                ? 'Purged $count old history entries.'
                                : 'No history older than 7 days found.'),
                          ),
                        );
                      }
                    },
                    child: const Text('Purge'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: About
          const Text(
            'About',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('LoginWizard'),
              subtitle: const Text('Version 1.1.0 • Offline Secure Credential Utility'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'LoginWizard',
                  applicationVersion: '1.1.0',
                  applicationIcon: const Icon(Icons.lock, size: 40, color: Colors.greenAccent),
                  children: const [
                    Text(
                      'LoginWizard helps generate secure passwords, Diceware passphrases, pattern-built usernames, and PINs entirely offline with cryptographically secure randomness.\n\nAll history and configurations remain private on your local device.',
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
