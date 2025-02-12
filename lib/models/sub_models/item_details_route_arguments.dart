import '../item_details.dart';

class ItemDetailsRouteArguments {
  final int itemId;
  final String routeOrigin;
  final ItemDetails? itemDetails;

  ItemDetailsRouteArguments({
    required this.itemId,
    required this.routeOrigin,
    this.itemDetails,
  });
}
