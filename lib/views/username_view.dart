import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/username_provider.dart';
import '../utils/clipboard_service.dart';
import 'username_history_view.dart';

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
            // Result Display Card
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            username.isEmpty ? 'Tap Generate to create username' : username,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: username.isEmpty ? Colors.grey : null,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          tooltip: 'Copy to clipboard',
                          onPressed: username.isEmpty
                              ? null
                              : () => ClipboardService.copyToClipboard(
                                    context,
                                    username,
                                    itemType: 'Username',
                                  ),
                        ),
                      ],
                    ),
                    if (username.isNotEmpty) ...[
                      const Divider(height: 12),
                      Text(
                        'Length: ${username.length} characters',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
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

            // Active Pattern Blocks Box
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(120),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pattern Blocks Sequence:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        if (_tokens.isNotEmpty)
                          TextButton(
                            onPressed: () => setState(() => _tokens.clear()),
                            child: const Text('Clear All', style: TextStyle(color: Colors.redAccent)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_tokens.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text(
                            'No blocks added. Tap chips below to build pattern.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(_tokens.length, (index) {
                          final token = _tokens[index];
                          Color chipColor;
                          switch (token.type) {
                            case PatternTokenType.adjective:
                              chipColor = Colors.teal.withAlpha(60);
                              break;
                            case PatternTokenType.noun:
                              chipColor = Colors.indigo.withAlpha(60);
                              break;
                            case PatternTokenType.number:
                              chipColor = Colors.amber.withAlpha(60);
                              break;
                            case PatternTokenType.year:
                              chipColor = Colors.deepOrange.withAlpha(60);
                              break;
                            case PatternTokenType.separator:
                              chipColor = Colors.purple.withAlpha(60);
                              break;
                          }

                          return Chip(
                            backgroundColor: chipColor,
                            label: Text(token.label),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () => _removeToken(index),
                          );
                        }),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Block Palette (Add Blocks)
            const Text('Add Pattern Blocks:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text('Adjective'),
                  onPressed: () => _addToken(PatternTokenType.adjective),
                ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text('Noun'),
                  onPressed: () => _addToken(PatternTokenType.noun),
                ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text('2-Digit Num'),
                  onPressed: () => _addToken(PatternTokenType.number, '2'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text('3-Digit Num'),
                  onPressed: () => _addToken(PatternTokenType.number, '3'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text('Year'),
                  onPressed: () => _addToken(PatternTokenType.year),
                ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text('Separator (_)'),
                  onPressed: () => _addToken(PatternTokenType.separator, '_'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text('Separator (.)'),
                  onPressed: () => _addToken(PatternTokenType.separator, '.'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text('Separator (-)'),
                  onPressed: () => _addToken(PatternTokenType.separator, '-'),
                ),
              ],
            ),
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

            // Action Buttons
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Generate Username', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _tokens.isEmpty ? null : _generate,
            ),
            const SizedBox(height: 8),
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
