import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuScaffold extends StatelessWidget {
  const MenuScaffold({
    required this.child,
    required this.routeNames,
    super.key,
  });

  final Widget child;
  final List<String> routeNames;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 600) {
          // Display AppBar with Row for wider screens
          return Scaffold(
            appBar: AppBar(
              title: const Text('SemperMade Demo'),
              actions: routeNames
                  .map(
                    (route) => TextButton(
                      onPressed: () => context.go('/$route'),
                      child: Text(route),
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
      },
    );
  }
}
