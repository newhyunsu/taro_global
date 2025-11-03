import 'dart:io';

class AdInventory {
  final String inventoryName;
  final String aos;
  final String ios;

  AdInventory({
    required this.inventoryName,
    required this.aos,
    required this.ios,
  });

  String getAdUnitId() {
    if (Platform.isAndroid) {
      return aos;
    } else {
      return ios;
    }
  }
}
