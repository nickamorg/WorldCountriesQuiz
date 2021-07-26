import 'package:flutter/material.dart';
import 'package:worldcountriesquiz/Countries.dart';
import 'package:worldcountriesquiz/AdManager.dart';
import 'package:worldcountriesquiz/screens/CountriesScreen.dart';

class HomeScreen extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
        return MaterialApp(
			home: Home()
		);
	}
}

class HomeState extends State<Home> {

    @override
    void initState() {
        super.initState();

        CountriesList.init().then((value) => CountriesList.loadDataStorage());

        // AdManager.initGoogleMobileAds();
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
                        fit: BoxFit.cover
                    )
                ),
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    child: TextButton(
                                        onPressed: () => {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => CountriesScreen()
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
                                            borderRadius: BorderRadius.circular(15)
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
                                            borderRadius: BorderRadius.circular(15)
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

class Home extends StatefulWidget {

	@override
	State createState() => HomeState();
}