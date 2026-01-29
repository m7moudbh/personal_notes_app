import 'package:flutter/material.dart';
import 'package:mnote_app/utils/app_localizations.dart';
import 'package:mnote_app/screens/all_notes_screen.dart';
import 'package:mnote_app/screens/categories_screen.dart';
import 'package:mnote_app/screens/favorites_screen.dart';


String tr(BuildContext context, String key) {
  return AppLocalizations.of(context)!.translate(key);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<HomeScreen> {
  int _currentIndex = 1;
  DateTime? _lastPressedAt;


  final ValueNotifier<int> _refreshNotifier = ValueNotifier<int>(0);


  void _refreshAllScreens() {
    _refreshNotifier.value++;
  }

  @override
  void dispose() {
    _refreshNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (_currentIndex != 1) {
          setState(() {
            _currentIndex = 1;
          });
          return;
        }

        final now = DateTime.now();
        final maxDuration = const Duration(seconds: 2);
        final isWarning = _lastPressedAt == null ||
            now.difference(_lastPressedAt!) > maxDuration;

        if (isWarning) {
          _lastPressedAt = now;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tr(context, 'press_again_to_exit')),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            CategoriesScreen(refreshNotifier: _refreshNotifier, onRefresh: _refreshAllScreens),
            AllNotesScreen(refreshNotifier: _refreshNotifier, onRefresh: _refreshAllScreens),
            FavoritesScreen(refreshNotifier: _refreshNotifier, onRefresh: _refreshAllScreens),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.folder),
              label: tr(context, 'categories'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.add_circle),
              label: tr(context, 'all_notes'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.star),
              label: tr(context, 'favorites'),
            ),
          ],
        ),
      ),
    );
  }
}