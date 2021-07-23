import 'package:flutter/material.dart';
import 'package:worldcountriesquiz/Logos.dart';
import 'package:worldcountriesquiz/AdManager.dart';
import 'package:worldcountriesquiz/screens/CountriesScreen.dart';
import 'package:worldcountriesquiz/screens/ContinentsScreen.dart';

class ContentScreen extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
        return MaterialApp(
			home: Content()
		);
	}
}

class ContentState extends State<Content> {
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
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height / 2 - 100,
                                    child: TextButton(
                                        onPressed: () => {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => CountriesScreen()
                                                )
                                            )
                                        },
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                                Text(
                                                    'Unlock More',
                                                    style: TextStyle(
                                                        fontSize: 40,
                                                        color: Color(0xFF0FBEBE)
                                                    )
                                                ),
                                                Text(
                                                    'Countries',
                                                    style: TextStyle(
                                                        fontSize: 40,
                                                        color: Color(0xFF0FBEBE)
                                                    )
                                                )
                                            ]
                                        )
                                    )
                                )
                            ),
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height / 2 - 100,
                                    child: TextButton(
                                        onPressed: () => {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ContinentsScreen()
                                                )
                                            )
                                        },
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                                Text(
                                                    'Solved',
                                                    style: TextStyle(
                                                        fontSize: 40,
                                                        color: Color(0xFF0FBEBE)
                                                    )
                                                ),
                                                Text(
                                                    'Countries',
                                                    style: TextStyle(
                                                        fontSize: 40,
                                                        color: Color(0xFF0FBEBE)
                                                    )
                                                )
                                            ]
                                        )
                                    )
                                )
                            )
                        ]
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

class Content extends StatefulWidget {

	@override
	State createState() => ContentState();
}