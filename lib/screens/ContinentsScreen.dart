import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:worldcountriesquiz/Logos.dart';
import 'package:worldcountriesquiz/AdManager.dart';
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
    bool dropSphere = false;

    @override
    void initState() {
        super.initState();
        LogosList.init().then((value) {
			LogosList.loadDataStorage();
		});

        AdManager.initGoogleMobileAds();
    }

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
                            return SizedBox( height: 20 );
                        },
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) {
                            return [ Stack(
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
                                                            builder: (context) => SolvedCountries()
                                                        )
                                                    )
                                                },
                                                child: Container(
                                                    height: 100,
                                                    child: Center(
                                                        child: Text(
                                                            'Asia',
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
                                            child: SvgPicture.asset(
                                                'assets/star.svg',
                                                height: 30
                                            )
                                        )
                                    ),
                                    Positioned(
                                        right: 10,
                                        top: 10,
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                                Text(
                                                    '33/43',
                                                    style: TextStyle(
                                                        color: Color(0xFF0FBEBE),
                                                        fontSize: 16
                                                    )
                                                ),
                                                SizedBox(width: 5),
                                                SvgPicture.asset(
                                                    'assets/star.svg',
                                                    height: 30
                                                )
                                            ]
                                        )
                                    )
                                ]   
                            ),
                            Stack(
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
                                                            builder: (context) => SolvedCountries()
                                                        )
                                                    )
                                                },
                                                child: Container(
                                                    height: 100,
                                                    child: Center(
                                                        child: Text(
                                                            'Europe',
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
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                    SvgPicture.asset(
                                                        'assets/star.svg',
                                                        height: 30
                                                    ),
                                                    SizedBox(width: 10),
                                                    SvgPicture.asset(
                                                        'assets/star.svg',
                                                        height: 30
                                                    )
                                                ]
                                            )
                                        )
                                    ),
                                    Positioned(
                                        right: 10,
                                        top: 10,
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                                Text(
                                                    '33/43',
                                                    style: TextStyle(
                                                        color: Color(0xFF0FBEBE),
                                                        fontSize: 16
                                                    )
                                                ),
                                                SizedBox(width: 5),
                                                SvgPicture.asset(
                                                    'assets/star.svg',
                                                    height: 30
                                                )
                                            ]
                                        )
                                    )
                                ]   
                            ) ][index];
                        }
                    )
                ) 
            )
        );
    }
}

Widget letter(String str) {
    return RotationTransition(
        turns: AlwaysStoppedAnimation(-15 / 360),
        child: Padding(
            padding: const EdgeInsets.only(left: 5, right:5),
            child: Container(
                height: 60,
                width: 60,
                child: Center(
                    child: Text(
                        str,
                        style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 30,
                            color: const Color(0xffce17ac),
                            fontWeight: FontWeight.w700
                        )
                    )
                ),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    boxShadow: [
                        BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(10, 10),
                            blurRadius: 10
                        )
                    ]
                )
            )
        )
    );
}

class Continents extends StatefulWidget {

	@override
	State createState() => ContinentsState();
}