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
  final Widget? logo;
  final List<Widget> actions;
  final Widget? body;
  final int currentIndex;
  final List<AdaptiveScaffoldDestination> destinations;
  final ValueChanged<int>? onNavigationIndexChange;
  final FloatingActionButton? floatingActionButton;

  const AdaptiveScaffold({
    this.title,
    this.logo,
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
    const backgroundColor = Color.fromARGB(236, 238, 240, 255);
    const navigationBackgroundColor = Color(0xFFACB3CC);
    const selectedColor = Color.fromARGB(255, 168, 126, 207);
    const unselectedColor = Colors.black87;

    if (_isLargeScreen(context)) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: backgroundColor,
        body: Row(
          children: [
            Drawer(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              backgroundColor: navigationBackgroundColor,
              child: Column(
                children: [
                  DrawerHeader(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.logo != null) widget.logo!,
                          const SizedBox(width: 8),
                          if (widget.title != null) widget.title!,
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        for (var i = 0; i < widget.destinations.length; i++)
                          if (widget.destinations[i].title != 'Salir')
                            InkWell(
                              onTap: () => _destinationTapped(widget.destinations[i]),
                              child: Container(
                                color: widget.currentIndex == i
                                    ? selectedColor
                                    : navigationBackgroundColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 16.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      widget.destinations[i].icon,
                                      color: widget.currentIndex == i ? Colors.white : unselectedColor,
                                    ),
                                    const SizedBox(width: 16.0),
                                    Text(
                                      widget.destinations[i].title,
                                      style: TextStyle(
                                        color: widget.currentIndex == i ? Colors.white : unselectedColor,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    color: const Color(0xFFFF9494),
                    child: TextButton(
                      onPressed: () {
                        widget.onNavigationIndexChange?.call(widget.destinations.length - 1);
                      },
                      child: const Text(
                        'Salir',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
              child: Container(
                color: backgroundColor,
                child: Scaffold(
                  appBar: AppBar(
                    actions: widget.actions,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  backgroundColor: Colors.transparent,
                  body: widget.body,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_isMediumScreen(context)) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: widget.title,
          actions: widget.actions,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: navigationBackgroundColor,
              indicatorColor: selectedColor,
              selectedIndex: widget.currentIndex,
              onDestinationSelected: widget.onNavigationIndexChange,
              selectedIconTheme: const IconThemeData(color: Colors.white),
              unselectedIconTheme: const IconThemeData(color: unselectedColor),
              selectedLabelTextStyle: const TextStyle(color: Colors.white),
              unselectedLabelTextStyle: const TextStyle(color: unselectedColor),
              destinations: [
                ...widget.destinations.map((d) {
                  final bool isSelected = widget.destinations.indexOf(d) == widget.currentIndex;
                  return NavigationRailDestination(
                    icon: Tooltip(
                      message: d.title,
                      child: Icon(
                          d.icon,
                          color: isSelected ? Colors.white : unselectedColor,
                        ),
                    ),
                    label: Text(d.title),
                  );
                }),
              ],
              
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: Colors.grey[300],
            ),
            Expanded(
              child: Container(
                color: backgroundColor,
                child: widget.body!,
              ),
            ),
          ],
        ),
      );
    }

    // Pantallas pequeñas (móviles)
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: widget.title, // Solo el título DROPS
        actions: widget.actions,
        backgroundColor: navigationBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        color: backgroundColor,
        child: widget.body,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: navigationBackgroundColor,
        selectedItemColor: const Color.fromARGB(255, 240, 221, 236),
        unselectedItemColor: unselectedColor,
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationIndexChange,
        items: [
          ...widget.destinations.map((d) {
                  final bool isSelected = widget.destinations.indexOf(d) == widget.currentIndex;
                  return BottomNavigationBarItem(
                    icon: Tooltip(
                      message: d.title,
                      child: Icon(
                          d.icon,
                          color: isSelected ? const Color.fromARGB(255, 240, 221, 236) : unselectedColor,
                        ),
                    ),
                    label: d.title,
                    backgroundColor: navigationBackgroundColor
                  );
                }),
        ],
        
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