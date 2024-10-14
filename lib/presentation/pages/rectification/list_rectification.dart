part of '../pages.dart';

class ListRectification extends StatefulWidget {
  const ListRectification({super.key});

  @override
  State<ListRectification> createState() => _ListRectificationState();
}

class _ListRectificationState extends State<ListRectification> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('List Rectification'),
      ),
    );
  }
}