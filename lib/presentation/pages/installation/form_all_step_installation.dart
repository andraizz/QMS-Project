part of '../pages.dart';

class FormAllStepInstallation extends StatefulWidget {
  const FormAllStepInstallation({super.key});

  @override
  State<FormAllStepInstallation> createState() =>
      _FormAllStepInstallationState();
}

class _FormAllStepInstallationState extends State<FormAllStepInstallation> {
  final ScrollController _scrollController = ScrollController();
  String? qmsId;
  String? typeOfInstallationName;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as Map?;

    if (args != null) {
      qmsId = args['qms_id'] as String?;
      // initialQMSInstallationStepId =
      //     args['qms_installation_step_id'] as String?;
      // typeOfInstallationId = args['typeOfInstallationId'] as int?;
      typeOfInstallationName = args['typeOfInstallationName'] as String?;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.cantBack(
        'Detail Tickets',
        context,
        onBackPressed: () => _onWillPop(false),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                const Gap(6),
                formStepInstallation(),
              ],
            ),
          )
        ],
      ),
    );
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
      Navigator.of(context).pop();
    }
  }

  Widget formStepInstallation() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InputWidget.disable(
            'QMS Installation Ticket Number',
            TextEditingController(text: qmsId),
          ),
          const Gap(6),
          InputWidget.dropDown2(
            title: 'Type of installation',
            hintText: 'Select Type Of Installation',
            value: typeOfInstallationName!,
            onChanged: null,
            isEnabled: false,
            hintTextSearch: 'Search type of installation',
          ),
          const Gap(12),
          Text(
            'List Step Installation',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColor.defaultText,
            ),
          ),
          const Gap(6),
          ItemStepInstallation.createdStep(title: '1. Panoramic FOC Before'),
          const Gap(6),
          ItemStepInstallation.active(title: '2.Close up/near view FOC Before'),
          const Gap(6),
          ItemStepInstallation.inactive(title: '3. Far view FOC Before'),
          const Gap(12),
        ],
      ),
    );
  }
}
