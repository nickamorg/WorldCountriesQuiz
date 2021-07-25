import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    double population = 0;
    int populationRange = 0;
    List<String> flags = [];
    Set<String> colors = {'Black', 'Blue', 'Green', 'Red', 'White', 'Yellow'};
    List<String> flagColors = [];
    List<String> isoLetters = [];

    int currQuizIdx = 0;
    int totalModes = 7;
    int selectedCapitalIdx = -1;
    int selectedContinentIdx = -1;
    int selectedShapeIdx = -1;
    int selectedPersonIdx = -1;
    bool isPopulationSubmitted = false;
    bool isPopulationCorrect = false;
    double multiplier = 1;
    int selectedFlagIdx = -1;
    Set<String> selectedMarkers = {};
    int minColors = 2;
    bool areColorsSubmitted = false;
    bool areColorsCorrect = false;
    int isoChar1 = 0;
    int isoChar2 = 0;
    bool isIsoSubmitted = false;
    bool isIsoCorrect = true;

    Country? country;
    GameQuiz? currQuiz;
    Set<GameQuiz> quizList = { GameQuiz.ISO, GameQuiz.COLORS, GameQuiz.FLAG, GameQuiz.POPULATION, GameQuiz.CAPITAL, GameQuiz.CONTINENT, GameQuiz.SHAPE };

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

        totalModes = quizList.length;
        currQuiz = quizList.elementAt(0);

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
                                                    child: Image(
                                                        image: AssetImage('assets/hint.png'), fit: BoxFit.contain)
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
                            SizedBox(height: 20),
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
                            SizedBox(height: 20),
                            getCurrentModeCard(),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: getCurrentModeAnswers()
                                )
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
            case GameQuiz.POPULATION: {
                initModePopulation();
                break;
            }
            case GameQuiz.FLAG: {
                initModeFlag();
                break;
            }
            case GameQuiz.COLORS: {
                initModeColors();
                break;
            }
            case GameQuiz.ISO: {
                initModeIso();
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

    initModePopulation() {
        int x2 = 2;
        double multiplierIterate = 500000000; // 500.000.000
        int divider = 1000000000; // 1.000.000.000
        int min = 1000000000; // 1.000.000.000

        do {
            if (country!.population > min) { 
                population = x2 * country!.population / divider;
                multiplier = multiplierIterate;
                break;
            } else {
                if (x2 == 2) {
                    x2 = 1;
                    multiplierIterate /= 5;
                    divider ~/= 10;
                    min ~/= 2;
                } else {
                    x2 = 2;
                    multiplierIterate /= 2;
                    min ~/= 5;
                }
            }
        } while (true); 

        populationRange = population.round() + 1 + Random().nextInt(4);

        setState(() { });
    }

    initModeFlag() {
        Set<String> flagsSet = {};

        flagsSet.add(country!.continent + '/' + country!.title);

        do {
            int countryIdx = Random().nextInt(CountriesList.countries.length);

            flagsSet.add(CountriesList.countries[countryIdx].continent + '/' + CountriesList.countries[countryIdx].title);
        } while (flagsSet.length < 4);

        flags = flagsSet.toList();
        flags.shuffle();

        setState(() { });
    }
    
    initModeColors() {
        flagColors = country!.colors;
        
        if (flagColors.length <= 2) {
            minColors = flagColors.length;
        } else {
            minColors = 2 + Random().nextInt(flagColors.length - 1);
        }
        setState(() { });
    }

    initModeIso() {
        for (int i = 65; i <= 90; i++) {
            isoLetters.add(String.fromCharCode(i));
        }

        setState(() { });
    }

    Card getCurrentModeCard() {
        switch(currQuiz!) {
            case GameQuiz.CAPITAL: return getModeCapitalCard();
            case GameQuiz.CONTINENT: return getModeContinentCard();
            case GameQuiz.SHAPE: return getModeShapeCard();
            case GameQuiz.POPULATION: return getModePopulationCard();
            case GameQuiz.FLAG: return getModeFlagCard();
            case GameQuiz.COLORS: return getModeColorsCard();
            case GameQuiz.ISO: return getModeIsoCard();
        }
    }

    Widget getCurrentModeAnswers() {
        switch(currQuiz!) {
            case GameQuiz.CAPITAL: return getModeCapitalAnswers();
            case GameQuiz.CONTINENT: return getModeContinentAnswers();
            case GameQuiz.SHAPE: return getModeShapeAnswers();
            case GameQuiz.POPULATION: return getModePopulationAnswers();
            case GameQuiz.FLAG: return getModeFlagAnswers();
            case GameQuiz.COLORS: return getModeColorsAnswers();
            case GameQuiz.ISO: return getModeIsoAnswers();
        }
    }

    Card getModeCapitalCard() {
        return getModeCard('What is the Capital of $countryTitle?');
    }

    Card getModeContinentCard() {
        return getModeCard('What Continent is $countryTitle In?');
    }

    Card getModeShapeCard() {
        return getModeCard('Which is $countryTitle?');
    }

    Card getModePopulationCard() {
        return getModeCard('What is the approximate population of $countryTitle?');
    }

    Card getModeFlagCard() {
        return getModeCard('What is the flag of $countryTitle?');
    }

    Card getModeColorsCard() {
        return getModeCard('Select $minColors colors of $countryTitle\'s flag.');
    }

    Card getModeIsoCard() {
        return getModeCard('What is the ISO code of $countryTitle?');
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
                            color: Color(0xFF0FBEBE)
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
                childAspectRatio: 1
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: shapes.length,
            itemBuilder: (BuildContext context, int index) {
                return TextButton(
                    onPressed: selectedShapeIdx != -1 ? null : () { 
                        verifyShape(index);
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        backgroundColor: selectedShapeIdx != - 1 && selectedShapeIdx == index ? shapes[selectedShapeIdx].contains(country!.title) ? Colors.green : Colors.red : Colors.transparent
                    ),
                    child: SizedBox(
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Image(
                                image: AssetImage('assets/shapes/' + shapes[index] + '.png')
                            )
                        )
                    )
                );
            }
        );
    }

    Column getModePopulationAnswers() {
        List<Widget> population = [];

        for (int i = 0; i < populationRange; i++) {
            population.add(
                TextButton(
                    onPressed: isPopulationSubmitted ? null : () {
                        setState(() {
                            selectedPersonIdx = i;
                        });
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0)
                    ),
                    child: SvgPicture.asset(
                        i <= selectedPersonIdx ? 'assets/person_full.svg' : 'assets/person_empty.svg',
                        height: 100
                    )
                )
            );
        }
        return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Container(
                            height: 50,
                            width: 50,
                            child: TextButton(
                                onPressed: isPopulationSubmitted || selectedPersonIdx + 1 <= 0 ? null : () {
                                    setState(() {
                                        selectedPersonIdx -= 1;
                                    });
                                },
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0)
                                ),
                                child: Icon(
                                    Icons.remove,
                                    color: Color(0xFF0FBEBE),
                                    size: 40
                                )
                            ),
                            decoration: BoxDecoration(
                                color:  Colors.white,
                                shape: BoxShape.circle
                            )
                        ),
                        Container(
                            height: 50,
                            width: 200,
                            child: TextButton(
                                onPressed: isPopulationSubmitted ? null : verifyPopulation,
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0)
                                ),
                                child: Center(
                                    child: Text(
                                        '${trim0Trailing((selectedPersonIdx + 1) * multiplier)}',
                                        style: TextStyle(
                                            fontFamily: 'Segoe UI',
                                            fontSize: 20,
                                            color: isPopulationSubmitted ? Colors.white : Color(0xFF0FBEBE),
                                            fontWeight: FontWeight.w700
                                        )
                                    )
                                )
                            ),
                            decoration: BoxDecoration(
                                color:  isPopulationSubmitted ? isPopulationCorrect ? Colors.green : Colors.red : Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(30))
                            )
                        ),
                        Container(
                            height: 50,
                            width: 50,
                            child: TextButton(
                                onPressed: isPopulationSubmitted || selectedPersonIdx + 1 >= populationRange ? null : () {
                                    setState(() {
                                        selectedPersonIdx += 1;
                                    });
                                },
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0)
                                ),
                                child: Icon(
                                    Icons.add,
                                    color: Color(0xFF0FBEBE),
                                    size: 40
                                )
                            ),
                            decoration: BoxDecoration(
                                color:  Colors.white,
                                shape: BoxShape.circle
                            )
                        )
                    ]
                ),
                Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: population
                        )
                    )
                )
            ]
        );
    }

    GridView getModeFlagAnswers() {
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: flags.length,
            itemBuilder: (BuildContext context, int index) {
                return TextButton(
                    onPressed: selectedFlagIdx != -1 ? null : () { 
                        verifyFlag(index);
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        backgroundColor: selectedFlagIdx != - 1 && selectedFlagIdx == index ? flags[selectedFlagIdx].contains(country!.title) ? Colors.green : Colors.red : Colors.transparent
                    ),
                    child: SizedBox(
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Image(
                                image: AssetImage('assets/flags/' + flags[index] + '.png')
                            )
                        )
                    )
                );
            }
        );
    }

    Column getModeColorsAnswers() {
        List<Widget> colorMarkers = [];

        for (int i = 0; i < colors.length; i++) {
            colorMarkers.add(
                AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: selectedMarkers.contains(colors.elementAt(i)) ? 1 : 0.5,
                    child: TextButton(
                        onPressed: isPopulationSubmitted ? null : () {
                            setState(() {
                                if (selectedMarkers.contains(colors.elementAt(i))) {
                                    selectedMarkers.remove(colors.elementAt(i));
                                } else {
                                    selectedMarkers.add(colors.elementAt(i));

                                    if (selectedMarkers.length == minColors) {
                                        verifyColors();
                                    }
                                }
                            });
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0),
                            backgroundColor: areColorsSubmitted && selectedMarkers.contains(colors.elementAt(i)) ? flagColors.contains(colors.elementAt(i)) ? Colors.green : Colors.red : Colors.transparent 
                        ),
                        child: SvgPicture.asset(
                            'assets/markers/${colors.elementAt(i)}.svg',
                            height: selectedMarkers.contains(colors.elementAt(i)) ? 120 : 100
                        )
                    )
                )
            );
        }

        return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
                Stack(
                    children: [
                        Image(image: AssetImage('assets/flags/' + country!.continent + '/' + country!.title + '.png')),
                        AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity: areColorsSubmitted ? 0 : 0.92,
                            child: Image(
                                image: AssetImage('assets/flags/' + country!.continent + '/' + country!.title + '.png'),
                                color: Colors.black
                            )
                        )
                    ]
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: colorMarkers
                    )
                )
            ]
        );
    }

    Column getModeIsoAnswers() {
        List<Widget> answers = [];

        for (int i = 0; i < isoLetters.length; i++) {
            answers.add(
                Text(
                    isoLetters[i],
                    style: TextStyle(
                        fontSize: 30,
                        color: isIsoSubmitted ? Colors.white : Color(0xFF0FBEBE)
                    )
                )
            );
        }

        return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                        ),
                        child: TextButton(
                            onPressed: isIsoSubmitted ? null : verifyIso,
                            child: Icon(
                                Icons.check,
                                color: Color(0xFF0FBEBE),
                                size: 40
                            )
                        )
                    )
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            color: isIsoSubmitted ? isoLetters[isoChar1] == country!.iso[0] ? Colors.green : Colors.red : Colors.white,
                            child: Container(
                                height: 100,
                                width: 50,
                                child: ListWheelScrollView.useDelegate(
                                    physics: isIsoSubmitted ? NeverScrollableScrollPhysics() : FixedExtentScrollPhysics(),
                                    perspective: 0.01,
                                    itemExtent: 50,
                                    childDelegate: ListWheelChildLoopingListDelegate(
                                        children: answers
                                    ),
                                    onSelectedItemChanged: (index) => isoChar1 = index
                                )
                            )
                        ),
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            color: isIsoSubmitted ? isoLetters[isoChar2] == country!.iso[1] ? Colors.green : Colors.red : Colors.white,
                            child: Container(
                                height: 100,
                                width: 50,
                                child: ListWheelScrollView.useDelegate(
                                    physics: isIsoSubmitted ? NeverScrollableScrollPhysics() : FixedExtentScrollPhysics(),
                                    perspective: 0.01,
                                    itemExtent: 50,
                                    childDelegate: ListWheelChildLoopingListDelegate(
                                        children: answers
                                    ),
                                    onSelectedItemChanged: (index) => isoChar2 = index
                                )
                            )
                        )
                    ]
                )
            ]
        );
    }

    String trim0Trailing(double num) {
        String txt = num.toString();

        txt = num.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");

        String newTxt = '';
        txt = txt.split('').reversed.join('');

        if (txt.length > 3) {
            for ( int i = 0; i < txt.length; i = i + 3) {
                if (i + 4 > txt.length) {
                    newTxt += txt.substring(i);
                    break;
                }
                newTxt += txt.substring(i, i + 3) + '.';
            }
        } else {
            newTxt = txt;
        }

        return newTxt.split('').reversed.join('');
    }

    void verifyCapital(int idx) {
        selectedCapitalIdx = idx;

        if (country!.capital == capitals[idx]) {
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

        if (country!.continent == continents[idx]) {
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

        if (shapes[idx].contains(country!.title)) {
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

    void verifyPopulation() {
        isPopulationSubmitted = true;

        if (selectedPersonIdx + 1 == population.round()) {
            AudioPlayer.play(AudioList.CORRECT_ANSWER);
            isPopulationCorrect = true;
            currQuizIdx++;

            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 500), () {
                    currQuiz = quizList.elementAt(currQuizIdx);
                    initMode();
                });
            }
        } else {
            AudioPlayer.play(AudioList.WRONG_ANSWER);
            isPopulationCorrect = false;

            Future.delayed(Duration(milliseconds: 1000), () {
                Navigator.of(context).pop(true);
            });
        }

        setState(() { });
    }

    void verifyFlag(int idx) {
        selectedFlagIdx = idx;

        if (flags[idx].contains(country!.title)) {
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

    void verifyColors() {
        areColorsSubmitted = true;

        if (selectedMarkers.every((marker) => flagColors.contains(marker))) {
            AudioPlayer.play(AudioList.CORRECT_ANSWER);
            areColorsCorrect = true;
            currQuizIdx++;

            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 1000), () {
                    currQuiz = quizList.elementAt(currQuizIdx);
                    initMode();
                });
            }
        } else {
            AudioPlayer.play(AudioList.WRONG_ANSWER);
            areColorsCorrect = false;

            Future.delayed(Duration(milliseconds: 1000), () {
                Navigator.of(context).pop(true);
            });
        }

        setState(() { });
    }

    void verifyIso() {
        isIsoSubmitted = true;

        if (isoLetters[isoChar1] + isoLetters[isoChar2] == country!.iso) {
            AudioPlayer.play(AudioList.CORRECT_ANSWER);
            isIsoCorrect = true;
            currQuizIdx++;

            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 1000), () {
                    currQuiz = quizList.elementAt(currQuizIdx);
                    initMode();
                });
            }
        } else {
            AudioPlayer.play(AudioList.WRONG_ANSWER);
            isIsoCorrect = false;

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
                    )
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