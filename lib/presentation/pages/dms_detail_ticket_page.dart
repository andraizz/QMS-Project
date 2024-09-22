part of 'pages.dart';

class DMSDetailTicket extends StatefulWidget {
  const DMSDetailTicket({super.key});

  @override
  State<DMSDetailTicket> createState() => _DMSDetailTicketState();
}

class _DMSDetailTicketState extends State<DMSDetailTicket> {
  String? ticketNumber;
  String? servicePointName;

  List<InstallationType> installationType = [];
  InstallationType? selectedInstallationType;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchInstallationTypes();
  }

  Future<void> fetchInstallationTypes() async {
    try {
      final types = await InstallationSource().listInstallationTypes();
      if (types != null) {
        setState(() {
          installationType = types;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Failed to load installation types";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "An error occurred: $e";
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as Map?;

    if (args != null) {
      ticketNumber = args['ticketNumber'] as String?;
      servicePointName = args['servicePointName'] as String?;
    }

    if (ticketNumber != null) {
      context.read<TicketDetailBloc>().add(FetchTicketDetail(ticketNumber!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.secondary('Detail', context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                contentTicketDMS(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget contentTicketDMS() {
    return BlocBuilder<TicketDetailBloc, TicketDetailState>(
        builder: (context, state) {
      if (state is TicketDetailLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is TicketDetailLoaded) {
        final ticketDetails = state.ticketDetail;
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
                'TT-$ticketNumber',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColor.defaultText,
                ),
              ),
              Divider(
                color: AppColor.greyColor2,
              ),
              InputWidget.disable(
                'Service Point',
                TextEditingController(text: servicePointName),
              ),
              const Gap(6),
              InputWidget.disable(
                'Project',
                TextEditingController(text: ticketDetails.projectName),
              ),
              const Gap(6),
              InputWidget.disable(
                'Segment',
                TextEditingController(text: ticketDetails.spanName),
              ),
              const Gap(6),
              InputWidget.disable(
                'Section Name',
                TextEditingController(text: ticketDetails.sectionName),
              ),
              const Gap(6),
              InputWidget.disable(
                'Area',
                TextEditingController(
                    text: ticketDetails.ticketAssignees?[0].serviceAreaName),
              ),
              const Gap(6),
              InputWidget.disable(
                'Latitude',
                TextEditingController(text: ticketDetails.latitude.toString()),
              ),
              const Gap(6),
              InputWidget.disable(
                'Longitude',
                TextEditingController(text: ticketDetails.longitude.toString()),
              ),
              const Gap(6),
              InputWidget.dropDown2(
                title: 'Type of installation',
                hintText: 'Select Type Of Installation',
                value: selectedInstallationType?.typeName ?? '',
                items: installationType.isEmpty
                    ? ['Loading...'] // Temporary message while fetching data
                    : installationType
                        .map((type) => type.typeName ?? '')
                        .toList(),
                hintTextSearch: 'Search type of installation',
                onChanged: (newValue) {
                  setState(() {
                    selectedInstallationType = installationType.firstWhere(
                      (type) => type.typeName == newValue,
                    );
                  });
                },
              ),
              const Gap(24),
              DButtonBorder(
                onClick: () {
                  Navigator.pushNamed(
                    context,
                    AppRoute.formInstallation,
                    arguments: {
                      'ticketNumber': ticketNumber!,
                    },
                  );
                },
                mainColor: Colors.white,
                radius: 10,
                borderColor: AppColor.scaffold,
                child: const Text(
                  'Installation Ticket Form',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const Gap(24),
            ],
          ),
        );
      } else if (state is TicketDetailError) {
        return Center(
          child: Text('Error: ${state.message}'),
        );
      } else {
        return const Center(
          child: Text('No Detail Available'),
        );
      }
    });
  }
}
