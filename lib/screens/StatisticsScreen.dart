import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:worldcountriesquiz/AppTheme.dart';
import 'package:worldcountriesquiz/Countries.dart';
import 'package:worldcountriesquiz/library.dart';

class StatisticsScreen extends StatelessWidget {

    StatisticsScreen({ Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
        return Statistics();
	}
}

class StatisticsState extends State<Statistics> {
    String backgroundImage = "assets/continents_background/${CONTINENTS[Random().nextInt(CONTINENTS.length)]}.png";
    Set<String> continents = CountriesList.getContinents();

	@override
    Widget build(BuildContext context) {

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
                    child: Center(
                        child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(height: 20);
                            },
                            itemCount: continents.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                                return index == 0 ? getContinentCard('World') : getContinentCard(continents.elementAt(index - 1));
                            }
                        )
                    )
                ) 
            )
        );
    }

    Card getContinentCard(String continent) {
        return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                    height: 220,
                    width: MediaQuery.of(context).size.width - 48,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                            Text(
                                continent,
                                style: TextStyle(
                                    fontSize: 30,
                                    color: AppTheme.MAIN_COLOR,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                            CountriesList.isContinentHardSolved(continent) ? Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Star(),
                                        SizedBox(width: 10),
                                        Star(),
                                        SizedBox(width: 10),
                                        Star()
                                    ]
                                )
                            ) : CountriesList.isContinentNormalSolved(continent) ? Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Star(),
                                        SizedBox(width: 10),
                                        Star()
                                    ]
                                )
                            ) : CountriesList.isContinentEasySolved(continent) ? Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Star()
                            ) : SizedBox.shrink(),
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Text(
                                            'Easy Quiz: ${CountriesList.getTotalEasySolvedStarsByContinent(continent)}/${CountriesList.getTotalCountriesByContinent(continent)}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: AppTheme.MAIN_COLOR
                                            )
                                        )
                                    ]
                                )
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Text(
                                        'Normal Quiz: ${CountriesList.getTotalNormalSolvedStarsByContinent(continent)}/${CountriesList.getTotalCountriesByContinent(continent)}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppTheme.MAIN_COLOR
                                        )
                                    )
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    SvgPicture.asset(
                                        'assets/devil.svg',
                                        height: 25
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                        '${CountriesList.getTotalHardSolvedStarsByContinent(continent)}/${CountriesList.getTotalCountriesByContinent(continent)}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppTheme.MAIN_COLOR
                                        )
                                    )
                                ]
                            ),
                            SizedBox(height: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Text(
                                        'Total: ${CountriesList.getTotalSolvedStarsByContinent(continent)}/${CountriesList.getTotalStarsByContinent(continent)}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppTheme.MAIN_COLOR,
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                    SizedBox(width: 10),
                                    Star(height: 20)
                                ]
                            )
                        ]
                    )
                )
            )
        );
    }
}

class Statistics extends StatefulWidget {

	@override
	State createState() => StatisticsState();
}