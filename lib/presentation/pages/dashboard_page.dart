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
    final userId = user.userId ?? 0;
    context.read<UserDataCubit>().fetchUserData(userId).then((_) {
      final username = context.read<UserDataCubit>().state?.username ?? '';

      context
          .read<InstallationRecordsUsernameBloc>()
          .add(FetchInstallationRecordsUsername(username));

      context.read<TicketByUserBloc>().add(FetchTicketByUserCM(username));
      context.read<TicketByUserBloc>().add(FetchTicketByUserPM(username));
    });
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
                              state.fullName ?? '',
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
                              state.roleName.toString(),
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
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/ic_position.png',
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 6),
                        BlocBuilder<UserDataCubit, UserData?>(
                          builder: (context, userDataState) {
                            if (userDataState == null) {
                              return const Text(
                                'Loading...',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 10,
                                ),
                              );
                            }

                            return Text(
                              userDataState.username ?? 'Username',
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
    return BlocBuilder<UserDataCubit, UserData?>(
      builder: (context, userDataState) {
        if (userDataState == null) {
          return const Center(
              child: CircularProgressIndicator()); // Show loading state
        }

        final String username = userDataState.username ?? '';

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
                    final normalizedUsername = username.toLowerCase();
                    if (normalizedUsername.endsWith('.a') ||
                        normalizedUsername.endsWith('.c')) {
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
                            final RegExp regex = RegExp(r'spv');
                            if (regex.hasMatch(username)) {
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
                    final normalizedUsername = username.toLowerCase();
                    if (normalizedUsername.endsWith('.j') ||
                        normalizedUsername.endsWith('.a') ||
                        normalizedUsername.endsWith('.c')) {
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
                    final normalizedUsername = username.toLowerCase();
                    if (normalizedUsername.startsWith('op')) {
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

  // Widget buildQmsModule() {
  //   final String username = context.read<UserDataCubit>().state?.username ?? '';

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
  //       GridView.count(
  //         padding: const EdgeInsets.all(0),
  //         physics: const NeverScrollableScrollPhysics(),
  //         shrinkWrap: true,
  //         crossAxisCount: 2,
  //         childAspectRatio: 1.5,
  //         mainAxisSpacing: 16,
  //         crossAxisSpacing: 16,
  //         children: [
  //           buildItemModuleMenu(
  //             asset: 'assets/images/inspection_bg.png',
  //             status: username.toLowerCase(),
  //             total: 0,
  //             onTap: () {
  //               final normalizedUsername = username.toLowerCase();
  //               if (normalizedUsername.endsWith('.a') ||
  //                   normalizedUsername.endsWith('.c')) {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => const ListInspection(),
  //                   ),
  //                 );
  //               } else {
  //                 _showAccessDeniedDialog(context, 'Inspection');
  //               }
  //             },
  //           ),
  //           // BlocBuilders specifically for Installation module
  //           BlocBuilder<TicketByUserBloc, TicketByUserState>(
  //             builder: (context, ticketState) {
  //               return BlocBuilder<InstallationRecordsUsernameBloc,
  //                   InstallationRecordsUsernameState>(
  //                 builder: (context, installationState) {
  //                   int cmCount = 0;
  //                   int pmCount = 0;
  //                   int totalTicketsInstallation = 0;

  //                   List<TicketByUser> filteredCmTickets = [];
  //                   List<TicketByUser> filteredPmTickets = [];

  //                   // Check if the state from TicketByUserBloc is loaded
  //                   if (ticketState is TicketByUserLoaded) {
  //                     List<TicketByUser> cmTickets = ticketState.cmTickets;
  //                     List<TicketByUser> pmTickets = ticketState.pmTickets;

  //                     // Check if InstallationRecordsUsernameState is loaded or empty
  //                     if (installationState
  //                             is InstallationRecordsUsernameLoaded &&
  //                         installationState.records.isNotEmpty) {
  //                       final installedTicketNumbers = installationState.records
  //                           .map((record) => record.dmsId)
  //                           .toSet();

  //                       // Filter out CM and PM tickets that already exist in installation records
  //                       filteredCmTickets = cmTickets
  //                           .where((ticket) => !installedTicketNumbers
  //                               .contains(ticket.ticketNumber))
  //                           .toList();

  //                       filteredPmTickets = pmTickets
  //                           .where((ticket) => !installedTicketNumbers
  //                               .contains(ticket.ticketNumber))
  //                           .toList();
  //                     } else {
  //                       filteredCmTickets = cmTickets;
  //                       filteredPmTickets = pmTickets;
  //                     }

  //                     cmCount = filteredCmTickets.length;
  //                     pmCount = filteredPmTickets.length;
  //                     totalTicketsInstallation = cmCount + pmCount;
  //                   }

  //                   return buildItemModuleMenu(
  //                     asset: 'assets/images/installation_bg.png',
  //                     status: 'Installation',
  //                     total: totalTicketsInstallation,
  //                     onTap: () {
  //                       final RegExp regex = RegExp(r'spv');
  //                       if (regex.hasMatch(username)) {
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => ListInstallationPage(
  //                               cmCount: filteredCmTickets.length,
  //                               pmCount: filteredPmTickets.length,
  //                               ticketByUserCM: filteredCmTickets,
  //                               ticketByUserPM: filteredPmTickets,
  //                             ),
  //                           ),
  //                         );
  //                       } else {
  //                         _showAccessDeniedDialog(context, 'Installation');
  //                       }
  //                     },
  //                   );
  //                 },
  //               );
  //             },
  //           ),
  //           buildItemModuleMenu(
  //             asset: 'assets/images/rectification_bg.png',
  //             status: 'Rectification',
  //             total: 0,
  //             onTap: () {
  //               final normalizedUsername = username.toLowerCase();
  //               if (normalizedUsername.endsWith('.j') ||
  //                   normalizedUsername.endsWith('.a') ||
  //                   normalizedUsername.endsWith('.c')) {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => const ListRectification(),
  //                   ),
  //                 );
  //               } else {
  //                 _showAccessDeniedDialog(context, 'Rectification');
  //               }
  //             },
  //           ),
  //           buildItemModuleMenu(
  //             asset: 'assets/images/qualityaudit_bg.png',
  //             status: 'Quality Audit',
  //             total: 0,
  //             onTap: () {
  //               final normalizedUsername = username.toLowerCase();
  //               if (normalizedUsername.startsWith('op')) {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => const ListQualityAudit(),
  //                   ),
  //                 );
  //               } else {
  //                 _showAccessDeniedDialog(context, 'Quality Audit');
  //               }
  //               // if (username.contains('op')) {
  //               //   Navigator.push(
  //               //     context,
  //               //     MaterialPageRoute(
  //               //       builder: (context) => const ListQualityAudit(),
  //               //     ),
  //               //   );
  //               // } else {
  //               //   _showAccessDeniedDialog(context, 'Quality Audit');
  //               // }
  //             },
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

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

  //   Widget buildQmsModule() {
  //   final String username = context.read<UserDataCubit>().state?.username ?? '';

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
  //       GridView.count(
  //         padding: const EdgeInsets.all(0),
  //         physics: const NeverScrollableScrollPhysics(),
  //         shrinkWrap: true,
  //         crossAxisCount: 2,
  //         childAspectRatio: 1.5,
  //         mainAxisSpacing: 16,
  //         crossAxisSpacing: 16,
  //         children: [
  //           buildItemModuleMenu(
  //             asset: 'assets/images/inspection_bg.png',
  //             status: 'Inspection',
  //             total: 1,
  //             onTap: () {
  //               if (username.contains('.a') || username.contains('.c')) {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => const DashboardPage(),
  //                   ),
  //                 );
  //               } else {
  //                 _showAccessDeniedDialog(context, 'Inspection');
  //               }
  //             },
  //           ),
  //           // BlocBuilders specifically for Installation module
  //           BlocBuilder<TicketByUserBloc, TicketByUserState>(
  //             builder: (context, ticketState) {
  //               return BlocBuilder<InstallationRecordsUsernameBloc,
  //                   InstallationRecordsUsernameState>(
  //                 builder: (context, installationState) {
  //                   int cmCount = 0;
  //                   int pmCount = 0;
  //                   int totalTicketsInstallation = 0;

  //                   List<TicketByUser> filteredCmTickets = [];
  //                   List<TicketByUser> filteredPmTickets = [];

  //                   // Check if the state from TicketByUserBloc is loaded
  //                   if (ticketState is TicketByUserLoaded) {
  //                     List<TicketByUser> cmTickets = ticketState.cmTickets;
  //                     List<TicketByUser> pmTickets = ticketState.pmTickets;

  //                     // Check if InstallationRecordsUsernameState is loaded or empty
  //                     if (installationState
  //                             is InstallationRecordsUsernameLoaded &&
  //                         installationState.records.isNotEmpty) {
  //                       final installedTicketNumbers = installationState.records
  //                           .map((record) => record.dmsId)
  //                           .toSet();

  //                       // Filter out CM and PM tickets that already exist in installation records
  //                       filteredCmTickets = cmTickets
  //                           .where((ticket) => !installedTicketNumbers
  //                               .contains(ticket.ticketNumber))
  //                           .toList();

  //                       filteredPmTickets = pmTickets
  //                           .where((ticket) => !installedTicketNumbers
  //                               .contains(ticket.ticketNumber))
  //                           .toList();
  //                     } else {
  //                       filteredCmTickets = cmTickets;
  //                       filteredPmTickets = pmTickets;
  //                     }

  //                     cmCount = filteredCmTickets.length;
  //                     pmCount = filteredPmTickets.length;
  //                     totalTicketsInstallation = cmCount + pmCount;
  //                   }

  //                   return buildItemModuleMenu(
  //                     asset: 'assets/images/installation_bg.png',
  //                     status: 'Installation',
  //                     total: totalTicketsInstallation,
  //                     onTap: () {
  //                       if (totalTicketsInstallation > 0) {
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => ListInstallationPage(
  //                               cmCount: filteredCmTickets.length,
  //                               pmCount: filteredPmTickets.length,
  //                               ticketByUserCM: filteredCmTickets,
  //                               ticketByUserPM: filteredPmTickets,
  //                             ),
  //                           ),
  //                         );

  //                         setState(() {
  //                           navigateToInstallation = false;
  //                         });
  //                       } else {
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => ListInstallationPage(
  //                               cmCount: filteredCmTickets.length,
  //                               pmCount: filteredPmTickets.length,
  //                               ticketByUserCM: filteredCmTickets,
  //                               ticketByUserPM: filteredPmTickets,
  //                             ),
  //                           ),
  //                         );
  //                       }
  //                     },
  //                   );
  //                 },
  //               );
  //             },
  //           ),
  //           buildItemModuleMenu(
  //             asset: 'assets/images/rectification_bg.png',
  //             status: 'Rectification',
  //             total: 1,
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => const ListRectification(),
  //                 ),
  //               );
  //             },
  //           ),
  //           buildItemModuleMenu(
  //             asset: 'assets/images/qualityaudit_bg.png',
  //             status: 'Quality Audit',
  //             total: 1,
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => const ListQualityAudit(),
  //                 ),
  //               );
  //             },
  //           ),
  //         ],
  //       ),
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
