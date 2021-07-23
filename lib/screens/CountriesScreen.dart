import 'package:flutter/material.dart';
import 'package:worldcountriesquiz/Logos.dart';
import 'package:worldcountriesquiz/AdManager.dart';

class CountriesScreen extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
        return MaterialApp(
			home: Countries()
		);
	}
}

class CountriesState extends State<Countries> {
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
                    child: ListView(
                        children: [
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                    height: 100,
                                    child: Row(
                                        children: [
                                            Expanded(
                                                child: Center(
                                                    child: Text(
                                                        'Greece',
                                                        style: TextStyle(
                                                            fontSize: 30,
                                                            color: Color(0xFF0FBEBE)
                                                        )
                                                    )
                                                )
                                            ),
                                            Container(
                                                width: 140,
                                                child: Center(
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                            Card(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                ),
                                                                child: Container(
                                                                    height: 40,
                                                                    width: 80,
                                                                    decoration: new BoxDecoration(
                                                                        color: Colors.white,
                                                                        shape: BoxShape.rectangle,
                                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                                        border: Border.all(
                                                                            color:Color(0xFF0FBEBE),
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
                                                                                'Easy',
                                                                                style: TextStyle(
                                                                                    fontSize: 20,
                                                                                    color: Color(0xFF0FBEBE)
                                                                                )
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
                                                                                'Hard',
                                                                                style: TextStyle(
                                                                                    fontSize: 20,
                                                                                    color: Color(0xFF0FBEBE)
                                                                                )
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        ]
                                                    )
                                                )
                                            )
                                        ]
                                    )
                                )
                            ),
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Container(
                                    height: 100,
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.all(0)
                                        ),
                                        onPressed: () => { },
                                        child: Center(
                                            child: Text(
                                                'Greece',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Color(0xFF0FBEBE)
                                                )
                                            )
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

class Countries extends StatefulWidget {

	@override
	State createState() => CountriesState();
}