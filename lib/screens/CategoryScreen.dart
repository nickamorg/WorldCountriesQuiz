import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:worldcountriesquiz/screens/LogoScreen.dart';
import 'package:worldcountriesquiz/Logos.dart';
import 'package:worldcountriesquiz/AdManager.dart';

class CategoryScreen extends StatelessWidget {
    final int catIdx;

    CategoryScreen({ Key? key, required this.catIdx}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return CategoryLogos(catIdx: catIdx);
	}
}

class CategoryState extends State<CategoryLogos> {
    int? catIdx;
    Map<Logo, int> solvedLogos = {};

    @override
	void initState() {
		super.initState();

        catIdx = widget.catIdx;
        AdManager.loadInterstitialAd();
	}

    @override
    Widget build(BuildContext context) {

        int logoIdx = 0;
        solvedLogos = {};
        LogosList.categories[catIdx!].logos.forEach((logo) { 
            if (logo.isSolved) solvedLogos[logo] = logoIdx;
            logoIdx++;
        });

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
                                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                            height: 35,
                                            child: Row(
                                                children: [
                                                    Icon(
                                                        Icons.arrow_back,
                                                        color: const Color(0xffce17ac),
                                                        size: 20
                                                    ),
                                                    SizedBox(
                                                        width: 10
                                                    ),
                                                    Text(
                                                        'Categories',
                                                        style: TextStyle(
                                                            fontFamily: 'Segoe UI',
                                                            fontSize: 20,
                                                            color: const Color(0xffce17ac),
                                                            fontWeight: FontWeight.w700,
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
                                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                        height: 35,
                                        child: Row(
                                            children: [
                                                SizedBox(
                                                    width: 20,
                                                    child: Image(image: AssetImage('assets/hint.png'), fit: BoxFit.contain)
                                                ),
                                                SizedBox(
                                                    width: 10
                                                ),
                                                Text(
                                                    hints.toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Segoe UI',
                                                        fontSize: 20,
                                                        color: Color(0xFFFFD517),
                                                        fontWeight: FontWeight.w700,
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
                            child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                ),
                                shrinkWrap: true,
                                itemCount: solvedLogos.length,
                                itemBuilder: (BuildContext context, int index) {
                                    Logo logo = solvedLogos.keys.elementAt(index);
                                    
                                    return Card(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(width: 0, style: BorderStyle.none),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        margin: const EdgeInsets.all(15),
                                        color: Colors.white,
                                        child: TextButton(
                                            onPressed: () => {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => LogoScreen(catIdx: catIdx!, logoIdx: solvedLogos.values.elementAt(index))
                                                    )
                                                ).then((value) => setState(() { }))
                                            },
                                            child: SizedBox(
                                                height: 130,
                                                width: 130,
                                                child: Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: SvgPicture.asset('assets/logos/' + LogosList.categories[catIdx!].title + '/' + logo.title + '.svg', fit: BoxFit.scaleDown)
                                                )
                                            )
                                        )
                                    );
                                })
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0)
                                ),
                                onPressed: () {
                                    AdManager.showInterstitialAd();

                                    Future.delayed(const Duration(milliseconds: 1000), () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LogoScreen(catIdx: catIdx!, logoIdx: -1)
                                            )
                                        ).then((value) => setState(() { }));
                                    });
                                },
                                child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Text(
                                        LogosList.categories[catIdx!].getTotalSolvedLogos() < LogosList.categories[catIdx!].logos.length
                                        ? 'Explore more logos' : 'Replay all logos',
                                        style: TextStyle(
                                            fontFamily: 'Segoe UI',
                                            fontSize: 20,
                                            color: const Color(0xFF6B246F),
                                            fontWeight: FontWeight.w700
                                        )
                                    ),
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(Radius.circular(30))
                                    )
                                )
                            )
                        )
                    ]
                )
            )
        );
    }
}

class CategoryLogos extends StatefulWidget {
    final int catIdx;

    CategoryLogos({ Key? key, required this.catIdx }) : super(key: key);
    
	@override
	State createState() => CategoryState();
}