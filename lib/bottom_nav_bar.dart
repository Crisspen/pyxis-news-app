import 'package:flutter/material.dart';

/// A reusable bottom navigation bar widget.
class BottomNavBar extends StatefulWidget {
  /// The initial selected index for the bottom navigation bar.
  final int initialIndex;

  /// Callback function triggered when a navigation item is tapped.
  /// Provides the index of the tapped item.
  final Function(int) onTap;

  /// Constructor for the BottomNavBar widget.
  const BottomNavBar({
    super.key, 
    this.initialIndex = 0, 
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  /// The currently selected index of the bottom navigation bar.
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onTap(index); // Call the provided onTap function
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Bookmarks',
        ),
      ],
    );
  }
}

