  // Widget build(BuildContext context) {
  //   DateTime now = DateTime.now();

  //   String formattedDate = DateFormat('EEEE \nd MMMM yyyy').format(now);
  //   return Scaffold(
  //     body: BlocListener<TicketByUserBloc, TicketByUserState>(
  //       listener: (context, state) {
  //         if (state is TicketByUserLoaded && navigateToInstallation) {
  //           setState(() {
  //             navigateToInstallation = false; // Reset the flag after navigation
  //           });
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => ListInstallationPage(
  //                 cmCount: state.cmTickets.length,
  //                 pmCount: state.pmTickets.length,
  //                 ticketByUserCM: state.cmTickets,
  //                 ticketByUserPM: state.pmTickets,
  //               ),
  //             ),
  //           );
  //         } else if (state is TicketError && navigateToInstallation) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text(state.message)),
  //           );
  //           setState(() {
  //             navigateToInstallation = false; // Reset the flag on error
  //           });
  //         }
  //       },
  //       child: ListView(
  //         physics: const BouncingScrollPhysics(),
  //         padding: const EdgeInsets.all(24),
  //         children: [
  //           welcomeCard(formattedDate: formattedDate),
  //           const Gap(36),
  //           buildQmsModule(),
  //           const Gap(36),
  //           buildProgressQmsTicket(),
  //         ],
  //       ),
  //     ),
  //   );
  // }