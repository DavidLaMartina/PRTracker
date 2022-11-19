import 'package:flutter/material.dart';
import 'package:prtracker/views/adaptive_navigation.dart';

const List<RoutedNavigationDestination> destinations = [
  RoutedNavigationDestination(
      label: 'Home', icon: Icon(Icons.home), route: '/'),
  RoutedNavigationDestination(
      label: 'New Record', icon: Icon(Icons.note), route: '/editRecord'),
];

class RoutedNavigationDestination {
  final String route;
  final String label;
  final Icon icon;
  final Widget? child;

  const RoutedNavigationDestination(
      {required this.route,
      required this.label,
      required this.icon,
      this.child});
}

class RootLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  static const _switcherKey = ValueKey('switcherKey');
  static const _navigationRailKey = ValueKey('navigationRailKey');

  const RootLayout(
      {super.key, required this.child, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, dimensions) {
      void onSelected(int index) {
        final destination = destinations[index];
        if (ModalRoute.of(context)?.settings.name != destination.route) {
          Navigator.pushNamed(context, destination.route);
        }
      }

      return AdaptiveNavigation(
          key: _navigationRailKey,
          destinations: destinations
              .map((dest) =>
                  NavigationDestination(icon: dest.icon, label: dest.label))
              .toList(),
          selectedIndex: currentIndex,
          onDestinationSelected: onSelected,
          child: Column(children: [
            Expanded(child: _Switcher(key: _switcherKey, child: child))
          ]));
    });
  }
}

class _Switcher extends StatelessWidget {
  final Widget child;

  const _Switcher({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    // Account for desktop / non-mobile here??
    return AnimatedSwitcher(
      key: key,
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: child,
    );
  }
}
