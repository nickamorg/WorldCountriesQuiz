import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                    color: Color(0xFF0FBEBE),
                    image: DecorationImage(
                        colorFilter: ColorFilter.linearToSrgbGamma(),
                        image: AssetImage("assets/countries/Europe/Greece.png"),
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
                        child: CountriesList.getCountryByTitle(country).isUltimateSolved ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Star(),
                                SizedBox(width: 10),
                                Star(),
                                SizedBox(width: 10),
                                Star()
                            ]
                        ) : CountriesList.getCountryByTitle(country).isHardSolved ? Row(
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
                                child: getCardTitle(title)
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
                                                    getModeCard(GameMode.EASY),
                                                    getModeCard(GameMode.HARD)
                                                ]
                                            ),
                                            getUltimateModeCard()
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

    Card getUltimateModeCard() {
        return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child: Container(
                height: 85,
                width: 40,
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
                                builder: (context) => GameScreen(countryTitle: expandedCountry, gameMode: GameMode.ULTIMATE)
                            )
                        ).then((value) {
                            setState(() { });
                        })
                    },
                    child: Center(
                        child: SvgPicture.asset(
                            'assets/devil.svg',
                            height: 25
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

class SolvedCountries extends StatefulWidget {
    final String continentTitle;

    SolvedCountries({ Key? key, required this.continentTitle }) : super(key: key);

	@override
	State createState() => SolvedCountriesState();
}