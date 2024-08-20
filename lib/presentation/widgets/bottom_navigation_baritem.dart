part of 'widgets.dart';

BottomNavigationBarItem buildBottomNavigationBarItem({
    required int index,
    required String label,
    required String activeIconPath,
    required String inactiveIconPath,
    required int currentIndex
  }) {
    return BottomNavigationBarItem(
      icon: SizedBox(
        width: 40,
        height: 30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              currentIndex == index ? activeIconPath : inactiveIconPath,
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
      label: '',
    );
  }
