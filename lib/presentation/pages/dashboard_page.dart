part of 'pages.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<TicketByUser> ticketByUserCM = [];
  List<TicketByUser> ticketByUserPM = [];

  bool navigateToInstallation = false;

  @override
  void initState() {
    super.initState();
    context.read<TicketByUserBloc>().add(FetchTicketByUserCM());
    context.read<TicketByUserBloc>().add(FetchTicketByUserPM());
    context
        .read<InstallationRecordsUsernameBloc>()
        .add(FetchInstallationRecordsUsername('spveast.1'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TicketByUserBloc, TicketByUserState>(
        listener: (context, state) {
          if (state is TicketByUserLoaded && navigateToInstallation) {
            setState(() {
              navigateToInstallation = false; // Reset the flag after navigation
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListInstallationPage(
                  cmCount: state.cmTickets.length,
                  pmCount: state.pmTickets.length,
                  ticketByUserCM: state.cmTickets,
                  ticketByUserPM: state.pmTickets,
                ),
              ),
            );
          } else if (state is TicketError && navigateToInstallation) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            setState(() {
              navigateToInstallation = false; // Reset the flag on error
            });
          }
        },
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            welcomeCard(),
            const Gap(36),
            buildQmsModule(),
            const Gap(36),
            buildProgressQmsTicket(),
          ],
        ),
      ),
    );
  }

  Widget welcomeCard() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Text(
              'Welcome To QMS Mobile Apps',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Divider(
            color: AppColor.scaffold,
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInfoRow(
                        'assets/icons/ic_nama.png', 'Xaviera Ysabella'),
                    // buildInfoRow(
                    //     'assets/icons/ic_position.png', 'Jointer SP Batam'),
                    buildInfoRow(
                        'assets/icons/ic_servicepoint.png', 'SP Batam'),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    'Wednesday \n 14 Agustus 2024',
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQmsModule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Module',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(20),
        BlocBuilder<TicketByUserBloc, TicketByUserState>(
          builder: (context, ticketState) {
            return BlocBuilder<InstallationRecordsUsernameBloc,
                InstallationRecordsUsernameState>(
              builder: (context, installationState) {
                int cmCount = 0;
                int pmCount = 0;
                int totalTicketsInstallation = 0;

                List<TicketByUser> filteredCmTickets = [];
                List<TicketByUser> filteredPmTickets = [];

                // Check if the state from TicketByUserBloc is loaded
                if (ticketState is TicketByUserLoaded) {
                  // Initialize ticket lists
                  List<TicketByUser> cmTickets = ticketState.cmTickets;
                  List<TicketByUser> pmTickets = ticketState.pmTickets;

                  // Check if InstallationRecordsUsernameState is loaded or empty
                  if (installationState is InstallationRecordsUsernameLoaded &&
                      installationState.records.isNotEmpty) {
                    final installedTicketNumbers = installationState.records
                        .map((record) => record.dmsId)
                        .toSet();

                    // Filter out CM and PM tickets that already exist in installation records
                    filteredCmTickets = cmTickets
                        .where((ticket) => !installedTicketNumbers
                            .contains(ticket.ticketNumber))
                        .toList();

                    filteredPmTickets = pmTickets
                        .where((ticket) => !installedTicketNumbers
                            .contains(ticket.ticketNumber))
                        .toList();
                  } else {
                    // If no installation records exist, use all tickets
                    filteredCmTickets = cmTickets;
                    filteredPmTickets = pmTickets;
                  }

                  // Update counts based on filtered tickets
                  cmCount = filteredCmTickets.length;
                  pmCount = filteredPmTickets.length;
                  totalTicketsInstallation = cmCount + pmCount;
                }

                return GridView.count(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    buildItemModuleMenu(
                      asset: 'assets/images/inspection_bg.png',
                      status: 'Inspection',
                      total: 1,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardPage(),
                          ),
                        );
                      },
                    ),
                    buildItemModuleMenu(
                      asset: 'assets/images/installation_bg.png',
                      status: 'Installation',
                      total: totalTicketsInstallation,
                      onTap: () {
                        if (totalTicketsInstallation > 0) {
                          // Use filtered tickets for the navigation
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListInstallationPage(
                                cmCount: filteredCmTickets.length,
                                pmCount: filteredPmTickets.length,
                                ticketByUserCM: filteredCmTickets,
                                ticketByUserPM: filteredPmTickets,
                              ),
                            ),
                          );

                          // Reset navigation flag if required
                          setState(() {
                            navigateToInstallation = false;
                          });
                        } else {
                          // Show a message if no tickets are available after filtering
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'No tickets available for installation.',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    buildItemModuleMenu(
                      asset: 'assets/images/rectification_bg.png',
                      status: 'Rectification',
                      total: 1,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardPage(),
                          ),
                        );
                      },
                    ),
                    buildItemModuleMenu(
                      asset: 'assets/images/qualityaudit_bg.png',
                      status: 'Quality Audit',
                      total: 1,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardPage(),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  // Widget buildQmsModule() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Module',
  //         style: TextStyle(
  //           fontSize: 20,
  //           color: Colors.black,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //       const Gap(20),
  //       BlocBuilder<TicketByUserBloc, TicketByUserState>(
  //           builder: (context, state) {
  //         int cmCount = 0;
  //         int pmCount = 0;
  //         int totalTicketsInstallation = 0;

  //         if (state is TicketByUserLoaded) {
  //           cmCount = state.cmTickets.length;
  //           pmCount = state.pmTickets.length;
  //           totalTicketsInstallation = cmCount + pmCount;
  //         }
  //         return GridView.count(
  //           padding: const EdgeInsets.all(0),
  //           physics: const NeverScrollableScrollPhysics(),
  //           shrinkWrap: true,
  //           crossAxisCount: 2,
  //           childAspectRatio: 1.5,
  //           mainAxisSpacing: 16,
  //           crossAxisSpacing: 16,
  //           children: [
  //             buildItemModuleMenu(
  //                 asset: 'assets/images/inspection_bg.png',
  //                 status: 'Inspection',
  //                 total: 1,
  //                 onTap: () {
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => const DashboardPage()));
  //                 }),
  //             buildItemModuleMenu(
  //               asset: 'assets/images/installation_bg.png',
  //               status: 'Installation',
  //               total: totalTicketsInstallation,
  //               onTap: () {
  //                 // Trigger the fetch events
  //                 context.read<TicketByUserBloc>().add(FetchTicketByUserCM());
  //                 context.read<TicketByUserBloc>().add(FetchTicketByUserPM());

  //                 // Set the flag to true to navigate when data is loaded
  //                 setState(() {
  //                   navigateToInstallation = true;
  //                 });
  //               },
  //             ),
  //             buildItemModuleMenu(
  //                 asset: 'assets/images/rectification_bg.png',
  //                 status: 'Rectification',
  //                 total: 1,
  //                 onTap: () {
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => const DashboardPage()));
  //                 }),
  //             buildItemModuleMenu(
  //                 asset: 'assets/images/qualityaudit_bg.png',
  //                 status: 'Quality Audit',
  //                 total: 1,
  //                 onTap: () {
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => const DashboardPage()));
  //                 }),
  //           ],
  //         );
  //       })
  //     ],
  //   );
  // }

  Widget buildProgressQmsTicket() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QMS Ticket',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(20),
        ListView(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            buildItemProgressTickets(
              'assets/icons/ic_approved.png',
              'TT-24082800S009',
              '14 aug 2024, 12:00',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardPage(),
                  ),
                );
              },
            ),
            buildItemProgressTickets(
              'assets/icons/ic_process.png',
              'TT-24082800S009',
              '14 aug 2024, 12:00',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardPage(),
                  ),
                );
              },
            )
          ],
        )
      ],
    );
  }
}
