import 'dart:math';

import 'package:flutter/material.dart';
import 'package:worldcountriesquiz/AppTheme.dart';
import 'package:worldcountriesquiz/Countries.dart';
import 'package:worldcountriesquiz/library.dart';
import 'package:worldcountriesquiz/screens/GameScreen.dart';
import 'package:worldcountriesquiz/screens/SolvedCountriesScreen.dart';

class CountriesScreen extends StatelessWidget {

    CountriesScreen({ Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
        return Countries();
	}
}

class CountriesState extends State<Countries> {
    String backgroundImage = "assets/continents_background/${CONTINENTS[Random().nextInt(CONTINENTS.length)]}.png";
    Set<String> continents = CountriesList.getContinents();
    String expandedCountry = '';
    String countriesOrContinents = '';
    double dy = 0;

	@override
    Widget build(BuildContext context) {
        List<Country> availableCountries = CountriesList.countries.where((country) => !country.isEasySolved).toList();

        return Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    color: AppTheme.MAIN_COLOR,
                    image: DecorationImage(
                        colorFilter: ColorFilter.linearToSrgbGamma(),
                        image: AssetImage(backgroundImage),
                        fit: BoxFit.cover
                    )
                ),
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        children: [
                            countriesOrContinents == 'Continents' || availableCountries.length == 0 ? SizedBox.shrink() : Expanded(
                                child: Center(
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        separatorBuilder: (BuildContext context, int index) {
                                            return SizedBox( height: 20 );
                                        },
                                        itemCount: availableCountries.length,
                                        itemBuilder: (BuildContext context, int index) {
                                            return getCountryCard(availableCountries[index].title, expandedCountry == availableCountries[index].title);
                                        }
                                    )
                                )
                            ),
                            availableCountries.length == 0 ? SizedBox.shrink() : GestureDetector(
                                onVerticalDragUpdate: (dragUpdateDetails) {
                                    setState(() {
                                        dy = dragUpdateDetails.delta.dy;
                                    });
                                },
                                onVerticalDragEnd: (dragEndDetails) {
                                    if (dragEndDetails.velocity.pixelsPerSecond.dy == 0) return;

                                    if (dy > 0) {
                                        if (countriesOrContinents == 'Continents') {
                                            countriesOrContinents = '';
                                        } else {
                                            countriesOrContinents = 'Countries';
                                        }
                                    } else {
                                         if (countriesOrContinents == 'Countries') {
                                            countriesOrContinents = '';
                                        } else {
                                            countriesOrContinents = 'Continents';
                                        }
                                    }

                                    setState(() { });
                                },
                                child: Container(
                                    height: 60,
                                    color: Colors.transparent,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [ Dot(), Dot(), Dot() ]
                                    )
                                )
                            ),
                            countriesOrContinents == 'Countries' ? SizedBox.shrink() : Expanded(
                                child: Center(
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        separatorBuilder: (BuildContext context, int index) {
                                            return SizedBox(height: 20);
                                        },
                                        itemCount: continents.length,
                                        itemBuilder: (BuildContext context, int index) {
                                            return getContinentCard(continents.elementAt(index));
                                        }
                                    )
                                )
                            )
                        ]
                    )
                ) 
            )
        );
    }

    Card getCountryCard(String title, bool expandOptions) {
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

    Stack getContinentCard(String continent) {
        return Stack(
            children: [
                Container(
                    height: 115,
                    color: Colors.transparent,
                    alignment: Alignment.topCenter,
                    child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: CountriesList.getTotalSolvedStarsByContinent(continent) == 0 ? 0.6 : 1,
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0)
                                ),
                                onPressed: CountriesList.getTotalSolvedStarsByContinent(continent) == 0 ? null : () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SolvedCountries(continentTitle: continent)
                                        )
                                    ).then((value) {
                                        setState(() { });
                                    })
                                },
                                child: Container(
                                    height: 100,
                                    child: Center(
                                        child: Text(
                                            continent,
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: AppTheme.MAIN_COLOR
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    )
                ),
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: CountriesList.isContinentHardSolved(continent) ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Star(),
                                SizedBox(width: 10),
                                Star(),
                                SizedBox(width: 10),
                                Star()
                            ]
                        ) : CountriesList.isContinentNormalSolved(continent) ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Star(),
                                SizedBox(width: 10),
                                Star()
                            ]
                        ) : CountriesList.isContinentEasySolved(continent) ? Star() : SizedBox.shrink()
                    )
                ),
                Positioned(
                    right: 10,
                    top: 10,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                            Text(
                                '${CountriesList.getTotalSolvedStarsByContinent(continent)} / ${CountriesList.getTotalStarsByContinent(continent)}',
                                style: TextStyle(
                                    color: AppTheme.MAIN_COLOR,
                                    fontSize: 16
                                )
                            ),
                            SizedBox(width: 5),
                            Star(height: 20)
                        ]
                    )
                )
            ]   
        );
    }
}

class Dot extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        return Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
            )
        );
    }
}

class Countries extends StatefulWidget {

	@override
	State createState() => CountriesState();
}