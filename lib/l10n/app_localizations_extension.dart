import 'package:flutter/material.dart';

import 'app_localizations.dart';

extension AppLocalizationsExtension on BuildContext {
  String localizeAppBarTitle(String title) {
    final localizations = AppLocalizations.of(this)!;
    return switch (title) {
      'Chat' => localizations.chat,
      'New Repair Request' => localizations.newRepairRequest,
      'Order details' => localizations.orderDetails,
      'Technician Offers' => localizations.technicianOffers,
      'Send offer' => localizations.sendOffer,
      'Rate technician' => localizations.rateTechnician,
      _ => title,
    };
  }
}
