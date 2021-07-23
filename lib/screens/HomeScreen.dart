import 'package:flutter/material.dart';
import 'package:worldcountriesquiz/Logos.dart';
import 'package:worldcountriesquiz/AdManager.dart';
import 'package:worldcountriesquiz/screens/ContentScreen.dart';

class HomeScreen extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
        return MaterialApp(
			home: Home()
		);
	}
}

class HomeState extends State<Home> {
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
                    padding: EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    child: TextButton(
                                        onPressed: () => {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ContentScreen()
                                                )
                                            )
                                        },
                                        child: Text(
                                            'Play',
                                            style: TextStyle(
                                                fontSize: 70,
                                                color: Color(0xFF0FBEBE)
                                            )
                                        )
                                    )
                                )
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                            width: (MediaQuery.of(context).size.width - 40) / 2 - 30,
                                            height: 100,
                                            child: TextButton(
                                                onPressed: () => {},
                                                child: Center(
                                                    child: Icon(
                                                        Icons.soap,
                                                        color: const Color(0xFF0FBEBE),
                                                        size: 40
                                                    )
                                                )
                                            )
                                        )
                                    ),
                                    Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                            width: (MediaQuery.of(context).size.width - 40) / 2 - 30,
                                            height: 100,
                                            child: TextButton(
                                                onPressed: () => {},
                                                child: Center(
                                                    child: Icon(
                                                        Icons.alarm,
                                                        color: const Color(0xFF0FBEBE),
                                                        size: 40
                                                    )
                                                )
                                            )
                                        )
                                    )
                                ],
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

class Home extends StatefulWidget {

	@override
	State createState() => HomeState();
}