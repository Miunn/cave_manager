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
        return [AppLocalizations.of(context)!.tarija];
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
      case 'FR':
        return [
          AppLocalizations.of(context)!.alsace,
          AppLocalizations.of(context)!.bordeaux,
          AppLocalizations.of(context)!.bourgogne,
          AppLocalizations.of(context)!.champagne,
          AppLocalizations.of(context)!.corsica,
          AppLocalizations.of(context)!.jura,
          AppLocalizations.of(context)!.languedocRoussillon,
          AppLocalizations.of(context)!.loireValley,
          AppLocalizations.of(context)!.lorraine,
          AppLocalizations.of(context)!.madiran,
          AppLocalizations.of(context)!.provence,
          AppLocalizations.of(context)!.rhone,
          AppLocalizations.of(context)!.savoy,
        ];
      case 'GE':
        return [
          AppLocalizations.of(context)!.abkhazia,
          AppLocalizations.of(context)!.kakheti,
          AppLocalizations.of(context)!.imereti,
          AppLocalizations.of(context)!.kartli,
          AppLocalizations.of(context)!.rachaLechkhumiAndKvemoSvaneti,
        ];
      case 'GR':
        return [
          AppLocalizations.of(context)!.crete,
          AppLocalizations.of(context)!.limnos,
          AppLocalizations.of(context)!.paros,
          AppLocalizations.of(context)!.rhodes,
          AppLocalizations.of(context)!.samos,
          AppLocalizations.of(context)!.santorini,
          AppLocalizations.of(context)!.attica,
          AppLocalizations.of(context)!.epirus,
          AppLocalizations.of(context)!.thessaly,
          AppLocalizations.of(context)!.kefalonia,
          AppLocalizations.of(context)!.macedonia,
          AppLocalizations.of(context)!.peloponnesus,
        ];
      case 'HU':
        return [
          AppLocalizations.of(context)!.balaton,
          AppLocalizations.of(context)!.duna,
          AppLocalizations.of(context)!.eger,
          AppLocalizations.of(context)!.pannon,
          AppLocalizations.of(context)!.sopron,
          AppLocalizations.of(context)!.tokaj,
        ];
      case 'IN':
        return [
          AppLocalizations.of(context)!.nashikMaharashtra,
          AppLocalizations.of(context)!.bangaloreKarnataka,
          AppLocalizations.of(context)!.vijayapuraKarnataka,
          AppLocalizations.of(context)!.narayangaon,
          AppLocalizations.of(context)!.puneMaharashtra,
          AppLocalizations.of(context)!.sangliMaharashtra,
        ];

      case 'ID':
        return [
          AppLocalizations.of(context)!.bali,
        ];
      case 'IR':
        return [
          AppLocalizations.of(context)!.malayer,
          AppLocalizations.of(context)!.shiraz,
          AppLocalizations.of(context)!.takestan,
          AppLocalizations.of(context)!.urmia,
          AppLocalizations.of(context)!.qazvin,
          AppLocalizations.of(context)!.quchan,
        ];
      case 'IE':
        return [
          AppLocalizations.of(context)!.cork,
        ];
      case 'IL':
        return [
          AppLocalizations.of(context)!.galilee,
          AppLocalizations.of(context)!.judeanHills,
          AppLocalizations.of(context)!.mountCarmel,
          AppLocalizations.of(context)!.rishonLeZion,
        ];
      case 'IT':
        return [
          AppLocalizations.of(context)!.apulia,
          AppLocalizations.of(context)!.calabria,
          AppLocalizations.of(context)!.campania,
          AppLocalizations.of(context)!.emiliaRomagna,
          AppLocalizations.of(context)!.liguria,
          AppLocalizations.of(context)!.lombardy,
          AppLocalizations.of(context)!.marche,
          AppLocalizations.of(context)!.piedmont,
          AppLocalizations.of(context)!.sardinia,
          AppLocalizations.of(context)!.sicily,
          AppLocalizations.of(context)!.trentinoAltoAdige,
          AppLocalizations.of(context)!.tuscany,
          AppLocalizations.of(context)!.umbria,
          AppLocalizations.of(context)!.veneto,
        ];
      case 'JP':
        return [
          AppLocalizations.of(context)!.hokkaido,
          AppLocalizations.of(context)!.nagano,
          AppLocalizations.of(context)!.yamanashi,
        ];
      case 'LV':
        return [
          AppLocalizations.of(context)!.sabile,
        ];
      case 'LB':
        return [
          AppLocalizations.of(context)!.bekaaValley,
          AppLocalizations.of(context)!.mountLebanon,
          AppLocalizations.of(context)!.chekka,
          AppLocalizations.of(context)!.ehden,
          AppLocalizations.of(context)!.koura,
          AppLocalizations.of(context)!.qadishaValley,
          AppLocalizations.of(context)!.tripoli,
          AppLocalizations.of(context)!.zgharta,
          AppLocalizations.of(context)!.jezzine,
          AppLocalizations.of(context)!.marjayoun,
          AppLocalizations.of(context)!.rmaich,
        ];
      case 'LT':
        return [
          AppLocalizations.of(context)!.anyksciy,
          AppLocalizations.of(context)!.memelio,
        ];
      case 'LU':
        return [
          AppLocalizations.of(context)!.moselleValley,
        ];
      case 'MX':
        return [
          AppLocalizations.of(context)!.aguascalientes,
          AppLocalizations.of(context)!.bajaCalifornia,
          AppLocalizations.of(context)!.coahuilaDurangoLaLaguna,
          AppLocalizations.of(context)!.guanajuato,
          AppLocalizations.of(context)!.hidalgo,
          AppLocalizations.of(context)!.nuevoLeon,
          AppLocalizations.of(context)!.queretaro,
          AppLocalizations.of(context)!.sonora,
          AppLocalizations.of(context)!.zacatecas,
        ];
      case 'MD':
        return [
          AppLocalizations.of(context)!.bardar,
          AppLocalizations.of(context)!.codri,
          AppLocalizations.of(context)!.cricova,
          AppLocalizations.of(context)!.hincesti,
          AppLocalizations.of(context)!.purcari,
        ];
      case 'ME':
        return [
          AppLocalizations.of(context)!.crmnica,
          AppLocalizations.of(context)!.plantaze,
        ];
      case 'MA':
        return [
          AppLocalizations.of(context)!.atlasMountains,
          AppLocalizations.of(context)!.benslimane,
          AppLocalizations.of(context)!.meknes,
        ];
      case 'NL':
        return [
          AppLocalizations.of(context)!.groesbeek,
        ];
      case 'NZ':
        return [
          AppLocalizations.of(context)!.auckland,
          AppLocalizations.of(context)!.canterbury,
          AppLocalizations.of(context)!.centralOtago,
          AppLocalizations.of(context)!.gisborne,
          AppLocalizations.of(context)!.hawkesBay,
          AppLocalizations.of(context)!.marlborough,
          AppLocalizations.of(context)!.nelson,
          AppLocalizations.of(context)!.northland,
          AppLocalizations.of(context)!.waikato,
          AppLocalizations.of(context)!.wairarapa,
          AppLocalizations.of(context)!.waitakiValley,
        ];
    }

    return []; /*: [
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
