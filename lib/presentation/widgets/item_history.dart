part of 'widgets.dart';

class ItemHistory {
  static Widget installation(
    String idTicket,
    String status,    
    Color statusColor, {
    void Function()? onTap,
    String? date,
    String? createdBy,
    String? ttDms,
    String? servicePoint,
    String? sectionName,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 6,
                left: 6,
                right: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    idTicket,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const Gap(3),
                  Container(
                    height: 15,
                    width: 70,
                    decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        status,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 8,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Details >',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: AppColor.defaultText,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: AppColor.greyColor2,
            ),
            ItemTextHistory.primary("Date", date ?? '-', 1),
            ItemTextHistory.primary("Created By", createdBy ?? '-', 1),
            ItemTextHistory.primary("TT DMS", ttDms ?? '-', 1),
            ItemTextHistory.primary("Service Point", servicePoint ?? '-', 1),
            ItemTextHistory.primary("Section Name", sectionName ?? '-', 2, width: 150),
            const Gap(12)
          ],
        ),
      ),
    );
  }
}
