import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegionsByCountry {
  RegionsByCountry(this.context);

  final BuildContext context;

  static RegionsByCountry? of(BuildContext context) {
    return RegionsByCountry(context);
  }

  List<String> regionsByCountry(Country country) {
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
      case 'DZ':
        return [
          AppLocalizations.of(context)!.algiers,
          AppLocalizations.of(context)!.bejaia,
          AppLocalizations.of(context)!.chlefProvince,
          AppLocalizations.of(context)!.dahra,
          AppLocalizations.of(context)!.mascara,
          AppLocalizations.of(context)!.medea,
          AppLocalizations.of(context)!.tlemcen,
          AppLocalizations.of(context)!.zaccar,
        ];
      case 'AR':
        return [
          AppLocalizations.of(context)!.buenosAiresProvince,
          AppLocalizations.of(context)!.buenosAiresProvinceMedanos,
          AppLocalizations.of(context)!.catamarcaProvince,
          AppLocalizations.of(context)!.laRiojaProvince,
          AppLocalizations.of(context)!.mendozaProvince,
          AppLocalizations.of(context)!.neuquenProvince,
          AppLocalizations.of(context)!.rioNegroProvince,
          AppLocalizations.of(context)!.saltaProvince,
          AppLocalizations.of(context)!.sanJuanProvince,
        ];
      case 'AM':
        return [
          AppLocalizations.of(context)!.araratValley,
          AppLocalizations.of(context)!.areni,
          AppLocalizations.of(context)!.ijevan,
        ];
      case 'AU':
        return [
          AppLocalizations.of(context)!.canberra,
          AppLocalizations.of(context)!.hallCapitalTerritory,
          AppLocalizations.of(context)!.majura,
          AppLocalizations.of(context)!.bigRivers,
          AppLocalizations.of(context)!.bigRiversMurrayDarling,
          AppLocalizations.of(context)!.bigRiversPerricoota,
          AppLocalizations.of(context)!.bigRiversRiverina,
          AppLocalizations.of(context)!.bigRiversSwanHill,
          AppLocalizations.of(context)!.centralRanges,
          AppLocalizations.of(context)!.centralRangesCowra,
          AppLocalizations.of(context)!.centralRangesMudgee,
          AppLocalizations.of(context)!.centralRangesOrange,
          AppLocalizations.of(context)!.hunterValley,
          AppLocalizations.of(context)!.hunterValleyHunter,
          AppLocalizations.of(context)!.hunterValleyBrokeFordwich,
          AppLocalizations.of(context)!.hunterValleyPokolbin,
          AppLocalizations.of(context)!.hunterValleyUpperHunterValley,
          AppLocalizations.of(context)!.northernRivers,
          AppLocalizations.of(context)!.northernRiversHastingsRiver,
          AppLocalizations.of(context)!.northernTablelands,
          AppLocalizations.of(context)!.northernTablelandsNewEngland,
          AppLocalizations.of(context)!.southCoast,
          AppLocalizations.of(context)!.southCoastShoalhavenCoast,
          AppLocalizations.of(context)!.southCoastSouthernHighlands,
          AppLocalizations.of(context)!.southernNewSouthWales,
          AppLocalizations.of(context)!.southernNewSouthWalesCanberraDistrict,
          AppLocalizations.of(context)!.southernNewSouthWalesGundagai,
          AppLocalizations.of(context)!.southernNewSouthWalesHilltops,
          AppLocalizations.of(context)!.southernNewSouthWalesTumbarumba,
        ];
      case 'AT':
        return [
          AppLocalizations.of(context)!.burgenland,
          AppLocalizations.of(context)!.kamptal,
          AppLocalizations.of(context)!.kremstal,
          AppLocalizations.of(context)!.wachau,
          AppLocalizations.of(context)!.wagram,
          AppLocalizations.of(context)!.weinviertel,
          AppLocalizations.of(context)!.southernStyria,
          AppLocalizations.of(context)!.vienna,
        ];
      case 'AZ':
        return [
          AppLocalizations.of(context)!.aghdam,
          AppLocalizations.of(context)!.baku,
          AppLocalizations.of(context)!.ganja,
          AppLocalizations.of(context)!.shamakhiRayonn,
          AppLocalizations.of(context)!.tovuz,
          AppLocalizations.of(context)!.shamkir,
        ];
      case 'BE':
        return [
          AppLocalizations.of(context)!.sambreEtMeuse,
          AppLocalizations.of(context)!.hageland,
          AppLocalizations.of(context)!.haspengouw,
          AppLocalizations.of(context)!.heuvelland,
        ];
      case 'BO':
        return [
          AppLocalizations.of(context)!.tarija
        ];
      case 'BA':
        return [
          AppLocalizations.of(context)!.capljina,
          AppLocalizations.of(context)!.citluk,
          AppLocalizations.of(context)!.ljubuski,
          AppLocalizations.of(context)!.medugorje,
          AppLocalizations.of(context)!.mostar,
          AppLocalizations.of(context)!.stolac,
          AppLocalizations.of(context)!.trebinje,
        ];
      case 'BR':
        return [
          AppLocalizations.of(context)!.bahia,
          AppLocalizations.of(context)!.matoGrosso,
          AppLocalizations.of(context)!.minasGerais,
          AppLocalizations.of(context)!.parana,
          AppLocalizations.of(context)!.pernambuco,
          AppLocalizations.of(context)!.rioGrandeDoSul,
          AppLocalizations.of(context)!.santaCatarina,
          AppLocalizations.of(context)!.saoPaulo,
        ];
      case 'BG':
        return [
          AppLocalizations.of(context)!.blackSeaRegion,
          AppLocalizations.of(context)!.danubianPlain,
          AppLocalizations.of(context)!.roseValley,
          AppLocalizations.of(context)!.thrace,
          AppLocalizations.of(context)!.valleyOfTheStrumaRiver,
        ];
      case 'CA':
        return [
          AppLocalizations.of(context)!.britishColumbia,
          AppLocalizations.of(context)!.novaScotia,
          AppLocalizations.of(context)!.ontario,
          AppLocalizations.of(context)!.quebec,
        ];
      case 'CV':
        return [
          AppLocalizations.of(context)!.chaDasCaldeiras,
        ];
      case 'CN':
        return [
          AppLocalizations.of(context)!.changan,
          AppLocalizations.of(context)!.gaochang,
          AppLocalizations.of(context)!.luoyang,
          AppLocalizations.of(context)!.qiuci,
          AppLocalizations.of(context)!.yantaiPenglai,
          AppLocalizations.of(context)!.dalianLiaoning,
          AppLocalizations.of(context)!.tonghuaJilin,
          AppLocalizations.of(context)!.yantaiShandong,
          AppLocalizations.of(context)!.yibinSichuan,
          AppLocalizations.of(context)!.zhangjiakouHebei,
        ];
      case 'CO':
        return [
          AppLocalizations.of(context)!.villaDeLeyva,
          AppLocalizations.of(context)!.valleDelCauca,
        ];
      case 'CR':
        return [
          AppLocalizations.of(context)!.valleCentral,
          AppLocalizations.of(context)!.dota,
        ];
      case 'CL':
        return [
          AppLocalizations.of(context)!.aconcagua,
          AppLocalizations.of(context)!.atacama,
          AppLocalizations.of(context)!.centralValley,
          AppLocalizations.of(context)!.coquimbo,
          AppLocalizations.of(context)!.pica,
          AppLocalizations.of(context)!.southernChile,
        ];
      case 'HR':
        return [
          AppLocalizations.of(context)!.moslavina,
          AppLocalizations.of(context)!.plesivica,
          AppLocalizations.of(context)!.podunavlje,
          AppLocalizations.of(context)!.pokuplje,
          AppLocalizations.of(context)!.prigorjeBilogora,
          AppLocalizations.of(context)!.slavonia,
          AppLocalizations.of(context)!.zagorjeMedimurje,
          AppLocalizations.of(context)!.hrvatskoPrimorje,
          AppLocalizations.of(context)!.dalmatinskaZagora,
          AppLocalizations.of(context)!.srednjaIJuznaDalmacija,
          AppLocalizations.of(context)!.sjevernaDalmacija,
          AppLocalizations.of(context)!.istria,
        ];
      case 'CY':
        return [
          AppLocalizations.of(context)!.commandaria,
          AppLocalizations.of(context)!.laonaAkamas,
          AppLocalizations.of(context)!.vouniPanagias,
          AppLocalizations.of(context)!.krasochoriaLemesou,
          AppLocalizations.of(context)!.pitsilia,
          AppLocalizations.of(context)!.diarizosValley,
        ];
      case 'CZ':
        return [
          AppLocalizations.of(context)!.moravia,
          AppLocalizations.of(context)!.bohemia,
          AppLocalizations.of(context)!.prague,
        ];
    }

    return [];/*: [
      'Algiers'
    ],
    'France': [
      'Alsace',
      'Beaujolais',
      'Bordeaux',
      'Bourgogne',
      'Champagne',
      'Corse',
      'Jura',
      'Languedoc-Roussillon',
      'Loire',
      'Provence',
      'Savoie',
      'Sud-Ouest',
      'Vallée du Rhône',
    ],
    'Nigeria': [
      'Abia',
      'Adamawa',
      'Akwa Ibom',
      'Anambra',
      'Bauchi',
      'Bayelsa',
    ]*/
  }
}