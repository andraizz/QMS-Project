part of 'pages.dart';

class ListInstallationPage extends StatefulWidget {
  final int cmCount;
  final int pmCount;
  final List<TicketByUser>? ticketByUserCM;
  final List<TicketByUser>? ticketByUserPM;

  const ListInstallationPage({
    super.key,
    this.cmCount = 0,
    this.pmCount = 0,
    this.ticketByUserCM,
    this.ticketByUserPM,
  });

  @override
  State<ListInstallationPage> createState() => _ListInstallationPageState();
}

class _ListInstallationPageState extends State<ListInstallationPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cmTickets =
        widget.ticketByUserCM ?? []; // Fallback to an empty list if null
    final pmTickets = widget.ticketByUserPM ?? [];
    return Scaffold(
      body: Column(
        children: [
          header(context, 'Site Installation'),
          const Gap(12),
          TabBar(
            controller: tabController,
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
                        tabController.index = 0;
                      });
                    },
                    child: Container(
                      width: 200,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: tabController.index == 0
                            ? AppColor.blueColor1
                            : AppColor.greyColor1,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'DMS TT CM (${widget.cmCount})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: tabController.index == 0
                              ? Colors.white
                              : Colors.white,
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
                        tabController.index = 1;
                      });
                    },
                    child: Container(
                      width: 200,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: tabController.index == 1
                              ? Colors.blue
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        'DMS TT PM (${widget.pmCount})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: tabController.index == 1
                              ? Colors.white
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                cmTickets.isEmpty
                    ? const Center(
                        child: Text('Ticket DMS TT CM Empty'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                            top: 16, bottom: 24, left: 24, right: 24),
                        physics: const BouncingScrollPhysics(),
                        itemCount: cmTickets.length,
                        itemBuilder: (context, index) {
                          final ticket = cmTickets[index];
                          return cardTicket(
                            createdAt: ticket.ticketStatusDate!,
                            ttNumber: 'TT-${ticket.ticketNumber}',
                            section: ticket.sectionName!,
                            servicePoint: ticket.servicePointName!,
                            onClick: () {
                              if (ticket.ticketNumber != null) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoute.detailDMSTicket,
                                  arguments: {
                                    'ticketNumber': ticket.ticketNumber!,
                                    'servicePointName':
                                        ticket.servicePointName!,
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Error: Ticket number is missing'),
                                  ),
                                );
                              }
                            },
                            context: context,
                          );
                        },
                      ),
                pmTickets.isEmpty
                    ? const Center(
                        child: Text('Ticket DMS TT PM Empty'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        physics: const BouncingScrollPhysics(),
                        itemCount: pmTickets.length,
                        itemBuilder: (context, index) {
                          final ticket = pmTickets[index];
                          return cardTicket(
                            createdAt: ticket.ticketStatusDate!,
                            ttNumber: 'TT-${ticket.ticketNumber}',
                            section: ticket.sectionName!,
                            servicePoint: ticket.servicePointName!,
                            onClick: () {
                              if (ticket.ticketNumber != null) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoute.detailDMSTicket,
                                  arguments: {
                                    'ticketNumber': ticket.ticketNumber!,
                                    'servicePointName':
                                        ticket.servicePointName!,
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Error: Ticket number is missing'),
                                  ),
                                );
                              }
                            },
                            context: context,
                          );
                        },
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
