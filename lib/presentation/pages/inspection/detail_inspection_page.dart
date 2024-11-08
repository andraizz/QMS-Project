part of '../pages.dart';

class DetailInspectionPage extends StatefulWidget {
  final String ticketNumber;
  final String formattedIdInspection;

  const DetailInspectionPage({
    super.key,
    required this.ticketNumber,
    required this.formattedIdInspection,
  });

  @override
  _DetailInspectionPageState createState() => _DetailInspectionPageState();
}

class _DetailInspectionPageState extends State<DetailInspectionPage> {
  List<AssetTagging> assetTaggings = [];
  AssetTagging? selectedAssetTagging;

  late Future<List<dynamic>?> _ticketDetail;

  late final TextEditingController edtQmsInspectionTicketNumber;
  final TextEditingController edtSectionPatrol = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ticketDetail = ApiService().getTicketDetail(widget.ticketNumber);
    _loadAssetTagging(widget.ticketNumber);
    edtQmsInspectionTicketNumber =
        TextEditingController(text: widget.formattedIdInspection);
  }

  Future<void> _loadAssetTagging(String ticketNumber) async {
    try {
      final assetTaggingData =
          await ApiService().fetchAssetTagging(ticketNumber);
      setState(() {
        assetTaggings = assetTaggingData;
        if (assetTaggings.isNotEmpty) {
          selectedAssetTagging = assetTaggings[0];
        }
      });
      print(
          'Asset Tagging List: ${assetTaggings.map((e) => e.assetName).toList()}');
    } catch (e) {
      print('Error fetching asset tagging: $e');
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> _onWillPop(bool didPop) async {
    if (didPop) {
      return;
    }
    final bool shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to close this page?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldPop) {
      Navigator.pushReplacementNamed(context, AppRoute.dashboard, arguments: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: _onWillPop,
        canPop: false,
        child: Scaffold(
          appBar: AppBarWidget.cantBack('Detail Ticket', context,
              onBackPressed: () => _onWillPop(false)),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: FutureBuilder<List<dynamic>?>(
              future: _ticketDetail,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  final List<dynamic> dataList = snapshot.data!;
                  return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final data = dataList[index] as Map<String, dynamic>;
                      edtSectionPatrol.text = data['span_name'] ?? 'N/A';

                      return contentTicketDMS2(data);
                    },
                  );
                }
              },
            ),
          ),
        ));
  }

  Widget contentTicketDMS2(Map<String, dynamic> data) {
    final String ttNumber = widget.ticketNumber;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TT-$ttNumber',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColor.defaultText,
            ),
          ),
          Divider(
            color: AppColor.greyColor2,
          ),
          InputWidget.disable(
            'QMS Inspection Ticket Number',
            edtQmsInspectionTicketNumber,
          ),
          const Gap(6),
          InputWidget.dropDown(
            'Start Tagging',
            'Select Asset Tagging',
            selectedAssetTagging?.assetName,
            assetTaggings.isNotEmpty
                ? [assetTaggings.first.assetName, assetTaggings.last.assetName]
                : [],
            (newValue) {
              setState(() {
                selectedAssetTagging = assetTaggings
                    .firstWhere((tag) => tag.assetName == newValue);
              });
            },
            'Search asseet tagging',
          ),
          const Gap(6),
          SizedBox(
            width: double.infinity,
            child: DButtonBorder(
              onClick: () async {
                _showLoadingDialog(context);
                try {
                  // Cek apakah asset tagging yang dipilih adalah yang terakhir, jika ya maka isReverse akan bernilai true
                  final isReverse = selectedAssetTagging == assetTaggings.last;
                  final qmsTicketNumber = widget.formattedIdInspection;

                  final assetTaggingNames = isReverse
                      ? assetTaggings.reversed
                          .map((tag) => {'asset_name': tag.assetName})
                          .toList()
                      : assetTaggings
                          .map((tag) => {'asset_name': tag.assetName})
                          .toList();

                  final payload = {
                    'id_inspection': qmsTicketNumber,
                    'is_reverse': isReverse,
                    'asset_taggings': assetTaggingNames,
                    'start_date': DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(DateTime.now()),
                    'end_date': null
                  };

                  final response =
                      await ApiService().postAssetTaggingInspection(payload);

                  await ApiService().updateInspectionTicketStatusOnProgress(
                      widget.formattedIdInspection, 'On Progress');

                  if (response['success'] != null && response['success']) {
                    _hideLoadingDialog(context);

                    Navigator.pushReplacementNamed(
                      context,
                      AppRoute.detailAssetTaggingInspection,
                      arguments: {
                        'ticketNumber': widget.ticketNumber,
                        'formattedIdInspection': qmsTicketNumber,
                        'isReversed': isReverse,
                        'sectionPatrol': edtSectionPatrol.text,
                      },
                    );
                  } else {
                    final errorMessage =
                        response['message'] ?? 'Unknown error occurred';
                    throw Exception(
                        'Failed to create asset tagging: $errorMessage');
                  }
                } catch (e) {
                  print('Error: $e');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Failed to post asset tagging inspection: $e'),
                    ),
                  );

                  _hideLoadingDialog(context);
                }
              },
              mainColor: Colors.white,
              radius: 10,
              borderColor: AppColor.scaffold,
              child: const Text(
                'Start Inspection Ticket',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Gap(6),
        ],
      ),
    );
  }
}
