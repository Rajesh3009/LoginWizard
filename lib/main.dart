import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/views/password_view.dart';
import 'package:loginwizard/views/username_view.dart';
import 'package:window_manager/window_manager.dart';

import 'views/pin_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up window size for desktop platforms
  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS)) {
    await windowManager.ensureInitialized();
    
    WindowOptions windowOptions = const WindowOptions(
      size: Size(400, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'LoginWizard',
      minimumSize: Size(100, 100),
    );
    
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoginWizard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent,
          brightness: Brightness.dark,
        ),
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
    UsernameView(),
    PasswordView(),
    PinView(),
    Text('About Page', style: TextStyle(fontSize: 24)),
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
            return _widgetOptions[index];
          }),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: ThemeData().iconTheme.copyWith(color: Colors.yellow),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedItemColor: Colors.yellow,
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
            icon: Icon(Icons.pin),
            label: 'PIN',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: 'Settings',
          // ),
        ],
        currentIndex: ref.watch(selectedIndexProvider),
        onTap: (index) {
          _pageController.jumpToPage(index);
          ref.read(selectedIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}
