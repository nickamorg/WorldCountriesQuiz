import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'dart:convert';

import 'package:worldcountriesquiz/DataStorage.dart';

class Country {
    String title;
    String continent;
    String capital;
    String iso;
    List<String> colors;
    int population;
    bool isLandlocked;
    String religion;
    List<String> languages;
    List<String> neighbors;
    bool isEasySolved = false;
    bool isNormalSolved = false;
    bool isHardSolved = false;

    Country({required this.title, required this.continent, required this.capital, required this.iso,
             required this.colors, required this.population, required this.isLandlocked,
             required this.religion, required this.languages, required this.neighbors}) {
        this.title = title;
        this.continent = continent;
        this.capital = capital;
        this.iso = iso;
        this.colors = colors;
        this.population = population;
        this.isLandlocked = isLandlocked;
        this.religion = religion;
        this.languages = languages;
        this.neighbors = neighbors;
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
                    countries.add(Country(title: title, continent: properties['Continent'], capital: properties['Capital'],
                                          colors: List<String>.from(properties['Colors']), iso: properties['ISO'],
                                          population: properties['Population'], isLandlocked: properties['Landlocked'],
                                          religion: properties['Religion'], languages: List<String>.from(properties['Languages']),
                                          neighbors: List<String>.from(properties['Neighbors'])));
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

    static bool isContinentNormalSolved(String continent) {
        return countries.where((country) => country.continent == continent).length == countries.where((country) => country.continent == continent && country.isNormalSolved).length;
    }

    static bool isContinentHardSolved(String continent) {
        return countries.where((country) => country.continent == continent).length == countries.where((country) => country.continent == continent && country.isHardSolved).length;
    }

    static int getTotalStarsByContinent(String continent) {
        return 3 * countries.where((country) => country.continent == continent).length;
    }

    static int getTotalCountriesByContinent(String continent) {
        return countries.where((country) => country.continent == continent).length;
    }

    static int getTotalSolvedStarsByContinent(String continent) {
        return getTotalEasySolvedStarsByContinent(continent) +
               getTotalNormalSolvedStarsByContinent(continent) +
               getTotalHardSolvedStarsByContinent(continent);
    }

    static int getTotalEasySolvedStarsByContinent(String continent) {
        return countries.where((country) => country.continent == continent && country.isEasySolved).length;
    }

    static int getTotalNormalSolvedStarsByContinent(String continent) {
        return countries.where((country) => country.continent == continent && country.isNormalSolved).length;
    }

    static int getTotalHardSolvedStarsByContinent(String continent) {
        return countries.where((country) => country.continent == continent && country.isHardSolved).length;
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
            str += '"${country.title}":{"isEasySolved":${country.isEasySolved},"isNormalSolved":${country.isNormalSolved}, "isHardSolved":${country.isHardSolved}}';

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
                            country.isNormalSolved = countryData['isNormalSolved'];
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