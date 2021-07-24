import 'package:flutter/material.dart';
import 'package:worldcountriesquiz/Countries.dart';
import 'package:worldcountriesquiz/library.dart';
import 'package:worldcountriesquiz/screens/GameScreen.dart';

class CountriesScreen extends StatelessWidget {

    CountriesScreen({ Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
        return Countries();
	}
}

class CountriesState extends State<Countries> {
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                            return SizedBox( height: 20 );
                        },
                        itemCount: CountriesList.countries.length,
                        itemBuilder: (BuildContext context, int index) {
                            return getCountryCard(CountriesList.countries[index].title, expandedCountry == CountriesList.countries[index].title);
                        }
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
                        )
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
}

class Countries extends StatefulWidget {

	@override
	State createState() => CountriesState();
}