part of 'pages.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const DashboardPage(),
    const InspectionHistory(),
    const InstallationHistory(),
    const Scaffold(),
    const Scaffold()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.primary(),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items:  [
           _buildBottomNavigationBarItem(
            index: 0,
            label: 'Home',
            activeIconPath: 'assets/icons/ic_home_active.png',
            inactiveIconPath: 'assets/icons/ic_home_inactive.png',
          ),
          _buildBottomNavigationBarItem(
            index: 1,
            label: 'Inspection History',
            activeIconPath: 'assets/icons/ic_inspection_active.png',
            inactiveIconPath: 'assets/icons/ic_inspection_inactive.png',
          ),
          _buildBottomNavigationBarItem(
            index: 2,
            label: 'Installation History',
            activeIconPath: 'assets/icons/ic_installation_active.png',
            inactiveIconPath: 'assets/icons/ic_installation_inactive.png',
          ),
          _buildBottomNavigationBarItem(
            index: 3,
            label: 'Rectification History',
            activeIconPath: 'assets/icons/ic_rectification_active.png',
            inactiveIconPath: 'assets/icons/ic_rectification_inactive.png',
          ),
          _buildBottomNavigationBarItem(
            index: 4,
            label: 'Quality Audit History',
            activeIconPath: 'assets/icons/ic_qualityaudit_active.png',
            inactiveIconPath: 'assets/icons/ic_qualityaudit_inactive.png',
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required int index,
    required String label,
    required String activeIconPath,
    required String inactiveIconPath,
  }) {
    return BottomNavigationBarItem(
      icon: SizedBox(
        width: 60,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _currentIndex == index ? activeIconPath : inactiveIconPath,
              width: 24,
              height: 24,
            ),
            Text(
              label,
              maxLines: 2,
              style: TextStyle(
                fontSize: 8,
                color: _currentIndex == index ? AppColor.blueColor1 : AppColor.greyColor1,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      label: '',
    );
  }
}