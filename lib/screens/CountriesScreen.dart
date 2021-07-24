import 'package:flutter/material.dart';
import 'package:worldcountriesquiz/Countries.dart';

class CountriesScreen extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
        return MaterialApp(
			home: Countries()
		);
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
                        fit: BoxFit.cover,
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
                                            getModeCard('Easy'),
                                            getModeCard('Hard')
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

    Card getModeCard(String title) {
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
                    onPressed: () => { },
                    child: Center(
                        child: Text(
                            title,
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
}

class Countries extends StatefulWidget {

	@override
	State createState() => CountriesState();
}