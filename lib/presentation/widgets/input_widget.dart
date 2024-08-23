part of 'widgets.dart';

class InputWidget {
  static Widget disable(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(3),
        SizedBox(
          height: 50,
          child: TextFormField(
            readOnly: true,
            controller: controller,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColor.greyColor2,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColor.disable,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColor.disable)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.disable)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.disable)),
            ),
          ),
        ),
      ],
    );
  }

  static Widget textArea(
      String title, String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(3),
        SizedBox(
          height: 100,
          child: TextFormField(
            controller: controller,
            maxLines: 4,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColor.defaultText,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: AppColor.whiteColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColor.defaultText)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.defaultText)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.defaultText)),
            ),
          ),
        ),
      ],
    );
  }

  static Widget dropDown(String title, String hintText, String? value,
      List<String> items, void Function(String?)? onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(3),
        SizedBox(
          height: 50,
          child: DropdownButtonFormField(
            value: value,
            hint: Text(
              hintText,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColor.greyColor2),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColor.disable,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColor.disable)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.defaultText)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.disable)),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColor.greyColor2,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  static Widget dropDown2(
      String title,
      String hintText,
      String? value,
      List<String> items,
      void Function(String?)? onChanged,
      String hintTextSearch) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(3),
        SizedBox(
          height: 50,
          child: DropdownSearch<String>(
            selectedItem: value,
            items: items,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                filled: true,
                fillColor: AppColor.whiteColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: AppColor.defaultText)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.defaultText)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.defaultText)),
              ),
            ),
            onChanged: onChanged,
            popupProps: PopupProps.dialog(
              dialogProps: DialogProps(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 8),
              // isFilterOnline: true, //Untuk Mengaktifkan Jika mengambil data dari online
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: hintTextSearch,
                  filled: true,
                  fillColor: AppColor.disable,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.defaultText)),
                ),
              ),
            ),
            dropdownBuilder: (context, selectedItem) => Text(
              selectedItem ?? hintText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColor.defaultText,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget uploadFile(String title, String textButton) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(3),
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            border: Border.all(
              color: AppColor.defaultText
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 36,
              ),
              child: DButtonFlat(
                onClick: () {},
                height: 40,
                mainColor: AppColor.blueColor1,
                radius: 10,
                child: Text(
                  textButton,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
