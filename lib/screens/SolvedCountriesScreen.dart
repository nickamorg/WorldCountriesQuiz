import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:worldcountriesquiz/Countries.dart';

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

    @override
	void initState() {
		super.initState();

        continentTitle = widget.continentTitle;
        countriesList = CountriesList.countries.where((country) => country.continent == continentTitle).toList();
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
                    child: ListView.separated(
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
        );
    }

    Stack getCountryCard(String country) {
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
                            onPressed: () => { },
                            child: Container(
                                height: 100,
                                child: Center(
                                    child: Text(
                                        country,
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
                        child: CountriesList.getCountryByTitle(country).isHardSolved ? Row(
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