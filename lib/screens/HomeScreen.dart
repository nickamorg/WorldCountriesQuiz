import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:worldcountriesquiz/AppTheme.dart';
import 'package:worldcountriesquiz/Countries.dart';
import 'package:worldcountriesquiz/AdManager.dart';
import 'package:worldcountriesquiz/screens/ContactScreen.dart';
import 'package:worldcountriesquiz/screens/CountriesScreen.dart';
import 'package:worldcountriesquiz/screens/StatisticsScreen.dart';
import 'package:launch_review/launch_review.dart';

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

        AdManager.initGoogleMobileAds();
    }

	@override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    color: AppTheme.MAIN_COLOR,
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
                            ButtonCard(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                cardContent: Text(
                                    'Play',
                                    style: TextStyle(
                                        fontSize: 70,
                                        color: AppTheme.MAIN_COLOR
                                    )
                                ),
                                screen: () => CountriesScreen()
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    ButtonCard(
                                        height: 100,
                                        width: MediaQuery.of(context).size.width / 2 - 40,
                                        cardContent: SvgPicture.asset(
                                            'assets/statistics.svg',
                                            height: 50
                                        ),
                                        screen: () => StatisticsScreen()
                                    ),
                                    ButtonCard(
                                        height: 100,
                                        width: MediaQuery.of(context).size.width / 2 - 40,
                                        cardContent: SvgPicture.asset(
                                            'assets/idea.svg',
                                            height: 50
                                        ),
                                        screen: () => ContactScreen()
                                    )
                                ]
                            ),
                            ButtonCard(
                                height: 60,
                                width: MediaQuery.of(context).size.width / 2,
                                cardContent: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                        Text(
                                            'Rate us',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: AppTheme.MAIN_COLOR
                                            )
                                        ),
                                        SvgPicture.asset(
                                            'assets/like.svg',
                                            height: 40
                                        )
                                    ]
                                ),
                                callback: () => LaunchReview.launch(androidAppId: "com.zirconworks.worldcountriesquiz")
                            )
                        ]
                    )
                ) 
            )
        );
    }

    Card contentCard(double height, double width, Widget displayedContent, Function screen) {
        return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child: Container(
                width: width,
                height: height,
                child: TextButton(
                    onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => screen()
                            )
                        )
                    },
                    child: Center(
                        child: displayedContent
                    )
                )
            )
        );
    }
}

class ButtonCard extends StatelessWidget {
    final double height;
    final double width;
    final Widget cardContent;
    final Function? screen;
    final Function? callback;
    
    ButtonCard({required this.height, required this.width, required this.cardContent, this.screen, this.callback});

    @override
    Widget build(BuildContext context) {
        return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child: Container(
                width: width,
                height: height,
                child: TextButton(
                    onPressed: () => {
                        screen != null ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => screen!()
                            )
                        ) : callback!()
                    },
                    child: Center(
                        child: cardContent
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