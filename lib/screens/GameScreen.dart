import 'dart:math';

import 'package:flutter/material.dart';
import 'package:worldcountriesquiz/AudioPlayer.dart';
import 'package:worldcountriesquiz/Countries.dart';
import 'package:worldcountriesquiz/library.dart';

class GameScreen extends StatelessWidget {
    final String countryTitle;
    final GameMode gameMode;
    
    GameScreen({ Key? key, required this.countryTitle, required this.gameMode}) : super(key: key);

	@override
	Widget build(BuildContext context) {
        return Game(countryTitle: countryTitle, gameMode: gameMode);
	}
}

class GameState extends State<Game> with TickerProviderStateMixin {
    String countryTitle = ' ';
    GameMode gameMode = GameMode.EASY;
    List<Country> countriesList = [];

    AnimationController? hintsController;
    Animation<double>? hintsAnimation;

    ScrollController scrollController = new ScrollController(
        initialScrollOffset: 0.0,
        keepScrollOffset: true,
    );

    List<String> capitals = [];
    List<String> continents = [];
    List<String> shapes = [];

    int currQuizIdx = 0;
    int totalModes = 3;
    int selectedCapitalIdx = -1;
    int selectedContinentIdx = -1;
    int selectedShapeIdx = -1;
    Country? country;
    GameQuiz? currQuiz;
    Set<GameQuiz> quizList = {GameQuiz.CAPITAL, GameQuiz.CONTINENT, GameQuiz.SHAPE};

    @override
	void initState() {
		super.initState();

        hintsController = new AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 1500)
        );

        hintsAnimation = new Tween<double>(
            begin: hints.toDouble(),
            end: hints.toDouble(),
        ).animate(new CurvedAnimation(
            curve: Curves.fastOutSlowIn,
            parent: hintsController!
        ));

        countryTitle = widget.countryTitle;
        country = CountriesList.getCountryByTitle(countryTitle);
        gameMode = widget.gameMode;
        countriesList = CountriesList.countries.where((country) => country.continent == countryTitle).toList();
    
        currQuiz = GameQuiz.CAPITAL;

        initMode();
    }

	@override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF0FBEBE),
                    image: DecorationImage(
                        image: AssetImage('assets/countries/' + country!.continent + '/' + country!.title + '.png'),
                        colorFilter: ColorFilter.linearToSrgbGamma(),
                        fit: BoxFit.cover
                    )
                ),
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Row(
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
                                            child: Icon(
                                                Icons.arrow_back,
                                                color: Color(0xFF0FBEBE),
                                                size: 20,
                                            ),
                                            decoration: BoxDecoration(
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
                                                SizedBox(
                                                    width: 10
                                                ),
                                                AnimatedBuilder(
                                                    animation: hintsAnimation!,
                                                    builder: (BuildContext context, Widget? child) {
                                                        return Text(
                                                            hintsAnimation!.value.toInt().toString(),
                                                            style: TextStyle(
                                                                fontFamily: 'Segoe UI',
                                                                fontSize: 20,
                                                                color: Color(0xFFFFD517),
                                                                fontWeight: FontWeight.w700
                                                            )
                                                        );
                                                    }
                                                )
                                            ]
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(Radius.circular(30))
                                        )
                                    )
                                ]
                            ),
                            SizedBox(height: 30),
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Container(
                                    height: 100,
                                    child: Column(
                                        children: [
                                            Container(
                                                height: 70,
                                                child: Center(
                                                    child: Text(
                                                        countryTitle,
                                                        style: TextStyle(
                                                            fontSize: 30,
                                                            color: Color(0xFF0FBEBE),
                                                            fontWeight: FontWeight.bold
                                                        )
                                                    )
                                                )
                                            ),
                                            ModesTracking(currQuizIdx: currQuizIdx, totalModes: totalModes)
                                        ]
                                    )
                                )
                            ),
                            SizedBox(height: 60),
                            getCurrentModeCard(),
                            Expanded(
                                child: getCurrentModeAnswers()
                            )
                        ]
                    )
                )
            )
        );
    }

    initMode() {
        switch(quizList.elementAt(currQuizIdx)) {
            case GameQuiz.CAPITAL: {
                initModeCapital();
                break;
            }
            case GameQuiz.CONTINENT: {
                initModeContinent();
                break;
            }
            case GameQuiz.SHAPE: {
                initModeShape();
                break;
            }
        }
    }

    initModeCapital() {
        Set<String> capitalsSet = {};

        capitalsSet.add(country!.capital);

        do {
            int countryIdx = Random().nextInt(CountriesList.countries.length);

            capitalsSet.add(CountriesList.countries[countryIdx].capital);
        } while (capitalsSet.length < 4);

        capitals = capitalsSet.toList();
        capitals.shuffle();

        setState(() { });
    }

    initModeContinent() {
        Set<String> continentsSet = {};

        continentsSet.add(country!.continent);

        do {
            int countryIdx = Random().nextInt(CountriesList.countries.length);

            continentsSet.add(CountriesList.countries[countryIdx].continent);
        } while (continentsSet.length < 4);

        continents = continentsSet.toList();
        continents.shuffle();

        setState(() { });
    }

    initModeShape() {
        Set<String> shapesSet = {};

        shapesSet.add(country!.continent + '/' + country!.title);

        do {
            int countryIdx = Random().nextInt(CountriesList.countries.length);

            shapesSet.add(CountriesList.countries[countryIdx].continent + '/' + CountriesList.countries[countryIdx].title);
        } while (shapesSet.length < 4);

        shapes = shapesSet.toList();
        shapes.shuffle();

        setState(() { });
    }

    Card getCurrentModeCard() {
        switch(currQuiz!) {
            case GameQuiz.CAPITAL: return getModeCapitalCard();
            case GameQuiz.CONTINENT: return getModeContinentCard();
            case GameQuiz.SHAPE: return getModeShapeCard();
        }
    }

    Widget getCurrentModeAnswers() {
        switch(currQuiz!) {
            case GameQuiz.CAPITAL: return getModeCapitalAnswers();
            case GameQuiz.CONTINENT: return getModeContinentAnswers();
            case GameQuiz.SHAPE: return getModeShapeAnswers();
        }
    }

    Card getModeCapitalCard() {
        return getModeCard( 'What is the Capital of $countryTitle?');
    }

    Card getModeContinentCard() {
        return getModeCard( 'What Continent is $countryTitle In?');
    }

    Card getModeShapeCard() {
        return getModeCard( 'Which is $countryTitle?');
    }

    Card getModeCard(String txt) {
        return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                    child: Text(
                        txt,
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF0FBEBE),
                        )
                    )
                )
            )
        );
    }

    Column getModeCapitalAnswers() {
        List<Widget> answers = [];

        for (int i = 0; i < capitals.length; i++) {
            answers.add(
                Padding(
                    padding: EdgeInsets.only(bottom: i + 1 < capitals.length ? 20 : 0),
                    child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: TextButton(
                            onPressed: selectedCapitalIdx != -1 ? null : () { 
                                verifyCapital(i);
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.all(0)
                            ),
                            child: Center(
                                child: Text(
                                    capitals.elementAt(i),
                                    style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 20,
                                        color: selectedCapitalIdx == - 1 || selectedCapitalIdx != i ? Color(0xFF0FBEBE) : Colors.white,
                                        fontWeight: FontWeight.w700
                                    )
                                )
                            )
                        ),
                        decoration: BoxDecoration(
                            color: selectedCapitalIdx == - 1 || selectedCapitalIdx != i ? Colors.white : capitals[selectedCapitalIdx] == country!.capital ? Colors.green : Colors.red,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        )
                    )
                )
            );
        }

        return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: answers
        );
    }

    Column getModeContinentAnswers() {
        List<Widget> answers = [];

        for (int i = 0; i < continents.length; i++) {
            answers.add(
                Padding(
                    padding: EdgeInsets.only(bottom: i + 1 < continents.length ? 20 : 0),
                    child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: TextButton(
                            onPressed: selectedContinentIdx != -1 ? null : () { 
                                verifyContinent(i);
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.all(0)
                            ),
                            child: Center(
                                child: Text(
                                    continents.elementAt(i),
                                    style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 20,
                                        color: selectedContinentIdx == - 1 || selectedContinentIdx != i ? Color(0xFF0FBEBE) : Colors.white,
                                        fontWeight: FontWeight.w700
                                    )
                                )
                            )
                        ),
                        decoration: BoxDecoration(
                            color: selectedContinentIdx == - 1 || selectedContinentIdx != i ? Colors.white : continents[selectedContinentIdx] == country!.continent ? Colors.green : Colors.red,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        )
                    )
                )
            );
        }

        return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: answers
        );
    }

    GridView getModeShapeAnswers() {
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
            ),
            shrinkWrap: true,
            itemCount: shapes.length,
            itemBuilder: (BuildContext context, int index) {
                return TextButton(
                    onPressed: selectedShapeIdx != -1 ? null : () { 
                        verifyShape(index);
                    },
                    child: SizedBox(
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Image(image: AssetImage('assets/shapes/' + shapes[index] + '.png'))
                        )
                    )
                );
            }
        );
    }

    void verifyCapital(int idx) {
        selectedCapitalIdx = idx;

        if(country!.capital == capitals[idx]) {
            AudioPlayer.play(AudioList.CORRECT_ANSWER);
            currQuizIdx++;

            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 500), () {
                    currQuiz = quizList.elementAt(currQuizIdx);
                    initMode();
                });
            }
        } else {
            AudioPlayer.play(AudioList.WRONG_ANSWER);

            Future.delayed(Duration(milliseconds: 1000), () {
                Navigator.of(context).pop(true);
            });
        }

        setState(() { });
    }

    void verifyContinent(int idx) {
        selectedContinentIdx = idx;

        if(country!.continent == continents[idx]) {
            AudioPlayer.play(AudioList.CORRECT_ANSWER);
            currQuizIdx++;

            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 500), () {
                    currQuiz = quizList.elementAt(currQuizIdx);
                    initMode();
                });
            }
        } else {
            AudioPlayer.play(AudioList.WRONG_ANSWER);

            Future.delayed(Duration(milliseconds: 1000), () {
                Navigator.of(context).pop(true);
            });
        }

        setState(() { });
    }

    void verifyShape(int idx) {
        selectedShapeIdx = idx;

        if(shapes[idx].contains(country!.title)) {
            AudioPlayer.play(AudioList.CORRECT_ANSWER);
            currQuizIdx++;

            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 500), () {
                    currQuiz = quizList.elementAt(currQuizIdx);
                    initMode();
                });
            }
        } else {
            AudioPlayer.play(AudioList.WRONG_ANSWER);

            Future.delayed(Duration(milliseconds: 1000), () {
                Navigator.of(context).pop(true);
            });
        }

        setState(() { });
    }

}

class ModesTracking extends StatelessWidget {
    final int currQuizIdx;
    final int totalModes;
    
    ModesTracking({required this.currQuizIdx, required this.totalModes});

    @override
    Widget build(BuildContext context) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: getModes()
        );
    }

    getModes() {
        List<Widget> modesList = [];

        for (int i = 0; i < totalModes; i++) {
            modesList.add(
                Padding(
                  padding: EdgeInsets.only(right: i + 1 < totalModes ? 20 : 0),
                  child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: currQuizIdx > i ? Color(0xFF13A931) : Color(0xFFBEBEBE),
                          shape: BoxShape.circle
                      )
                  ),
                )
            );
        }

        return modesList;
    }
}

class Game extends StatefulWidget {
    final String countryTitle;
    final GameMode gameMode;

    Game({ Key? key, required this.countryTitle, required this.gameMode }) : super(key: key);

	@override
	State createState() => GameState();
}