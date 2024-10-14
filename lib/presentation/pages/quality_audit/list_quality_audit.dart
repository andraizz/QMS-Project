part of '../pages.dart';

class ListQualityAudit extends StatefulWidget {
  const ListQualityAudit({super.key});

  @override
  State<ListQualityAudit> createState() => _ListQualityAuditState();
}

class _ListQualityAuditState extends State<ListQualityAudit> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('List Quality Audit'),
      ),
    );
  }
}
