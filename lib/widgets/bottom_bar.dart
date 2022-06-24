import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shreddit/screens/add_post/add_post_screen.dart';
import 'package:shreddit/screens/colors.dart';
import 'package:shreddit/screens/home_screen/home_screen.dart';
import 'package:shreddit/screens/settings_screen/settings_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar(this.selectedIndex, {Key? key}) : super(key: key);

  final int selectedIndex;
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late int _selectedIndex;
  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        _selectedIndex = 0;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        _selectedIndex = 1;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddPost()),
        );
        break;
      case 2:
        _selectedIndex = 2;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
            (Route<dynamic> route) => false);
        break;
      default:
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: const Icon(Icons.home), label: tr("labelHome")),
        BottomNavigationBarItem(
            icon: const Icon(Icons.add), label: tr("labelAdd")),
        BottomNavigationBarItem(
            icon: const Icon(Icons.settings), label: tr("labelSettings")),
      ],
      selectedItemColor: AppColor.white,
      backgroundColor: const Color(0xFF312A2A),
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
