part of '../pages.dart';

class ListInspection extends StatefulWidget {
  const ListInspection({super.key});

  @override
  State<ListInspection> createState() => _ListInspectionState();
}

class _ListInspectionState extends State<ListInspection> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('List Inspection'),
      ),
    );
  }
}