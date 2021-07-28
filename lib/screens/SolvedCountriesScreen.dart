import 'dart:math';

import 'package:flutter/material.dart';
import 'package:worldcountriesquiz/AppTheme.dart';
import 'package:worldcountriesquiz/Countries.dart';
import 'package:worldcountriesquiz/library.dart';
import 'package:worldcountriesquiz/screens/GameScreen.dart';

class SolvedCountriesScreen extends StatelessWidget {
    final String continentTitle;
    
    SolvedCountriesScreen({ Key? key, required this.continentTitle}) : super(key: key);

	@override
	Widget build(BuildContext context) {
        return SolvedCountries(continentTitle: continentTitle);
	}
}

class SolvedCountriesState extends State<SolvedCountries> {
    String? continentTitle;
    List<Country> countriesList = [];
    String expandedCountry = '';

    @override
	void initState() {
		super.initState();

        continentTitle = widget.continentTitle;
        countriesList = CountriesList.countries.where((country) => country.continent == continentTitle && country.isEasySolved).toList();
	}

	@override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    color: AppTheme.MAIN_COLOR,
                    image: DecorationImage(
                        colorFilter: ColorFilter.linearToSrgbGamma(),
                        image: AssetImage("assets/countries/$continentTitle/${countriesList[Random().nextInt(countriesList.length)].title}.png"),
                        fit: BoxFit.cover
                    )
                ),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
                    child: Center(
                        child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (BuildContext context, int index) {
                                return SizedBox( height: 20 );
                            },
                            itemCount: countriesList.length,
                            itemBuilder: (BuildContext context, int index) {
                                return getCountryCard(countriesList[index].title);
                            }
                        )
                    )
                ) 
            )
        );
    }

    Stack getCountryCard(String country) {
        return Stack(
            children: [
                Container(
                    height: 115,
                    color: Colors.transparent,
                    alignment: Alignment.topCenter,
                    child: countryCard(country, expandedCountry == country)
                ),
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: CountriesList.getCountryByTitle(country).isHardSolved ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Star(),
                                SizedBox(width: 10),
                                Star(),
                                SizedBox(width: 10),
                                Star()
                            ]
                        ) : CountriesList.getCountryByTitle(country).isNormalSolved ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Star(),
                                SizedBox(width: 10),
                                Star()
                            ]
                        ) : CountriesList.getCountryByTitle(country).isEasySolved ? Star() : SizedBox.shrink()
                    )
                )
            ]   
        );
    }

    Card countryCard(String title, bool expandOptions) {
        if (expandOptions) {
            return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Container(
                    height: 100,
                    child: Row(
                        children: [
                            Expanded(
                                child: getCountryCardTitle(title)
                            ),
                            Container(
                                width: 140,
                                child: Center(
                                    child: Row(
                                        children: [
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                    ModeDifficulty(event: () => navigate2GameScreen(GameMode.EASY), txt: 'Easy'),
                                                    ModeDifficulty(event: () => navigate2GameScreen(GameMode.NORMAL), txt: 'Normal'),
                                                ]
                                            ),
                                            ModeDifficulty(event: () => navigate2GameScreen(GameMode.HARD)),
                                        ]
                                    )
                                )
                            )
                        ]
                    )
                )
            );
        } else {
            return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Container(
                    height: 100,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0)
                        ),
                        onPressed: ()  { 
                            setState(() {
                                expandedCountry = title;
                            });
                        },
                        child: getCountryCardTitle(title)
                    )
                )
            );
        }
    }

    void navigate2GameScreen(GameMode mode) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GameScreen(countryTitle: expandedCountry, gameMode: mode)
            )
        ).then((value) {
            setState(() { });
        });
    }
}

class SolvedCountries extends StatefulWidget {
    final String continentTitle;

    SolvedCountries({ Key? key, required this.continentTitle }) : super(key: key);

	@override
	State createState() => SolvedCountriesState();
}