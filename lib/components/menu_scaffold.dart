import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:semperMade/config/router.dart';

class MenuScaffold extends StatelessWidget {
  const MenuScaffold({
    required this.child,
    required this.routeNames,
    super.key,
  });

  final Widget child;
  final List<String> routeNames;

  String _getCurrentRoute() {
    final lastMatch = router.routerDelegate.currentConfiguration.last;
    final matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : router.routerDelegate.currentConfiguration;
    final location = matchList.uri.toString();
    return location;
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = _getCurrentRoute();
    if (ResponsiveBreakpoints.of(context).largerThan(MOBILE)) {
      // Display AppBar with Row for wider screens
      return Scaffold(
        appBar: AppBar(
          title: const Text('SemperMade Demo'),
          actions: routeNames
              .map(
                (route) => TextButton(
                  onPressed: () {
                    if (route != currentRoute) {
                      // Replace the current route in the navigation stack
                      if (route == AppRoutes.record ||
                          route == AppRoutes.upload) {
                        context.go('${AppRoutes.home}$route');
                      } else {
                        context.go(route);
                      }
                    }
                  },
                  child: Text(route.substring(1)),
                ),
              )
              .toList(),
        ),
        body: child,
      );
    } else {
      // Display AppBar with Drawer for smaller screens
      return Scaffold(
        appBar: AppBar(
          title: const Text('SemperMade Demo'),
        ),
        drawer: Drawer(
          child: ListView(
            children: routeNames
                .map(
                  (route) => ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    title: Text(route),
                    onTap: () {
                      context.go('/$route');
                      Navigator.of(context).pop();
                    },
                  ),
                )
                .toList(),
          ),
        ),
        body: child,
      );
    }
  }
}
