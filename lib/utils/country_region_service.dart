import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CountryRegionService {

  static List<String> getRegionsByCountry(BuildContext context, Country? country) {
    if (country == null) {
      return [];
    }

    switch (country.countryCode) {
      case 'AL':
        return [
          AppLocalizations.of(context)!.berat,
          AppLocalizations.of(context)!.korca,
          AppLocalizations.of(context)!.leskovik,
          AppLocalizations.of(context)!.lezhe,
          AppLocalizations.of(context)!.permet,
          AppLocalizations.of(context)!.shkoder,
          AppLocalizations.of(context)!.tiranaCounty,
        ];
      default:
        return [];
    }
  }
}