part of 'pages.dart';

class InstallationHistory extends StatefulWidget {
  const InstallationHistory({super.key});

  @override
  State<InstallationHistory> createState() => _InstallationHistoryState();
}

class _InstallationHistoryState extends State<InstallationHistory> {
  @override
  void initState() {
    super.initState();
    // Fetch records when the page is first loaded
    context
        .read<InstallationRecordsUsernameBloc>()
        .add(FetchInstallationRecordsUsername('spvcentral.1'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 16,
              top: 16,
              // vertical: 16,
            ),
            child: Text(
              'Installation History',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<InstallationRecordsUsernameBloc,
                InstallationRecordsUsernameState>(
              builder: (context, state) {
                if (state is InstallationRecordsUsernameLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is InstallationRecordsUsernameLoaded) {
                  final records = state.records;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];

                      return Column(
                        children: [
                          ItemHistory.installation(
                            idTicket: record.qmsId,
                            status: record.status,
                            textColor: _getTextStatusColor(record.status),
                            statusColor: _getStatusColor(record.status),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoute.detailHistoryInstallation);
                            },
                            date: record
                                .createdAt, // Assuming `record.date` is a DateTime
                            createdBy: record.username,
                            ttDms: "TT-${record.dmsId}",
                            servicePoint: record.servicePoint,
                            sectionName: record.sectionName,
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    },
                  );
                } else if (state is InstallationRecordsUsernameError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('No data available.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Created':
        return AppColor.saveButton;
      case 'Submitted':
        return AppColor.blueColor1;
      case 'OnReview':
        return AppColor.installation;
      case 'Rejected':
        return AppColor.rejectedColor;
      case 'Closed':
        return AppColor.greyColor1;
      case 'Closed to be Rectified':
        return AppColor.closedToBeRectifiedColor;
      default:
        return AppColor.greyColor1;
    }
  }

  Color _getTextStatusColor(String? status) {
    switch (status) {
      case 'Created':
      case 'Submitted':
      case 'OnReview':
      case 'Rejected':
      case 'Closed':
        return AppColor.whiteColor;
      case 'Closed to be Rectified':
        return AppColor.rejectedColor;
      default:
        return AppColor.greyColor1;
    }
  }
}
