import 'package:flutter/material.dart';
import 'package:worldcountriesquiz/Logos.dart';
import 'package:worldcountriesquiz/screens/CategoriesScreen.dart';
import 'package:worldcountriesquiz/AudioPlayer.dart';
import 'package:worldcountriesquiz/AdManager.dart';

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
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                            Color(0xFF512D60),
                            Color(0xFFCA08A6),
                            Color(0xFFF69CE4)
                        ]
                    )
                ),
                child: Stack(
                    children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            letter('L'),
                                            letter('O'),
                                            letter('G'),
                                            letter('O')
                                        ]
                                    )
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Container(
                                        height: 30,
                                        width: 175,
                                        child: Text(
                                            'Quiz',
                                            style: TextStyle(
                                                fontFamily: 'Segoe UI',
                                                fontSize: 25,
                                                color: const Color(0xffce17ac),
                                                fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.center,
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
                                ),
                                Expanded(
                                    child: Container(
                                        height: 300,
                                        width: 300,
                                        alignment: Alignment.center,
                                        child: TextButton(
                                            onPressed: () => {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => CategoriesScreen()
                                                    )
                                                )
                                            },
                                            child: Container(
                                                height: 200,
                                                width: 200,
                                                child: Center(
                                                    child: Text(
                                                        'Play',
                                                        style: TextStyle(
                                                            fontFamily: 'Segoe UI',
                                                            fontSize: 50,
                                                            color: const Color(0xffce17ac),
                                                            fontWeight: FontWeight.w700
                                                        )
                                                    )
                                                ),
                                                decoration: new BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle
                                                )
                                            )
                                        ),
                                        decoration: new BoxDecoration(
                                            border: Border.all(width: 5, color: Colors.white),
                                            shape: BoxShape.circle
                                        )
                                    )
                                )
                            ]
                        ),
                        Positioned(
                            left: 20,
                            bottom: 20,
                            child: SizedBox(
                                width: 40,
                                height: 40,
                                child: MaterialButton(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(AudioPlayer.isAudioEnabled ? Icons.volume_up : Icons.volume_off, color: Color(0xFFCE17AC), size: 25),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    onPressed: () => {
                                        setState(() {
                                            AudioPlayer.isAudioEnabled = !AudioPlayer.isAudioEnabled;
                                        })
                                    },
                                    enableFeedback: !AudioPlayer.isAudioEnabled,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent
                                )
                            )
                        )
                    ]
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