import 'package:flutter/material.dart';
import 'package:worldcountriesquiz/screens/CountriesScreen.dart';
import 'package:worldcountriesquiz/screens/ContinentsScreen.dart';

class ContentScreen extends StatelessWidget {

    ContentScreen({ Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
        return Content();
	}
}

class ContentState extends State<Content> {

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
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
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
                                                        fontSize: 35,
                                                        color: Color(0xFF0FBEBE)
                                                    )
                                                ),
                                                Text(
                                                    'Countries',
                                                    style: TextStyle(
                                                        fontSize: 35,
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
                                    borderRadius: BorderRadius.circular(15)
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
                                                        fontSize: 35,
                                                        color: Color(0xFF0FBEBE)
                                                    )
                                                ),
                                                Text(
                                                    'Countries',
                                                    style: TextStyle(
                                                        fontSize: 35,
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

class Content extends StatefulWidget {

	@override
	State createState() => ContentState();
}