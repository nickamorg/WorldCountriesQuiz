import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'dart:convert';

import 'package:worldcountriesquiz/DataStorage.dart';

class Logo {
    String title;
    bool isSolved = false;

    Logo({required this.title}) {
        this.title = title;
    }
}

class Category {
    String title;
    int highScore = 0;
    List<Logo> logos = [];

    Category({required this.title}) {
        this.title = title;
    }

    factory Category.fromJson(String title, List<dynamic> json) {
        Category cat = new Category(title: title);

        json.forEach((logo) {
            cat.logos.add(Logo(title: logo));
        });

        return cat;
    }

    int getTotalSolvedLogos() {
        int count = 0;

        logos.forEach((logo) { if (logo.isSolved) count++;});

		return count;
    }

    Logo? getLogoByTitle(String title) {
        for (int i = 0; i < logos.length; i++) {
            if (logos[i].title == title) return logos[i];
        }

        return null;
    }
}

class LogosList {
	static List<Category> categories = [];

	static Future<bool> init() async {
        categories = [];

        Future<String> loadAsset() async {
            return await rootBundle.loadString('assets/logos.json');
        }

		Future<bool> fetchLogos() async {
			await loadAsset().then((val) {
                Map<String, dynamic> logoList = jsonDecode(val);

                logoList.forEach((k, v) {
                    categories.add(Category.fromJson(k, v));
                });
            });
            
			categories.sort((a, b) {
                return a.title.compareTo(b.title);
            });

			return true;
		}

		return fetchLogos();
    }

    static void storeData() {
		String str = '{"categories":{';

        int catIdx = categories.length;
        categories.forEach((cat) {
            str += '"${cat.title}":{"highScore":${cat.highScore}, "logos": [';

            int logoIdx = cat.logos.length;
            cat.logos.forEach((logo) {
                str += '{"${logo.title}":${logo.isSolved}}${(--logoIdx > 0 ? ',' : '')}';
            });

            str += ']}${(--catIdx > 0 ? ',' : '')}';
        });

        str += '},"hints":$hints}';

		DataStorage.writeData(str);
    }

    static Category? getCategoryByTitle(String title) {
        for (int i = 0; i < categories.length; i++) {
            if (categories[i].title == title) return categories[i];
        }

        return null;
    }

    static loadDataStorage() {
		DataStorage.fileExists().then((value) {
			if (value) {
				DataStorage.readData().then((value) {
					if (value.isNotEmpty) {
						Map<String, dynamic> categoriesList = jsonDecode(value);

                        categoriesList['categories'].forEach((catTitle, catLogos) {
                            Category? cat = getCategoryByTitle(catTitle);

                            cat!.highScore = catLogos['highScore'];

                            catLogos['logos'].forEach((logo) {
                                cat.getLogoByTitle(logo.entries.first.key)!.isSolved = logo.entries.first.value;
                            });
                        });

                        hints = categoriesList['hints'];
                    }
				});
			} else {
				DataStorage.createFile();
			}
		});
	}
}

int hints = 9;