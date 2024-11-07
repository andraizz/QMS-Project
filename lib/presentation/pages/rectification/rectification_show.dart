part of '../pages.dart';

class RectificationShow extends StatefulWidget {
  final String ticketNumber;
  final String type;

  const RectificationShow({
    required this.ticketNumber,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  _RectificationShowState createState() => _RectificationShowState();
}

class _RectificationShowState extends State<RectificationShow> {
  Map<String, dynamic>? rectificationData;

  @override
  void initState() {
    super.initState();
    _fetchRectificationData();
  }

  Future<void> _fetchRectificationData() async {
    final String url =
        'https://devqms.triasmitra.com/public/api/rectification/show/${widget.ticketNumber}/${widget.type}'; // API with sequence_id parameter

    try {
      // Perform the GET request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decode the JSON response
        final Map<String, dynamic> data = json.decode(response.body);

        // Assuming the API returns the rectification data directly
        setState(() {
          rectificationData = {
            'ticketNumber': data['ticket_number'] ?? '',
            'relatedTicket': data['related_ticket'] ?? '',
            'relatedTicketSequence': data['related_ticket_sequence'] ?? '',
            'type': data['type'] ?? '',
            'ttDms': data['tt_dms'] ?? '',
            'project': data['project'] ?? '',
            'segment': data['segment'] ?? '',
            'section': data['section'] ?? '',
            'area': data['area'] ?? '',
            'servicePoint': data['service_point'] ?? '',
            'spanRoute': data['span_route'] ?? '',
            'longitude': data['longitude'] ?? '',
            'latitude': data['latitude'] ?? '',
            'description': data['description'] ?? '',
            'createdAt': data['created_at'] ?? '',
          };
        });
      } else {
        // Handle the error response
        print(
            'https://devqms.triasmitra.com/public/api/rectification/show/${widget.ticketNumber}/${widget.type}');
      }
    } catch (e) {
      print('Error occurred while fetching data: $e');
    }
  }

  // Method to send POST request
  Future<void> sendPostRequest(Map<String, dynamic> data) async {
    const url =
        'https://devqms.triasmitra.com/public/api/rectification/store'; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data), // Encode the data to JSON format
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('Success: ${response.body}');
      } else {
        // Handle error response
        // You can log the response body which may contain error details
        print('Error: ${response.statusCode}');
        print('Response Body: ${response.body}'); // Log the response body

        // Optionally, you can parse the response and show it as a Snackbar or AlertDialog
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        String errorMessage =
            errorResponse['message'] ?? 'Unknown error occurred';

        // Show a SnackBar or AlertDialog with the error message
        // For example, in a StatefulWidget, you can call:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (rectificationData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBarWidget.secondary('Detail Ticket', context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sequence ID
                  Text(
                    rectificationData!['ticketNumber'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 12),

                  // Other Fields (QMS Rectification Ticket Number, Project, etc.)
                  _buildDetailField(
                      'QMS ${rectificationData!['type']} Ticket Number',
                      rectificationData!['relatedTicket']),
                  _buildDetailField(
                      'Cable Project', rectificationData!['project']),
                  _buildDetailField('Segment', rectificationData!['segment']),
                  _buildDetailField('Section', rectificationData!['section']),
                  if (rectificationData!['type'] == 'installation')
                    _buildDetailField(
                        'Area',
                        rectificationData![
                            'area']), // Add a description if you have one
                  _buildDetailField(
                      'Service Point', rectificationData!['servicePoint']),
                  _buildDetailField(
                      'Longitude', rectificationData!['longitude']),
                  _buildDetailField('Latitude', rectificationData!['latitude']),
                  if (rectificationData!['type'] == 'inspection')
                    _buildDetailField(
                        'Description',
                        rectificationData![
                            'description']), // Add a description if you have one

                  const SizedBox(height: 20),

                  // Acknowledge Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        sendPostRequest({
                          'ticket_number': rectificationData!['ticketNumber'],
                          // 'related_ticket': rectificationData!['relatedTicket'],
                          // 'tt_dms': rectificationData!['tt_dms'],
                          // 'project': rectificationData!['project'],
                          // 'segment': rectificationData!['segment'],
                          // 'section': rectificationData!['section'],
                          // 'area': rectificationData!['area'],
                          // 'service_point': rectificationData!['service_point'],
                          // 'span_route': rectificationData!['span_route'],
                          // 'longitude': rectificationData!['longitude'],
                          // 'latitude': rectificationData!['latitude'],
                          // 'description': rectificationData!['description'],
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainPage(
                                initialIndex:
                                    3), // Navigate with RectificationIndex tab active
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.black),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        'Acknowledge',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create each detail field with label and value
  Widget _buildDetailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label text outside and bold
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600, // Bold text
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6), // Spacing between label and input

          // Input value inside container
          Container(
            width: double.infinity, // Full width
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4), // Less rounded
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500, // Medium weight for value
              ),
            ),
          ),
        ],
      ),
    );
  }
}
