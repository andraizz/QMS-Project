part of 'pages.dart';

class ListInstallationPage extends StatefulWidget {
  const ListInstallationPage({super.key});

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
                        'DMS TT CM (3)',
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
                        'DMS TT PM (2)',
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
                ListView.builder(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return cardTicket(
                      DateTime.now(),
                      'TT-24082800S009',
                      'Trias_Jember-Kalibaru',
                      'Batam 1',
                      context,
                    );
                  },
                ),
                 ListView.builder(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return cardTicket(
                      DateTime.now(),
                      'TT-24082800S009',
                      'Trias_Jember-Kalibaru',
                      'Batam 1',
                      context,
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
