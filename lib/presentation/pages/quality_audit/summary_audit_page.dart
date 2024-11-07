part of '../pages.dart';

class SummaryAudit extends StatefulWidget {
  final String idAudit;
  final String sectionPatrol;

  const SummaryAudit({
    super.key,
    required this.idAudit,
    required this.sectionPatrol,
  });

  @override
  _SummaryAuditState createState() => _SummaryAuditState();
}

class _SummaryAuditState extends State<SummaryAudit> {
  late Future<AuditResponse> _auditsFuture;
  late final TextEditingController edtQmsAuditTicketNumber;

  @override
  void initState() {
    super.initState();
    _auditsFuture = ApiService().fetchAuditByTicket2(widget.idAudit);
    edtQmsAuditTicketNumber = TextEditingController(text: widget.idAudit);
  }

  @override
  void dispose() {
    edtQmsAuditTicketNumber.dispose();
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
        appBar: AppBarWidget.cantBack('Summary Quality Audit', context,
            onBackPressed: () => _onWillPop(false)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: FutureBuilder<AuditResponse>(
                  future: _auditsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('No Audits Available'));
                    }

                    final auditResponse = snapshot.data!;
                    final audits = auditResponse.audits;
                    final assetTaggings = auditResponse.assetTagging;

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: audits.length,
                      itemBuilder: (context, index) {
                        final audit = audits[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildAuditCard(audit),
                              const Gap(24),
                              _buildAssetTaggingSummary(
                                assetTaggings,
                                widget.idAudit,
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

  Widget _buildAuditCard(Audit audit) {
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
          ItemDescriptionDetail.primary('Project', audit.project),
          const Gap(12),
          ItemDescriptionDetail.primary('Segment', audit.segment),
          const Gap(12),
          ItemDescriptionDetail.primary('Section Name', audit.sectionName),
          const Gap(12),
          ItemDescriptionDetail.primary('Section Patrol', audit.sectionPatrol),
          const Gap(12),
          ItemDescriptionDetail.primary('Service Point', audit.servicePoint),
          const Gap(12),
          ItemDescriptionDetail.primary('Worker', audit.worker),
          const Gap(12),
        ],
      ),
    );
  }

  Widget _buildAssetTaggingSummary(List<AssetTaggingAudit> assetTaggings,
      String idAudit, String sectionPatrol) {
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
              'QMS Audit Ticket Number', edtQmsAuditTicketNumber),
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
                        AppRoute.detailAuditResult,
                        arguments: {
                          'idAudit': widget.idAudit,
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
                    await ApiService().updateAuditTicketStatusSubmitted(
                        widget.idAudit, 'Submitted');
                    try {
                      await ApiService().updateTicketStatusAuditResult(
                          widget.idAudit, 'Submitted');
                    } catch (e) {
                      print('Failed to update audit result: $e');
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Audit submitted successfully.')),
                    );

                    Navigator.pushReplacementNamed(context, AppRoute.dashboard,
                        arguments: 4);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to submit audit: $e')),
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
