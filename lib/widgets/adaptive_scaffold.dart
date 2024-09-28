import 'package:flutter/material.dart';

bool _isLargeScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 960.0;
}

bool _isMediumScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 640.0;
}

class AdaptiveScaffoldDestination {
  final String title;
  final IconData icon;

  const AdaptiveScaffoldDestination({
    required this.title,
    required this.icon,
  });
}

class AdaptiveScaffold extends StatefulWidget {
  final Widget? title;
  final List<Widget> actions;
  final Widget? body;
  final int currentIndex;
  final List<AdaptiveScaffoldDestination> destinations;
  final ValueChanged<int>? onNavigationIndexChange;
  final FloatingActionButton? floatingActionButton;

  const AdaptiveScaffold({
    this.title,
    this.body,
    this.actions = const [],
    required this.currentIndex,
    required this.destinations,
    this.onNavigationIndexChange,
    this.floatingActionButton,
    super.key,
  });

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  @override
  Widget build(BuildContext context) {
    if (_isLargeScreen(context)) {
      return Row(
        children: [
          Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            backgroundColor: const Color(0xFFACB3CC),
            child: Column(
              children: [
                DrawerHeader(
                  child: Center(
                    child: widget.title,
                  ),
                ),
                for (var d in widget.destinations)
                  ListTile(
                    leading: Icon(
                      d.icon,
                      color: widget.destinations.indexOf(d) == widget.currentIndex ? Colors.black : Colors.black54,
                    ),
                    title: Text(
                      d.title,
                      style: TextStyle(
                        color: widget.destinations.indexOf(d) == widget.currentIndex ? Colors.black : Colors.black45,
                      ),
                    ),
                    selected:
                        widget.destinations.indexOf(d) == widget.currentIndex,
                        selectedTileColor: const Color.fromARGB(255, 198, 199, 201),
                        hoverColor: const Color.fromARGB(255, 198, 199, 201),
                    onTap: () => _destinationTapped(d),
                  ),
              ],
            ),
          ),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.grey[300],
          ),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                actions: widget.actions,
              ),
              body: widget.body,
              
            ),
          ),
        ],
      );
    }

    if (_isMediumScreen(context)) {
      return Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          
          title: widget.title,
          actions: widget.actions,
        ),
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: const Color(0xFFACB3CC),
              leading: widget.floatingActionButton,
              destinations: [
                ...widget.destinations.map(
                  (d) => NavigationRailDestination(
                    icon: Icon(d.icon),
                    label: Text(d.title),
                  ),
                ),
              ],
              selectedIndex: widget.currentIndex,
              onDestinationSelected: widget.onNavigationIndexChange ?? (_) {},
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: Colors.grey[300],
            ),
            Expanded(
              child: widget.body!,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: widget.body,
      appBar: AppBar(
        title: widget.title,
        actions: widget.actions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          ...widget.destinations.map(
            (d) => BottomNavigationBarItem(
              icon: Icon(d.icon),
              label: d.title,
            ),
          ),
        ],
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationIndexChange,
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  void _destinationTapped(AdaptiveScaffoldDestination destination) {
    var idx = widget.destinations.indexOf(destination);
    if (idx != widget.currentIndex) {
      widget.onNavigationIndexChange!(idx);
    }
  }
}