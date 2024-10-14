part of 'pages.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<TicketByUser> ticketByUserCM = [];
  List<TicketByUser> ticketByUserPM = [];
  late User user;

  bool navigateToInstallation = false;

  refresh() async {
    context
        .read<InstallationRecordsUsernameBloc>()
        .add(FetchInstallationRecordsUsername(user.username!));
    context.read<TicketByUserBloc>().add(FetchTicketByUserCM(user.username!));
    context.read<TicketByUserBloc>().add(FetchTicketByUserPM(user.username!));
  }

  @override
  void initState() {
    user = context.read<UserCubit>().state;
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE \nd MMMM yyyy').format(now);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => refresh(),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            welcomeCard(formattedDate: formattedDate),
            const Gap(36),
            buildQmsModule(),
            const Gap(36),
            buildProgressQmsTicket(),
          ],
        ),
      ),
    );
  }

  Widget welcomeCard({String? formattedDate}) {
    return Container(
      height: 100,
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
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/ic_nama.png',
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 6),
                        BlocBuilder<UserCubit, User>(
                          builder: (context, state) {
                            return Text(
                              state.nama ?? '',
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Gap(6),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/ic_position.png',
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 6),
                        BlocBuilder<UserCubit, User>(
                          builder: (context, state) {
                            return Text(
                              state.jabatan.toString(),
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                    const Gap(6),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    formattedDate ?? '',
                    style: const TextStyle(fontSize: 10),
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
    return BlocBuilder<UserCubit, User?>(
      builder: (context, user) {
        if (user == null) {
          return const Center(
              child: CircularProgressIndicator()); // Show loading state
        }
        final String jabatan = user.jabatan ?? '';

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
            GridView.count(
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
                  total: 0,
                  onTap: () {
                    if (jabatan == 'Patroli SIM A' ||
                        jabatan == 'Patroli SIM C') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListInspection(),
                        ),
                      );
                    } else {
                      _showAccessDeniedDialog(context, 'Inspection');
                    }
                  },
                ),
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

                        if (ticketState is TicketByUserLoaded) {
                          List<TicketByUser> cmTickets = ticketState.cmTickets;
                          List<TicketByUser> pmTickets = ticketState.pmTickets;

                          if (installationState
                                  is InstallationRecordsUsernameLoaded &&
                              installationState.records.isNotEmpty) {
                            final installedTicketNumbers = installationState
                                .records
                                .map((record) => record.dmsId)
                                .toSet();

                            filteredCmTickets = cmTickets
                                .where((ticket) => !installedTicketNumbers
                                    .contains(ticket.ticketNumber))
                                .toList();
                            filteredPmTickets = pmTickets
                                .where((ticket) => !installedTicketNumbers
                                    .contains(ticket.ticketNumber))
                                .toList();
                          } else {
                            filteredCmTickets = cmTickets;
                            filteredPmTickets = pmTickets;
                          }

                          cmCount = filteredCmTickets.length;
                          pmCount = filteredPmTickets.length;
                          totalTicketsInstallation = cmCount + pmCount;
                        }

                        return buildItemModuleMenu(
                          asset: 'assets/images/installation_bg.png',
                          status: 'Installation',
                          total: totalTicketsInstallation,
                          onTap: () {
                            if (jabatan == 'SPV') {
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
                            } else {
                              _showAccessDeniedDialog(context, 'Installation');
                            }
                          },
                        );
                      },
                    );
                  },
                ),
                buildItemModuleMenu(
                  asset: 'assets/images/rectification_bg.png',
                  status: 'Rectification',
                  total: 0,
                  onTap: () {
                    if (jabatan == 'Jointer' ||
                        jabatan == 'Patroli SIM A' ||
                        jabatan == 'Patroli SIM C') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListRectification(),
                        ),
                      );
                    } else {
                      _showAccessDeniedDialog(context, 'Rectification');
                    }
                  },
                ),
                buildItemModuleMenu(
                  asset: 'assets/images/qualityaudit_bg.png',
                  status: 'Quality Audit',
                  total: 0,
                  onTap: () {
                    if (jabatan == 'Optimation') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListQualityAudit(),
                        ),
                      );
                    } else {
                      _showAccessDeniedDialog(context, 'Quality Audit');
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showAccessDeniedDialog(BuildContext context, String moduleName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Access Denied'),
          content: Text('You do not have access to the $moduleName module.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
