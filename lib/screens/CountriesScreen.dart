import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    Set<String> continents = CountriesList.getContinents();
    String expandedCountry = '';

	@override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF0FBEBE),
                    image: DecorationImage(
                        colorFilter: ColorFilter.linearToSrgbGamma(),
                        image: AssetImage("assets/world.png"),
                        fit: BoxFit.cover
                    )
                ),
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        children: [
                            Expanded(
                                child: ListView.separated(
                                    separatorBuilder: (BuildContext context, int index) {
                                        return SizedBox( height: 20 );
                                    },
                                    itemCount: CountriesList.countries.where((country) => !country.isEasySolved).length,
                                    itemBuilder: (BuildContext context, int index) {
                                        return getCountryCard(CountriesList.countries.where((country) => !country.isEasySolved).toList()[index].title, expandedCountry == CountriesList.countries.where((country) => !country.isEasySolved).toList()[index].title);
                                    }
                                )
                            ),
                            Container(
                                height: 60,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [ Dot(), Dot(), Dot() ]
                                )
                            ),
                            Expanded(
                                child: ListView.separated(
                                    separatorBuilder: (BuildContext context, int index) {
                                        return SizedBox(height: 20);
                                    },
                                    itemCount: continents.length,
                                    itemBuilder: (BuildContext context, int index) {
                                        return getContinentCard(continents.elementAt(index));
                                    }
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
                                child: getCardTitle(title)
                            ),
                            Container(
                                width: 140,
                                child: Center(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                            getModeCard(GameMode.EASY),
                                            getModeCard(GameMode.HARD)
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
                        child: getCardTitle(title)
                    )
                )
            );
        }
    }

    Widget getCardTitle(String title) {
        return Center(
            child: Text(
                title,
                style: TextStyle(
                    fontSize: 30,
                    color: Color(0xFF0FBEBE)
                )
            )
        );
    }

    Card getModeCard(GameMode mode) {
        return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child: Container(
                height: 40,
                width: 80,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    border: Border.all(
                        color: Color(0xFF0FBEBE),
                        width: 1
                    )
                ),
                child: TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0)
                    ),
                    onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GameScreen(countryTitle: expandedCountry, gameMode: mode)
                            )
                        ).then((value) {
                            setState(() { });
                        })
                    },
                    child: Center(
                        child: Text(
                            enum2String(mode),
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF0FBEBE)
                            )
                        )
                    )
                )
            )
        );
    }

    String enum2String(GameMode mode) {
        String str = mode.toString().split('.').last.toLowerCase();
        str = str[0].toUpperCase() + str.substring(1);

        return str;
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
                                                color: Color(0xFF0FBEBE)
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
                                    color: Color(0xFF0FBEBE),
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

class Star extends StatelessWidget {
    final double height;
    
    Star({this.height = 30});

    @override
    Widget build(BuildContext context) {
        return SvgPicture.asset(
            'assets/star.svg',
            height: height
        );
    }
}

class Countries extends StatefulWidget {

	@override
	State createState() => CountriesState();
}