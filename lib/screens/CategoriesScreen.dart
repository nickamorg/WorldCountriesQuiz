import 'package:flutter/material.dart';
import 'package:worldcountriesquiz/screens/CategoryScreen.dart';
import 'package:worldcountriesquiz/screens/LogoScreen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:worldcountriesquiz/Logos.dart';
import 'package:worldcountriesquiz/AdManager.dart';

class CategoriesScreen extends StatelessWidget {

    CategoriesScreen({ Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return CategoriesCat();
	}
}

class CategoriesState extends State<CategoriesCat> {
    int? catIdx;

    @override
	void initState() {
		super.initState();

        AdManager.loadInterstitialAd();
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.all(0)
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                            height: 35,
                                            child: Row(
                                                children: [
                                                    Icon(
                                                        Icons.arrow_back,
                                                        color: Color(0xffce17ac),
                                                        size: 20,
                                                    ),
                                                    SizedBox( width: 10 ),
                                                    Text(
                                                        'Home',
                                                        style: TextStyle(
                                                            fontFamily: 'Segoe UI',
                                                            fontSize: 20,
                                                            color: Color(0xffce17ac),
                                                            fontWeight: FontWeight.w700
                                                        ),
                                                        textAlign: TextAlign.center
                                                    )
                                                ]
                                            ),
                                            decoration: new BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(Radius.circular(30))
                                            )
                                        )
                                    ),
                                    Container(
                                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                        height: 35,
                                        child: Row(
                                            children: [
                                                SizedBox(
                                                    width: 20,
                                                    child: Image(image: AssetImage('assets/hint.png'), fit: BoxFit.contain)
                                                ),
                                                SizedBox( width: 10 ),
                                                Text(
                                                    hints.toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Segoe UI',
                                                        fontSize: 20,
                                                        color: Color(0xFFFFD517),
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                    textAlign: TextAlign.center
                                                )
                                            ]
                                        ),
                                        decoration: new BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(Radius.circular(30))
                                        )
                                    )
                                ]
                            )
                        ),
                        Expanded(
                            child: ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (BuildContext context, int index) {
                                    return SizedBox( height: 0 );
                                },
                                itemCount: LogosList.categories.length,
                                itemBuilder: (BuildContext context, int index) {
                                    Category cat = LogosList.categories[index];

                                    return Card(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(width: 0, style: BorderStyle.none),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        margin: EdgeInsets.all(15),
                                        color: Colors.white,
                                        child: TextButton(
                                            onPressed: () {
                                                if (cat.getTotalSolvedLogos() == 0) {
                                                    AdManager.showInterstitialAd();

                                                    Future.delayed(const Duration(milliseconds: 1000), () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => LogoScreen(catIdx: index, logoIdx: -1)
                                                            )
                                                        ).then((value) => setState(() { }));
                                                    });
                                                } else {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => CategoryScreen(catIdx: index)
                                                        )
                                                    ).then((value) => setState(() { }));
                                                }
                                            },
                                            child: SizedBox(
                                                height: 100,
                                                width: MediaQuery.of(context).size.width,
                                                child: Padding(
                                                    padding: EdgeInsets.all(20),
                                                    child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                            Padding(
                                                                padding: EdgeInsets.only(right: 20),
                                                                child: SizedBox(
                                                                    width: 50,
                                                                    child: Image(image: AssetImage('assets/categories/' + LogosList.categories[index].title + '.png'), fit: BoxFit.contain)
                                                                )
                                                            ),
                                                            Expanded(
                                                                child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                        Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                                Text(
                                                                                    cat.title,
                                                                                    style: TextStyle(
                                                                                        fontFamily: 'Segoe UI',
                                                                                        fontSize: 20,
                                                                                        color: Color(0xff6b246f),
                                                                                        fontWeight: FontWeight.w700
                                                                                    )
                                                                                ),
                                                                                Text(
                                                                                    cat.getTotalSolvedLogos().toString() + '/' + cat.logos.length.toString(),
                                                                                    style: TextStyle(
                                                                                        fontFamily: 'Segoe UI',
                                                                                        fontSize: 20,
                                                                                        color: Color(0xff6b246f),
                                                                                        fontWeight: FontWeight.w700
                                                                                    )
                                                                                )
                                                                            ]
                                                                        ),
                                                                        LinearPercentIndicator(
                                                                            animation: true,
                                                                            lineHeight: 20,
                                                                            animationDuration: 2000,
                                                                            percent: cat.getTotalSolvedLogos() / cat.logos.length,
                                                                            center: Text((cat.getTotalSolvedLogos() / cat.logos.length * 100).toInt().toString() + '%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                                                            linearStrokeCap: LinearStrokeCap.roundAll,
                                                                            progressColor: Color(0xFFDD49C1),
                                                                            backgroundColor: Color(0xFF5A2965)
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                        ]
                                                    )
                                                )
                                            )
                                        )
                                    );
                                }
                            )
                        )
                    ]
                )
            )
        );
    }
}

class CategoriesCat extends StatefulWidget {

    CategoriesCat({ Key? key }) : super(key: key);
    
	@override
	State createState() => CategoriesState();
}