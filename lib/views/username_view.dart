import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/username_provider.dart';
import '../widgets/credential_display_card.dart';
import '../widgets/pattern_blocks_card.dart';
import '../widgets/token_palette.dart';
import 'username_history_view.dart';

/// Screen for generating usernames using customizable pattern blocks and presets
class UsernameView extends ConsumerStatefulWidget {
  const UsernameView({super.key});

  @override
  ConsumerState<UsernameView> createState() => _UsernameViewState();
}

class _UsernameViewState extends ConsumerState<UsernameView> {
  final List<PatternToken> _tokens = [
    PatternToken(id: '1', type: PatternTokenType.adjective),
    PatternToken(id: '2', type: PatternTokenType.separator, value: '_'),
    PatternToken(id: '3', type: PatternTokenType.noun),
    PatternToken(id: '4', type: PatternTokenType.separator, value: '_'),
    PatternToken(id: '5', type: PatternTokenType.number, value: '2'),
  ];

  UsernameCasing _casing = UsernameCasing.lowercase;
  int _counter = 10;

  void _addToken(PatternTokenType type, [String value = '']) {
    _counter++;
    setState(() {
      _tokens.add(PatternToken(
        id: 'token_$_counter',
        type: type,
        value: value,
      ));
    });
  }

  void _removeToken(int index) {
    setState(() {
      _tokens.removeAt(index);
    });
  }

  void _applyPreset(String preset) {
    setState(() {
      _tokens.clear();
      _counter += 10;
      if (preset == 'gamer') {
        _tokens.addAll([
          PatternToken(id: 'p_1', type: PatternTokenType.adjective),
          PatternToken(id: 'p_2', type: PatternTokenType.noun),
          PatternToken(id: 'p_3', type: PatternTokenType.number, value: '2'),
        ]);
        _casing = UsernameCasing.titleCase;
      } else if (preset == 'classic') {
        _tokens.addAll([
          PatternToken(id: 'p_1', type: PatternTokenType.adjective),
          PatternToken(id: 'p_2', type: PatternTokenType.separator, value: '_'),
          PatternToken(id: 'p_3', type: PatternTokenType.noun),
          PatternToken(id: 'p_4', type: PatternTokenType.separator, value: '_'),
          PatternToken(id: 'p_5', type: PatternTokenType.number, value: '2'),
        ]);
        _casing = UsernameCasing.lowercase;
      } else if (preset == 'clean') {
        _tokens.addAll([
          PatternToken(id: 'p_1', type: PatternTokenType.adjective),
          PatternToken(id: 'p_2', type: PatternTokenType.noun),
        ]);
        _casing = UsernameCasing.lowercase;
      } else if (preset == 'year') {
        _tokens.addAll([
          PatternToken(id: 'p_1', type: PatternTokenType.noun),
          PatternToken(id: 'p_2', type: PatternTokenType.separator, value: '.'),
          PatternToken(id: 'p_3', type: PatternTokenType.year),
        ]);
        _casing = UsernameCasing.lowercase;
      }
    });
    _generate();
  }

  void _generate() {
    ref.read(usernameProvider.notifier).generateFromTokens(_tokens, casing: _casing);
  }

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(usernameProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Generated Result Display Card
            CredentialDisplayCard(
              text: username,
              itemType: 'Username',
              hintText: 'Tap Generate to create username',
            ),
            const SizedBox(height: 10),

            // Main Generate Action Button
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Generate Username', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _tokens.isEmpty ? null : _generate,
            ),
            const SizedBox(height: 14),

            // Quick Presets
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                const Text('Presets:', style: TextStyle(fontWeight: FontWeight.w600)),
                ActionChip(
                  label: const Text('Classic'),
                  onPressed: () => _applyPreset('classic'),
                ),
                ActionChip(
                  label: const Text('Gamer'),
                  onPressed: () => _applyPreset('gamer'),
                ),
                ActionChip(
                  label: const Text('Minimal'),
                  onPressed: () => _applyPreset('clean'),
                ),
                ActionChip(
                  label: const Text('Year Tag'),
                  onPressed: () => _applyPreset('year'),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Pattern Blocks Display Card
            PatternBlocksCard(
              tokens: _tokens,
              onRemoveToken: _removeToken,
              onClearAll: () => setState(() => _tokens.clear()),
            ),
            const SizedBox(height: 12),

            // Token Palette Chips
            TokenPalette(onAddToken: _addToken),
            const SizedBox(height: 14),

            // Casing Options
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                const Text('Casing: ', style: TextStyle(fontWeight: FontWeight.w600)),
                ChoiceChip(
                  label: const Text('lowercase'),
                  selected: _casing == UsernameCasing.lowercase,
                  onSelected: (val) {
                    if (val) setState(() => _casing = UsernameCasing.lowercase);
                  },
                ),
                ChoiceChip(
                  label: const Text('TitleCase'),
                  selected: _casing == UsernameCasing.titleCase,
                  onSelected: (val) {
                    if (val) setState(() => _casing = UsernameCasing.titleCase);
                  },
                ),
                ChoiceChip(
                  label: const Text('UPPERCASE'),
                  selected: _casing == UsernameCasing.uppercase,
                  onSelected: (val) {
                    if (val) setState(() => _casing = UsernameCasing.uppercase);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            OutlinedButton.icon(
              icon: const Icon(Icons.history),
              label: const Text('View Username History'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsernameHistory()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
