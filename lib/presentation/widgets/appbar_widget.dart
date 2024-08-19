part of 'widgets.dart';

class AppBarWidget {
  static PreferredSizeWidget primary() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5), // Warna bayangan
              offset: const Offset(0, 3), // x = 0, y = 3
              blurRadius: 10, // blur = 10
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                size: 24,
                Icons.notifications,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Image.asset(
              'assets/icons/ic_user.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(
              width: 20,
            ),
          ],
          leading: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
