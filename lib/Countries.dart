import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'dart:convert';

import 'package:worldcountriesquiz/DataStorage.dart';

class Country {
    String title;
    String continent;
    String currency;
    String capital;
    String iso;
    List<String> colors;
    int population;
    String dialingCode;
    bool isLandlocked;
    bool isEasySolved = false;
    bool isHardSolved = false;

    Country({required this.title, required this.continent, required this.currency, required this.capital, 
             required this.iso, required this.colors, required this.population, required this.dialingCode,
             required this.isLandlocked}) {
        this.title = title;
        this.continent = continent;
        this.currency = this.currency;
        this.capital = capital;
        this.iso = iso;
        this.colors = colors;
        this.population = population;
        this.dialingCode = dialingCode;
        this.isLandlocked = isLandlocked;
    }
}

class CountriesList {
	static List<Country> countries = [];

	static Future<bool> init() async {

        Future<String> loadAsset() async {
            return await rootBundle.loadString('assets/data/countries.json');
        }

		Future<bool> fetchCountries() async {
			await loadAsset().then((val) {
                Map<String, dynamic> countriesList = jsonDecode(val);

                countriesList['Countries'].forEach((title, value) {
                    Map<String, dynamic> properties = Map.from(value);
                    countries.add(Country(title: title, continent: properties['Continent'], currency: properties['Currency'],
                                          capital: properties['Capital'], colors: List<String>.from(properties['Colors']),
                                          dialingCode: properties['Dialing Code'], iso: properties['ISO'],
                                          population: properties['Population'], isLandlocked: properties['Landlocked']));
                });
            });
            
			countries.sort((a, b) {
                return a.title.compareTo(b.title);
            });

			return true;
		}

		return fetchCountries();
    }

    static bool isContinentEasySolved(String continent) {
        return countries.where((country) => country.continent == continent).length == countries.where((country) => country.continent == continent && country.isEasySolved).length;
    }

    static bool isContinentHardSolved(String continent) {
        return countries.where((country) => country.continent == continent).length == countries.where((country) => country.continent == continent && country.isHardSolved).length;
    }

    static int getTotalStarsByContinent(String continent) {
        return 2 * countries.where((country) => country.continent == continent).length;
    }

    static int getTotalSolvedStarsByContinent(String continent) {
        int count = 0;

        count += countries.where((country) => country.continent == continent && country.isEasySolved).length;
        count += countries.where((country) => country.continent == continent && country.isHardSolved).length;

        return count;
    }

    static Set<String> getContinents() {
        Set<String> continents = {};

        countries.forEach((country) { continents.add(country.continent);});

        return continents;
    }

    static Country getCountryByTitle(String title) {
        return countries.singleWhere((country) => country.title == title);
    }

    static void storeData() {
		String str = '{"Countries":{';

        int countryIdx = countries.length;
        countries.forEach((country) {
            str += '"${country.title}":{"isEasySolved":${country.isEasySolved},"isHardSolved":${country.isHardSolved}}';

            str += '${(--countryIdx > 0 ? ',' : '')}';
        });

        str += '},"hints":$hints}';

		DataStorage.writeData(str);
    }

    static loadDataStorage() {
		DataStorage.fileExists().then((value) {
			if (value) {
				DataStorage.readData().then((value) {
					if (value.isNotEmpty) {
						Map<String, dynamic> countriesList = jsonDecode(value);

                        countriesList['Countries'].forEach((countryTitle, countryData) {
                            Country? country = getCountryByTitle(countryTitle);

                            country.isEasySolved = countryData['isEasySolved'];
                            country.isHardSolved = countryData['isHardSolved'];
                        });

                        hints = countriesList['hints'];
                    }
				});
			} else {
				DataStorage.createFile();
			}
		});
	}
}

int hints = 9;