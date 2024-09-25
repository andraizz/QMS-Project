part of 'widgets.dart';

class ItemDescriptionDetail {
  static Widget primary(String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColor.greyColor3,
            fontSize: 10,
          ),
        ),
        const Gap(3),
        Text(
          data,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColor.defaultText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  static Widget primary2({String? title, String? data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColor.greyColor3,
            fontSize: 10,
          ),
        ),
        const Gap(3),
        Text(
          data!,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColor.defaultText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }


  static Widget secondary(
      String title, List<String> imageUrls, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColor.greyColor3,
            fontSize: 10,
          ),
        ),
        const Gap(3),
        Wrap(
          children: _buildImageDescriptions(imageUrls, context),
        ),
      ],
    );
  }

  static List<Widget> _buildImageDescriptions(
      List<String> imageUrls, BuildContext context) {
    List<Widget> widgets = [];
    int maxImageToShow = 3;
    int extraImageCount = imageUrls.length - maxImageToShow;

    for (int i = 0; i < imageUrls.length && i < maxImageToShow; i++) {
      if (i == maxImageToShow - 1 && extraImageCount > 0) {
        widgets.add(_buildExtraImageDescription(
            imageUrls[i], extraImageCount, context, imageUrls));
      } else {
        widgets.add(_buildImageDescription(imageUrls[i], context, imageUrls));
      }
    }

    return widgets;
  }

  static Widget _buildImageDescription(
      String imageUrl, BuildContext context, List<String> allImages) {
    return GestureDetector(
      onTap: () {
        _showAllImagesPage(context, allImages);
      },
      child: Container(
        width: 80,
        height: 70,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  static Widget _buildImageDecriptionFull(
      String imageUrl, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showFullScreeImagePage(context, imageUrl);
      },
      child: Container(
        width: double.infinity,
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  static Widget _buildExtraImageDescription(String imageUrl, int extraCount,
      BuildContext context, List<String> allImages) {
    return GestureDetector(
      onTap: () => _showAllImagesPage(context, allImages),
      child: Stack(
        children: [
          _buildImageDescription(imageUrl, context, allImages),
          Container(
            width: 80,
            height: 70,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                '+$extraCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _showAllImagesPage(BuildContext context, List<String> allImages) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBarWidget.secondary('All Documentation/Photos', context),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              itemCount: allImages.length,
              itemBuilder: (context, index) {
                return _buildImageDecriptionFull(allImages[index], context);
              },
            ),
          ),
        ),
      ),
    );
  }

  static void _showFullScreeImagePage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0, 
            iconTheme: const IconThemeData(
                color: Colors.white), 
          ),
          body: Center(
            child: InteractiveViewer(
              maxScale: 5.0,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // static void _showAllImagesDialog(BuildContext context, List<String> allImages) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Container(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 'All Images',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               Wrap(
  //                 children: allImages.map((imageUrl) => _buildImageDescription(imageUrl)).toList(),
  //               ),
  //               const SizedBox(height: 16),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text('Close'),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
