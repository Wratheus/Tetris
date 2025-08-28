import 'package:flutter/material.dart';

@immutable
class Identica {
  const Identica({
    required this.icon,
    this.iconBackgroundColor = Colors.black,
    this.fill = 0.0,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final double? fill;

  @override
  String toString() =>
      'Identica{icon: $icon, iconColor: $iconColor, iconBackgroundColor: $iconBackgroundColor, fill: $fill}';

  Identica copyWith({
    IconData? icon,
    Color? iconColor,
    Color? iconBackgroundColor,
    double? fill,
  }) =>
      Identica(
        icon: icon ?? this.icon,
        fill: fill ?? this.fill,
        iconColor: iconColor ?? this.iconColor,
        iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      );

  /// all identicas for randomizing, is immutable list object.
  static List<Identica> allIdenticas = List.unmodifiable(
    [
      //   const ModuleAuthIdentica(),
      //   const ModuleInventoryIdentica(),
      //   const ModulePackageIdentica(),
      //   const ModuleCellIdentica(),
      //   const ModuleLogisticsIdentica(),
      //   const ModuleTradingHallIdentica(),
      //   const ModuleAcceptanceOnAdmissionOCIdentica(),
      //   const ModuleAcceptanceOnAdmissionWOCIdentica(),
      //   const ModuleAcceptanceOnMoveIdentica(),
      //   const ModuleMovingWarehouseIdentica(),
      //   const ModuleShipmentOnOrderIdentica(),
      //   const ModuleCodeMarkLocationIdentica(),
      //   const ProductCheckingIdentica(),
      //   const CodeMarkWarehouseLocationIdentica(),
      //   const LogisticsTypeAvailabilityIdentica(),
      //   const LogisticsTypeDispatchIdentica(),
      //   const LogisticsTypePackIdentica(),
      //   const LogisticsTypeReceivedIdentica(),
      //   const LogisticsTypeReturnsIdentica(),
      //   const LogisticsTypeSendIdentica(),
      //   const LogisticsTypeWithdrawIdentica(),
    ],
  );
}
