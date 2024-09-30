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
    const backgroundColor = Color.fromARGB(236, 238, 240, 255);

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
              backgroundColor: const Color(0xFFACB3CC), 
              child: Column(
                children: [
                  DrawerHeader(
                    child: Center(
                      child: widget.title,
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
                              onHover: (hovering) {
                                setState(() {
                                  // Actualiza el estado si se requiere
                                });
                              },
                              child: Container(
                                color: widget.currentIndex == i
                                    ? const Color.fromARGB(255, 168, 126, 207)
                                    : const Color.fromARGB(255, 198, 199, 201),
                                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      widget.destinations[i].icon,
                                      color: widget.currentIndex == i ? Colors.white : Colors.black87,
                                    ),
                                    const SizedBox(width: 16.0),
                                    Text(
                                      widget.destinations[i].title,
                                      style: TextStyle(
                                        color: widget.currentIndex == i ? Colors.white : Colors.black87,
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
                  // Botón de "Salir" al final
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
                color: backgroundColor, // Fondo para el contenido principal
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
              child: Container(
                color: backgroundColor, 
                child: widget.body!,
              ),
            ),
          ],
        ),
      );
    }

    // Para pantallas pequeñas
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: widget.title,
        actions: widget.actions,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        color: backgroundColor, 
        child: widget.body,
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
