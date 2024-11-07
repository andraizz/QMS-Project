part of '../pages.dart';

class SummaryInspection extends StatefulWidget {
  final String idInspection;
  final String sectionPatrol;

  const SummaryInspection({
    super.key,
    required this.idInspection,
    required this.sectionPatrol,
  });

  @override
  _SummaryInspectionState createState() => _SummaryInspectionState();
}

class _SummaryInspectionState extends State<SummaryInspection> {
  late Future<InspectionResponse> _inspectionsFuture;
  late final TextEditingController edtQmsInspectionTicketNumber;

  @override
  void initState() {
    super.initState();
    _inspectionsFuture =
        ApiService().fetchInspectionByTicket2(widget.idInspection);
    edtQmsInspectionTicketNumber =
        TextEditingController(text: widget.idInspection);
  }

  @override
  void dispose() {
    edtQmsInspectionTicketNumber.dispose();
    super.dispose();
  }

  Future<void> _onWillPop(bool didPop) async {
    if (didPop) {
      return;
    }
    final bool shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Oops'),
            content: const Text('You must submit this summary'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Ok'),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldPop) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: _onWillPop,
      canPop: false,
      child: Scaffold(
        appBar: AppBarWidget.cantBack('Summary Inspection', context,
            onBackPressed: () => _onWillPop(false)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: FutureBuilder<InspectionResponse>(
                  future: _inspectionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return const Center(
                          child: Text('No Inspections Available'));
                    }

                    final inspectionResponse = snapshot.data!;
                    final inspections = inspectionResponse.inspections;
                    final assetTaggings = inspectionResponse.assetTagging;

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: inspections.length,
                      itemBuilder: (context, index) {
                        final inspection = inspections[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildInspectionCard(inspection),
                              const Gap(24),
                              _buildAssetTaggingSummary(
                                assetTaggings,
                                widget.idInspection,
                                widget.sectionPatrol,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  Widget _buildInspectionCard(Inspection inspection) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Ticket DMS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColor.defaultText,
            ),
          ),
          Divider(
            color: AppColor.greyColor2,
          ),
          ItemDescriptionDetail.primary('Project', inspection.project),
          const Gap(12),
          ItemDescriptionDetail.primary('Segment', inspection.segment),
          const Gap(12),
          ItemDescriptionDetail.primary('Section Name', inspection.sectionName),
          const Gap(12),
          ItemDescriptionDetail.primary(
              'Section Patrol', inspection.sectionPatrol),
          const Gap(12),
          ItemDescriptionDetail.primary(
              'Service Point', inspection.servicePoint),
          const Gap(12),
          ItemDescriptionDetail.primary('Worker', inspection.worker),
          const Gap(12),
        ],
      ),
    );
  }

  Widget _buildAssetTaggingSummary(List<AssetTaggingInspection> assetTaggings,
      String idInspection, String sectionPatrol) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputWidget.disable(
              'QMS Inspection Ticket Number', edtQmsInspectionTicketNumber),
          const Gap(12),
          const Text(
            'Summary Asset Tagging List:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(6),
          ...assetTaggings.map((tagging) {
            return GestureDetector(
              onTap: (tagging.findingCount > 0)
                  ? () {
                      Navigator.pushNamed(
                        context,
                        AppRoute.detailInspectionResult,
                        arguments: {
                          'idInspection': widget.idInspection,
                          'assetTagging': tagging.nama,
                        },
                      );
                    }
                  : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        tagging.nama,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: tagging.findingCount > 0
                            ? Colors.red
                            : Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${tagging.findingCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 10,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DButtonFlat(
                onClick: () async {
                  try {
                    await ApiService().updateInspectionTicketStatusSubmitted(
                        widget.idInspection, 'Submitted');
                    try {
                      await ApiService().updateTicketStatusInspectionResult(
                          widget.idInspection, 'Submitted');
                    } catch (e) {
                      print('Failed to update inspection result: $e');
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Inspection submitted successfully.')),
                    );
                    Navigator.pushReplacementNamed(context, AppRoute.dashboard,
                        arguments: 1);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Failed to submit inspection: $e')),
                    );
                  }
                },
                radius: 10,
                mainColor: AppColor.blueColor1,
                child: const Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
