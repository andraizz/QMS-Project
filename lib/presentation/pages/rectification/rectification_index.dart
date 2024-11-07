part of '../pages.dart';

class RectificationIndex extends StatefulWidget {
  final String indexType;
  final String inspectionTicketNumber;

  const RectificationIndex(
      {super.key,
      required this.indexType,
      required this.inspectionTicketNumber});

  @override
  State<RectificationIndex> createState() => _RectificationIndexState();
}

class _RectificationIndexState extends State<RectificationIndex>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Rectification> rectification_ticket = [];
  Map<String, List<Rectification>> groupedRectificationTickets =
      {}; // Grouped tickets
  bool loading = false; // Add this loading state

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Load data for the selected tab
        RectificationType type;
        switch (_tabController.index) {
          case 0:
            type = RectificationType.inspection;
            break;
          case 1:
            type = RectificationType.installation;
            break;
          case 2:
            type = RectificationType.quality_audit;
            break;
          default:
            type = RectificationType.inspection;
        }
        loadData();
      }
    });
    // Initial data load
    loadData();
  }

  Future<bool> loadData() async {
    setState(() {
      loading = true; // Start loading
    });

    const String apiUrl =
        'https://devqms.triasmitra.com/public/api/rectification/index/';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // First, store the rectification tickets in the original list
        List<Rectification> rectifications =
            data.map((json) => Rectification.fromJson(json)).toList();

        // Group by related_ticket
        Map<String, List<Rectification>> groupedTickets = {};
        for (var ticket in rectifications) {
          String relatedTicket = ticket
              .relatedTicket; // Assuming related_ticket is a field in Rectification
          if (!groupedTickets.containsKey(relatedTicket)) {
            groupedTickets[relatedTicket] = [];
          }
          groupedTickets[relatedTicket]!.add(ticket);
        }

        // Update the state with both the original and grouped data
        setState(() {
          rectification_ticket = rectifications; // Keep the original list
          groupedRectificationTickets = groupedTickets;
          loading = false; // Stop loading
        });

        return true; // Fetch successful
      } else {
        throw Exception(
            'Failed to load rectifications: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        loading = false; // Stop loading even in case of error
      });
      print('Error fetching data: $e');
      return false; // Fetch failed
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.indexType) {
      case 'created':
        return Scaffold(
          body: Column(
            children: [
              header(context, 'Site Rectification'),
              TabBar(
                controller: _tabController,
                indicator: const BoxDecoration(),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            _tabController.index = 0;
                          });
                        },
                        child: Container(
                          width: 200,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _tabController.index == 0
                                ? AppColor.blueColor1
                                : AppColor.greyColor1,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Inspection ( 0 )',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            _tabController.index = 1;
                          });
                        },
                        child: Container(
                          width: 200,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _tabController.index == 1
                                ? AppColor.blueColor1
                                : AppColor.greyColor1,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Installation ( 0 )',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            _tabController.index = 2;
                          });
                        },
                        child: Container(
                          width: 200,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _tabController.index == 2
                                ? AppColor.blueColor1
                                : AppColor.greyColor1,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Quality Audit ( 0 )',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Add other tabs...
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTabContent("inspection"), // First tab content
                    _buildTabContent("installation"), // Second tab content
                    _buildTabContent("quality_audit"), // Third tab content
                  ],
                ),
              ),
            ],
          ),
        );
      case 'inspection_tickets':
        final inspectionRectifications = rectification_ticket
            .where((rectification) => rectification.type == 'inspection')
            .where((rectification) => rectification.status == 'Created')
            .where((rectification) =>
                rectification.relatedTicket == widget.inspectionTicketNumber)
            .toList();

        if (inspectionRectifications.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBarWidget.secondary('List Rectification Ticket', context),
          body: SafeArea(
            child: Container(
              color: AppColor.scaffold, // Ensure a background color is set
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add your text outside the loop here (above the list)
                  Text(
                    widget.inspectionTicketNumber, // Example text
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20), // Add some spacing

                  // The ListView.builder inside an Expanded widget for scrollable content
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: inspectionRectifications.length,
                      itemBuilder: (context, index) {
                        final rectificationItem =
                            inspectionRectifications[index];

                        return Container(
                          decoration: BoxDecoration(
                            color: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.event,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    rectificationItem.createdAt ??
                                        'Unknown Date',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      decoration: TextDecoration
                                          .none, // No yellow underline
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                rectificationItem.ticketNumber ??
                                    'No related ticket',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration
                                      .none, // No yellow underline
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                rectificationItem.section ??
                                    'No section specified',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  decoration: TextDecoration
                                      .none, // No yellow underline
                                ),
                              ),
                              Text(
                                rectificationItem.servicePoint ??
                                    'No service point specified',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  decoration: TextDecoration
                                      .none, // No yellow underline
                                ),
                              ),
                              const SizedBox(height: 10),
                              DButtonBorder(
                                onClick: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoute.rectificationShow,
                                    arguments: {
                                      'ticketNumber':
                                          rectificationItem.ticketNumber,
                                      'type': 'inspection',
                                    },
                                  );
                                },
                                mainColor: Colors.white,
                                radius: 10,
                                borderColor: AppColor.scaffold,
                                child: const Text(
                                  'Rectification Ticket Form',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      case 'history':
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                itemCount: rectification_ticket
                    .length, // Define the number of items to display
                itemBuilder: (context, index) {
                  // Access each rectification_ticket item by its index
                  final rectification = rectification_ticket[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0)
                        const Text(
                          'Rectification History',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const Gap(6),
                      History(
                        ticketNumber: rectification.ticketNumber,
                        date: rectification.acknowledgeAt,
                        relatedTicket: rectification.relatedTicket,
                        servicePoint: rectification.servicePoint,
                        longitude: rectification.longitude,
                        latitude: rectification.latitude,
                        acknowledgeBy: null,
                        status: rectification.status,
                      ),
                      const Gap(16), // Add some space between cards
                    ],
                  );
                },
              ),
            ),
          ],
        );
        break;
      default:
        return const Text(
          'Ticket type is not found',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        );
    }
  }

  Widget _buildTabContent(type) {
    final rawInspection = rectification_ticket
        .where((rectification) => rectification.type == type)
        .where((rectification) => rectification.status == 'Created')
        .toList();

    final Map<String, int> relatedTicketCounts = {};
    final List<Rectification> inspection = [];

    for (var rectification in rawInspection) {
      String relatedTicket = rectification.relatedTicket;

      // If it's a new relatedTicket, add to uniqueInspection
      if (!relatedTicketCounts.containsKey(relatedTicket)) {
        inspection.add(rectification);
        relatedTicketCounts[relatedTicket] = 1; // Initialize count
      } else {
        relatedTicketCounts[relatedTicket] =
            relatedTicketCounts[relatedTicket]! + 1; // Increment count
      }
    }

    final installation = rectification_ticket
        .where((rectification) => rectification.type == type)
        .where((rectification) => rectification.status == 'Created')
        .toList();

    switch (type) {
      case 'inspection':
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          itemCount: inspection.length,
          itemBuilder: (context, index) {
            final rectificationItem = inspection[index];
            final relatedTicketCount =
                relatedTicketCounts[rectificationItem.relatedTicket] ?? 0;
            return Container(
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.event,
                        color: Colors.grey,
                        size: 18,
                      ),
                      const Gap(8),
                      Text(
                        rectificationItem.createdAt,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Text(
                    rectificationItem.relatedTicket,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(12),
                  Text(
                    "Defect found: ${relatedTicketCount}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    rectificationItem.section,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    rectificationItem.servicePoint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DButtonBorder(
                    onClick: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RectificationIndex(
                                    indexType: 'inspection_tickets',
                                    inspectionTicketNumber:
                                        rectificationItem.relatedTicket,
                                  )));
                    },
                    mainColor: Colors.white,
                    radius: 10,
                    borderColor: AppColor.scaffold,
                    child: const Text(
                      'Rectification Tickets',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      case 'installation':
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          itemCount: installation.length,
          itemBuilder: (context, index) {
            final rectificationItem = installation[index];
            return Container(
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.event,
                        color: Colors.grey,
                        size: 18,
                      ),
                      const Gap(8),
                      Text(
                        rectificationItem.createdAt,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Text(
                    rectificationItem.ticketNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(12),
                  Text(
                    "Installation Ticket : ${rectificationItem.relatedTicket}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    rectificationItem.section,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    rectificationItem.servicePoint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DButtonBorder(
                    onClick: () {
                      Navigator.pushNamed(
                        context,
                        AppRoute.rectificationShow,
                        arguments: {
                          'ticketNumber': rectificationItem.ticketNumber,
                          'type': 'installation',
                        },
                      );
                    },
                    mainColor: Colors.white,
                    radius: 10,
                    borderColor: AppColor.scaffold,
                    child: const Text(
                      'Rectification Ticket Form',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      case 'quality_audit':
        return const Text(
          'Quality Audit',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        );

      default:
        return const Text(
          'Ticket type is not found',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        );
    }
  }
}

class History extends StatelessWidget {
  final String date;
  final String ticketNumber;
  final String? relatedTicket;
  final String? servicePoint;
  final String? longitude;
  final String? latitude;
  final String? acknowledgeBy;
  final String status;
  final VoidCallback? onTap;

  const History({
    required this.date,
    required this.ticketNumber,
    required this.relatedTicket,
    required this.servicePoint,
    required this.longitude,
    required this.latitude,
    required this.acknowledgeBy,
    required this.status,
    this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Acknowledge':
        return const Color(0xFF239FDB);
      case 'Created':
        return const Color(0xFF008B6B);
      case 'Opened':
        return const Color(0xFF1CC900);
      case 'On Progress':
        return const Color(0xFFEDFF23);
      case 'Paused':
        return const Color(0xFFFA4D75);
      case 'Approval SPV':
        return const Color(0xFFAB07F9);
      case 'On Review':
        return const Color(0xFFFF9C40);
      case 'Rejected':
        return const Color(0xFFEB4D4B);
      case 'closed':
        return const Color(0xFF757575);
      default:
        return Colors.black; // Default color if no status matches
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoute.rectificationCreate);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 6,
                  left: 6,
                  right: 6,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      ticketNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const Gap(3),
                    Container(
                      height: 15,
                      width: 70,
                      decoration: BoxDecoration(
                          color: _getStatusColor(status),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          status,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 8,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Details >',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: AppColor.defaultText,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: AppColor.divider,
              ),
              ItemTextHistory.primary("Date", date ?? '-', 1),
              ItemTextHistory.primary(
                  "Acknowledged By", acknowledgeBy ?? '-', 1),
              ItemTextHistory.primary(
                  "QMS Related TT", relatedTicket ?? '-', 1),
              ItemTextHistory.primary("Service Point", servicePoint ?? '-', 1),
              ItemTextHistory.primary("Longitude", longitude ?? '-', 1),
              ItemTextHistory.primary("Latitude", latitude ?? '-', 1),
              const Gap(12)
            ],
          ),
        ));
  }
}
