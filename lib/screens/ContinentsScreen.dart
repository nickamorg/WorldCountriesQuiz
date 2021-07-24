import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:worldcountriesquiz/Countries.dart';
import 'package:worldcountriesquiz/screens/SolvedCountriesScreen.dart';

class ContinentsScreen extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
        return MaterialApp(
			home: Continents()
		);
	}
}

class ContinentsState extends State<Continents> {
    Set<String> continents = CountriesList.getContinents();

	@override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF0FBEBE),
                    image: DecorationImage(
                        colorFilter: ColorFilter.linearToSrgbGamma(),
                        image: AssetImage("assets/world.png"),
                        fit: BoxFit.cover,
                    )
                ),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
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
            )
        );
    }

    Stack getContinentCard(String continent) {
        return Stack(
            children: [
                Container(
                    height: 115,
                    color: Colors.transparent,
                    alignment: Alignment.topCenter,
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.all(0)
                            ),
                            onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SolvedCountries(continentTitle: continent)
                                    )
                                )
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

class Continents extends StatefulWidget {

	@override
	State createState() => ContinentsState();
}