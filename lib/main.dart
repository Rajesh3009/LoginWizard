import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoginWizard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

final selectedIndexProvider = StateProvider<int>((ref) => 0);

class MyHomePage extends ConsumerWidget {
  MyHomePage({super.key});

  final List<Widget> _widgetOptions = <Widget>[
    Text('Home Page', style: TextStyle(fontSize: 24)),
    Text('Search Page', style: TextStyle(fontSize: 24)),
    Text('Profile Page', style: TextStyle(fontSize: 24)),
  ];
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('LoginWizard'),
      ),
      body: PageView.builder(
          controller: _pageController,
          itemCount: _widgetOptions.length,
          itemBuilder: (context, index) {
            return Center(child: _widgetOptions[index]);
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Username',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Password',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_rounded),
            label: 'About',
          ),
        ],
        currentIndex: ref.watch(selectedIndexProvider),
        selectedItemColor: Colors.blue,
        onTap: (index) {
          _pageController.jumpToPage(index);
          ref.read(selectedIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}
