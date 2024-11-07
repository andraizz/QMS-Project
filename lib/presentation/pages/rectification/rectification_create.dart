part of '../pages.dart';

class RectificationCreate extends StatefulWidget {
  const RectificationCreate({super.key});

  @override
  State<RectificationCreate> createState() => _RectificationCreateState();
}

class _RectificationCreateState extends State<RectificationCreate> {
  // List of workers or tasks
  final List<String> workers = [
    'batam.j',
    'batam.hj',
    'batam.c',
    'batam.c1',
    'batam.a'
  ];

  // Boolean list to track the state of each checkbox
  List<bool> _isCheckedList = [];

  @override
  void initState() {
    super.initState();
    // Initialize all checkboxes to false
    _isCheckedList = List.generate(workers.length, (index) => false);
  }

  // Function to send form data via API
  Future<void> submitForm() async {
    final url = Uri.parse('https://yourapi.com/rectification/create');

    // Collect all selected workers
    List<String> selectedWorkers = [];
    for (int i = 0; i < workers.length; i++) {
      if (_isCheckedList[i]) {
        selectedWorkers.add(workers[i]);
      }
    }

    // Create the form data
    Map<String, dynamic> formData = {
      'servicePoint': 'Serpo Batam 1',
      'assignedWorkers': selectedWorkers, // Send selected workers
    };

    // Send the request
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('Form submitted successfully');
      } else {
        // Handle error
        print('Failed to submit form: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting form: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.secondary('Worker Assignment', context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                formContent(),
                const Gap(24),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget formContent() {
    final edtServicePoint = TextEditingController(text: 'Serpo Batam 1');
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputWidget.disable(
            'Service Point',
            edtServicePoint,
          ),
          const Gap(20),
          Text(
            "List of Workers",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Gap(6),
          // Loop through each worker and display a checkbox in the original design layout
          for (int i = 0; i < workers.length; i++)
            Row(
              children: [
                Checkbox(
                  value: _isCheckedList[i],
                  onChanged: (bool? value) {
                    setState(() {
                      _isCheckedList[i] = value ?? false;
                    });
                  },
                ),
                Text(workers[i]),
              ],
            ),
          const Gap(6),
        ],
      ),
    );
  }
}
