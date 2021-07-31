import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:worldcountriesquiz/AdManager.dart';
import 'package:worldcountriesquiz/AppTheme.dart';
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
    String countryTitle = '';
    GameMode gameMode = GameMode.EASY;
    List<Country> countriesList = [];

    AnimationController? hintsController;
    Animation<double>? hintsAnimation;

    ScrollController scrollController = new ScrollController(
        initialScrollOffset: 0.0,
        keepScrollOffset: true,
    );

    List<String> capitals = [];
    Set<int> hiddenCapitalsIdxs = {};
    List<String> continents = [];
    Set<int> hiddenContinentIdxs = {};
    List<String> shapes = [];
    Set<int> hiddenShapeIdxs = {};
    double population = 0;
    int populationRange = 0;
    int minPopulationIdx = -1;
    List<String> flags = [];
    List<String> flagColors = [];
    Set<String> hiddenColors = {};
    Set<int> hiddenflagIdxs = {};
    List<String> isoLetters = [];
    int isoCharLockIdx = -1;
    Set<String> hiddenReligions = {};
    List<String> languages = [];
    Set<int> hiddenLanguageIdxs = {};
    List<String> neighbors = [];
    List<String> countryNeighbors = [];
    Set<int> hiddenNeighborsIdxs = {};


    int currQuizIdx = 0;
    int totalModes = 0;
    int selectedCapitalIdx = -1;
    int selectedContinentIdx = -1;
    int selectedShapeIdx = -1;
    int selectedPersonIdx = 0;
    bool isPopulationSubmitted = false;
    bool isPopulationCorrect = false;
    double multiplier = 1;
    int selectedFlagIdx = -1;
    Set<String> selectedMarkers = {};
    int minColors = 2;
    bool areColorsSubmitted = false;
    bool areColorsCorrect = false;
    List<int> isoCharIdx = [0, 0];
    bool isIsoSubmitted = false;
    bool isIsoCorrect = true;
    String isLandlockedOrCoastal = '';
    bool isReligionSubmitted = false;
    int selectedReligionIdx = 0;
    int selectedLanguageIdx = -1;
    int minNeighbors = 2;
    Set<String> selectedNeighbors = {};
    bool areNeighborsSubmitted = false;
    bool areNeighborsCorrect = false;
    bool isHintUsed = false;

    Country? country;
    GameQuiz? currQuiz;
    List<GameQuiz> quizList = [];

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

        quizList = initQuizDifficulty();
        totalModes = quizList.length;
        currQuiz = quizList[0];

        initMode();
    }

	@override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    color: AppTheme.MAIN_COLOR,
                    image: currQuizIdx == 0 ? null : DecorationImage(
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
                                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                            height: 35,
                                            child: Icon(
                                                Icons.arrow_back,
                                                color: AppTheme.MAIN_COLOR,
                                                size: 20
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(Radius.circular(30))
                                            )
                                        )
                                    ),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.all(0)
                                        ),
                                        onPressed: () => {
                                            showHintsDialog()
                                        },
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                            height: 35,
                                            child: Row(
                                                children: [
                                                    SizedBox(
                                                        width: 20,
                                                        child: Image(
                                                            image: AssetImage('assets/hint.png'), 
                                                            fit: BoxFit.contain
                                                        )
                                                    ),
                                                    SizedBox(width: 10),
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
                                    )
                                ]
                            ),
                            SizedBox(height: 20),
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Container(
                                    height: 130,
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                        children: [
                                            Container(
                                                height: 70,
                                                width: MediaQuery.of(context).size.width,
                                                child: FittedBox(fit: BoxFit.scaleDown,
                                                    child: Text(
                                                        countryTitle,
                                                        style: TextStyle(
                                                            fontSize: 30,
                                                            color: AppTheme.MAIN_COLOR,
                                                            fontWeight: FontWeight.bold
                                                        )
                                                    )
                                                )
                                            ),
                                            FittedBox(
                                                child: ModesTracking(currQuizIdx: currQuizIdx, totalModes: totalModes),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                                getCurrentModeDescription(),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: AppTheme.MAIN_COLOR,
                                                    fontWeight: FontWeight.bold
                                                )
                                            )
                                        ]
                                    )
                                )
                            ),
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

    List<GameQuiz> initQuizDifficulty() {
        switch (gameMode) {
            case GameMode.EASY: return easyQuiz;
            case GameMode.NORMAL: return normalQuiz;
            case GameMode.HARD: return hardQuiz;
        }
    }

    initMode() {
        isHintUsed = false;

        switch (currQuiz!) {
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
            case GameQuiz.LANDLOCKED: {
                initModeLandlocked();
                break;
            }
            case GameQuiz.RELIGION: {
                initModeReligion();
                break;
            }
            case GameQuiz.LANGUAGE: {
                initModeLanguage();
                break;
            }
            case GameQuiz.NEIGHBORS: {
                initModeNeighbors();
                break;
            }
        }
    }

    initModeCapital() {
        Set<String> capitalsSet = {country!.capital};
        List<Country> sameContinentCountries = CountriesList.countries.where((currCountry) => currCountry.continent == country!.continent).toList();
        
        do {
            int countryIdx = Random().nextInt(sameContinentCountries.length);
            capitalsSet.add(sameContinentCountries[countryIdx].capital);
        } while (capitalsSet.length < 4);

        capitals = capitalsSet.toList();
        capitals.shuffle();

        setState(() { });
    }

    initModeContinent() {
        continents = List.from(CONTINENTS);
        continents.remove(country!.continent);
        continents.shuffle();
        
        continents = continents.sublist(0, 3);
        continents.add(country!.continent);
        continents.shuffle();

        setState(() { });
    }

    initModeShape() {
        Set<String> shapesSet = {(country!.continent + '/' + country!.title)};
        List<Country> sameContinentCountries = CountriesList.countries.where((currCountry) => currCountry.continent == country!.continent).toList();
        
        do {
            int countryIdx = Random().nextInt(sameContinentCountries.length);
            shapesSet.add(sameContinentCountries[countryIdx].continent + '/' + sameContinentCountries[countryIdx].title);
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

        populationRange = population.round() + 2 + Random().nextInt(4);

        setState(() { });
    }

    initModeFlag() {
        Set<String> flagsSet = {country!.continent + '/' + country!.title};
        List<Country> sameContinentCountries = CountriesList.countries.where((currCountry) => currCountry.continent == country!.continent).toList();

        do {
            int countryIdx = Random().nextInt(sameContinentCountries.length);
            flagsSet.add(sameContinentCountries[countryIdx].continent + '/' + sameContinentCountries[countryIdx].title);
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

    initModeLandlocked() {
        setState(() { });
    }

    initModeReligion() {
        for (int i = 65; i <= 90; i++) {
            isoLetters.add(String.fromCharCode(i));
        }

        setState(() { });
    }

    initModeLanguage() {
        Set<String> languagesSet = {country!.languages[Random().nextInt(country!.languages.length)]};
        List<Country> sameContinentCountries = CountriesList.countries.where((currCountry) => currCountry.continent == country!.continent).toList();

        do {
            int countryIdx = Random().nextInt(sameContinentCountries.length);
            int languageIdx = Random().nextInt(sameContinentCountries[countryIdx].languages.length);

            if (country!.languages.contains(sameContinentCountries[countryIdx].languages[languageIdx])) continue;
            languagesSet.add(sameContinentCountries[countryIdx].languages[languageIdx]);
        } while (languagesSet.length < 4);

        languages = languagesSet.toList();
        languages.shuffle();

        setState(() { });
    }

    initModeNeighbors() {
        countryNeighbors = country!.neighbors;

        if (countryNeighbors.length == 0) {
            currQuiz = quizList[++currQuizIdx];
            initMode();
        } else {
            Set<String> neighborsSet = countryNeighbors.map((neighbor) => CountriesList.getCountryByTitle(neighbor).continent + '/' + neighbor).toSet();

            if (countryNeighbors.length <= 2) {
                minNeighbors = countryNeighbors.length;
            } else {
                minNeighbors = 2 + Random().nextInt(countryNeighbors.length - 1);
            }

            int totalOptions = neighborsSet.length + 2 + Random().nextInt(2);
            List<Country> sameContinentCountries = CountriesList.countries.where((currCountry) => currCountry.continent == country!.continent && currCountry.neighbors.isNotEmpty).toList();
            
            do {
                int countryIdx = Random().nextInt(sameContinentCountries.length);
                if (country!.title == sameContinentCountries[countryIdx].title || country!.neighbors.contains(sameContinentCountries[countryIdx].title)) continue;
                neighborsSet.add(sameContinentCountries[countryIdx].continent + '/' + sameContinentCountries[countryIdx].title);
            } while (neighborsSet.length < totalOptions);

            neighbors = neighborsSet.toList();
            neighbors.shuffle();

            setState(() { });
        }
    }

    String getCurrentModeDescription() {
        switch (currQuiz!) {
            case GameQuiz.CAPITAL: return 'Capital';
            case GameQuiz.CONTINENT: return 'Continent';
            case GameQuiz.SHAPE: return 'Shape';
            case GameQuiz.POPULATION: return 'Approximate Population';
            case GameQuiz.FLAG: return 'Flag';
            case GameQuiz.COLORS: return '$minColors Primary Color${minColors > 1 ? 's' : ''}';
            case GameQuiz.ISO: return 'ISO Code';
            case GameQuiz.LANDLOCKED: return 'Landlocked or Coastal';
            case GameQuiz.RELIGION: return 'Religion';
            case GameQuiz.LANGUAGE: return country!.languages.length == 1 ? 'Language' : '1 of the official languages';
            case GameQuiz.NEIGHBORS: return '$minNeighbors Neighbor${minNeighbors > 1 ? 's' : ''}';
        }
    }

    Widget getCurrentModeAnswers() {
        switch (currQuiz!) {
            case GameQuiz.CAPITAL: return getModeCapitalAnswers();
            case GameQuiz.CONTINENT: return getModeContinentAnswers();
            case GameQuiz.SHAPE: return getModeShapeAnswers();
            case GameQuiz.POPULATION: return getModePopulationAnswers();
            case GameQuiz.FLAG: return getModeFlagAnswers();
            case GameQuiz.COLORS: return getModeColorsAnswers();
            case GameQuiz.ISO: return getModeIsoAnswers();
            case GameQuiz.LANDLOCKED: return getModeLandlockedAnswers();
            case GameQuiz.RELIGION: return getModeReligionAnswers();
            case GameQuiz.LANGUAGE: return getModeLanguageAnswers();
            case GameQuiz.NEIGHBORS: return getModeNeighborsAnswers();
        }
    }

    Column getModeCapitalAnswers() {
        List<Widget> answers = [];

        for (int i = 0; i < capitals.length; i++) {
            answers.add(
                Padding(
                    padding: EdgeInsets.only(bottom: i + 1 < capitals.length ? 20 : 0),
                    child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: hiddenCapitalsIdxs.contains(i) ? 0 : 1,
                        child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: hiddenCapitalsIdxs.contains(i) || selectedCapitalIdx != -1 ? null : () { 
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
                                            color: selectedCapitalIdx == - 1 || selectedCapitalIdx != i ? AppTheme.MAIN_COLOR : Colors.white,
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
                )
            );
        }

        return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: answers
        );
    }

    GridView getModeContinentAnswers() {
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: continents.length,
            itemBuilder: (BuildContext context, int index) {
                return AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: hiddenContinentIdxs.contains(index) ? 0 : 1,
                    child: TextButton(
                        onPressed: hiddenContinentIdxs.contains(index) || selectedContinentIdx != -1 ? null : () { 
                            verifyContinent(index);
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0),
                            backgroundColor: selectedContinentIdx != - 1 && selectedContinentIdx == index ? continents[selectedContinentIdx].contains(country!.continent) ? Colors.green : Colors.red : Colors.transparent
                        ),
                        child: SizedBox(
                            child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Image(
                                    image: AssetImage('assets/continents/' + continents[index] + '.png')
                                )
                            )
                        )
                    )
                );
            }
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
                return AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: hiddenShapeIdxs.contains(index) ? 0 : 1,
                    child: TextButton(
                        onPressed: hiddenShapeIdxs.contains(index) || selectedShapeIdx != -1 ? null : () { 
                            verifyShape(index);
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0),
                            backgroundColor: selectedShapeIdx != - 1 && selectedShapeIdx == index ? shapes[selectedShapeIdx].contains(country!.title) ? Colors.green : Colors.red : Colors.transparent
                        ),
                        child: SizedBox(
                            child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Image(
                                    image: AssetImage('assets/shapes/' + shapes[index] + '.png')
                                )
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
                Visibility(
                    visible: minPopulationIdx == -1 || minPopulationIdx <= i && i <= minPopulationIdx + 2 ? true : false,
                    child: TextButton(
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
                                onPressed: isPopulationSubmitted || selectedPersonIdx <= 0 || selectedPersonIdx <= minPopulationIdx ? null : () {
                                    setState(() {
                                        selectedPersonIdx -= 1;
                                    });
                                },
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0)
                                ),
                                child: Icon(
                                    Icons.remove,
                                    color: AppTheme.MAIN_COLOR,
                                    size: 40
                                )
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                            )
                        ),
                        Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 200,
                            child: TextButton(
                                onPressed: isPopulationSubmitted ? null : verifyPopulation,
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0)
                                ),
                                child: Center(
                                    child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                            '${trim0Trailing((selectedPersonIdx + 1) * multiplier)}',
                                            style: TextStyle(
                                                fontFamily: 'Segoe UI',
                                                fontSize: 20,
                                                color: isPopulationSubmitted ? Colors.white : AppTheme.MAIN_COLOR,
                                                fontWeight: FontWeight.w700
                                            )
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
                                onPressed: isPopulationSubmitted || selectedPersonIdx + 1 >= populationRange || (minPopulationIdx > -1 && selectedPersonIdx  >= minPopulationIdx + 2)  ? null : () {
                                    setState(() {
                                        selectedPersonIdx += 1;
                                    });
                                },
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0)
                                ),
                                child: Icon(
                                    Icons.add,
                                    color: AppTheme.MAIN_COLOR,
                                    size: 40
                                )
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
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
                return AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: hiddenflagIdxs.contains(index) ? 0 : 1,
                    child: TextButton(
                        onPressed: hiddenflagIdxs.contains(index) || selectedFlagIdx != -1 ? null : () { 
                            verifyFlag(index);
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0),
                            backgroundColor: selectedFlagIdx != - 1 && selectedFlagIdx == index ? flags[selectedFlagIdx].contains(country!.title) ? Colors.green : Colors.red : Colors.transparent
                        ),
                        child: SizedBox(
                            child: Padding(
                                padding: EdgeInsets.all(15),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image(
                                        image: AssetImage('assets/flags/' + flags[index] + '.png')
                                    )
                                )
                            )
                        )
                    )
                );
            }
        );
    }

    Column getModeColorsAnswers() {
        List<Widget> colorMarkers = [];

        for (int i = 0; i < COLORS.length; i++) {
            colorMarkers.add(
                Visibility(
                    visible: hiddenColors.contains(COLORS[i]) ? false : true,
                    child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: selectedMarkers.contains(COLORS[i]) ? 1 : 0.5,
                        child: TextButton(
                            onPressed: areColorsSubmitted ? null : () {
                                setState(() {
                                    if (selectedMarkers.contains(COLORS[i])) {
                                        selectedMarkers.remove(COLORS[i]);
                                    } else {
                                        selectedMarkers.add(COLORS[i]);

                                        if (selectedMarkers.length == minColors) {
                                            verifyColors();
                                        }
                                    }
                                });
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.all(0),
                                backgroundColor: areColorsSubmitted && selectedMarkers.contains(COLORS[i]) ? flagColors.contains(COLORS[i]) ? Colors.green : Colors.red : Colors.transparent 
                            ),
                            child: SvgPicture.asset(
                                'assets/markers/${COLORS[i]}.svg',
                                height: 100
                            )
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
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(image: AssetImage('assets/flags/' + country!.continent + '/' + country!.title + '.png'))
                        ),
                        AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity: areColorsSubmitted ? 0 : 0.92,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image(
                                    image: AssetImage('assets/flags/' + country!.continent + '/' + country!.title + '.png'),
                                    color: Colors.black
                                )
                            )
                        )
                    ]
                ),
                FittedBox(
                    child: Row(
                        children: colorMarkers
                    )
                )
            ]
        );
    }

    Column getModeIsoAnswers() {
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
                                color: AppTheme.MAIN_COLOR,
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
                            color: isIsoSubmitted ? isoLetters[isoCharIdx[0]] == country!.iso[0] ? Colors.green : Colors.red : Colors.white,
                            child: Container(
                                height: 100,
                                width: 50,
                                child: isoCharLockIdx == 0 ? Center(
                                    child: Text(
                                        isoLetters[isoCharIdx[0]],
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: isIsoSubmitted ? Colors.white : AppTheme.MAIN_COLOR
                                        )
                                    )
                                ) : ListWheelScrollView.useDelegate(
                                    physics: isIsoSubmitted ? NeverScrollableScrollPhysics() : FixedExtentScrollPhysics(),
                                    perspective: 0.01,
                                    itemExtent: 50,
                                    childDelegate: ListWheelChildLoopingListDelegate(
                                        children: getIsoLetters(isoCharIdx[0])
                                    ),
                                    onSelectedItemChanged: (index) {
                                        setState(() {
                                            isoCharIdx[0] = index;
                                        });
                                    }
                                )
                            )
                        ),
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            color: isIsoSubmitted ? isoLetters[isoCharIdx[1]] == country!.iso[1] ? Colors.green : Colors.red : Colors.white,
                            child: Container(
                                height: 100,
                                width: 50,
                                child: isoCharLockIdx == 1 ? Center(
                                    child: Text(
                                        isoLetters[isoCharIdx[1]],
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: isIsoSubmitted ? Colors.white : AppTheme.MAIN_COLOR
                                        )
                                    )
                                ) : ListWheelScrollView.useDelegate(
                                    physics: isIsoSubmitted ? NeverScrollableScrollPhysics() : FixedExtentScrollPhysics(),
                                    perspective: 0.01,
                                    itemExtent: 50,
                                    childDelegate: ListWheelChildLoopingListDelegate(
                                        children: getIsoLetters(isoCharIdx[1])
                                    ),
                                    onSelectedItemChanged: (index) {
                                        setState(() {
                                            isoCharIdx[1] = index;
                                        });
                                    }
                                )
                            )
                        )
                    ]
                )
            ]
        );
    }

    List<Widget> getIsoLetters(int currIsoIdx) {
        List<Widget> answers = [];

        for (int i = 0; i < isoLetters.length; i++) {
            answers.add(
                Text(
                    isoLetters[i],
                    style: TextStyle(
                        fontSize: 30,
                        color: isIsoSubmitted ? Colors.white : currIsoIdx == i ? AppTheme.MAIN_COLOR : Colors.black
                    )
                )
            );
        }

        return answers;
    }

    Row getModeLandlockedAnswers() {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    color: isLandlockedOrCoastal == 'Landlocked' ? country!.isLandlocked ? Colors.green : Colors.red : Colors.white,
                    child: TextButton(
                        onPressed: () => {
                            verifyLandlocked('Landlocked')
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0)
                        ),
                        child: Container(
                            width: 150,
                            height: 150,
                            child: Center(
                                child: Text(
                                    'Landlocked',
                                    style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 20,
                                        color: isLandlockedOrCoastal == 'Landlocked' ? Colors.white : AppTheme.MAIN_COLOR,
                                        fontWeight: FontWeight.w700
                                    )
                                )
                            )
                        )
                    )
                ),
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    color: isLandlockedOrCoastal == 'Coastal' ? !country!.isLandlocked ? Colors.green : Colors.red : Colors.white,
                    child: TextButton(
                        onPressed: () => {
                            verifyLandlocked('Coastal')
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0)
                        ),
                        child: Container(
                            width: 150,
                            height: 150,
                            child: Center(
                                child: Text(
                                    'Coastal',
                                    style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 20,
                                        color: isLandlockedOrCoastal == 'Coastal' ? Colors.white : AppTheme.MAIN_COLOR,
                                        fontWeight: FontWeight.w700
                                    )
                                )
                            )
                        )
                    )
                )
            ]
        );
    }

    Column getModeReligionAnswers() {
        List<String> remainingReligions = List.from(RELIGIONS);
        hiddenReligions.forEach((element) { remainingReligions.remove(element); });

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
                            onPressed: isReligionSubmitted ? null : verifyReligion,
                            child: Icon(
                                Icons.check,
                                color: AppTheme.MAIN_COLOR,
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
                            color: isReligionSubmitted ? remainingReligions[selectedReligionIdx] == country!.religion ? Colors.green : Colors.red : Colors.white,
                            child: RotatedBox(
                                quarterTurns: 3,
                                child: Container(
                                    height: 240,
                                    width: 120,
                                    child: ListWheelScrollView.useDelegate(
                                        physics: isReligionSubmitted ? NeverScrollableScrollPhysics() : FixedExtentScrollPhysics(),
                                        perspective: 0.01,
                                        itemExtent: 120,
                                        childDelegate: ListWheelChildLoopingListDelegate(
                                            children: getReligions()
                                        ),
                                        onSelectedItemChanged: (index) {
                                            setState(() {
                                                selectedReligionIdx = index;
                                            });
                                        }
                                    )
                                )
                            )
                        )
                    ]
                )
            ]
        );
    }

    List<Widget> getReligions() {
        List<Widget> answers = [];

        List<String> remainingReligions = List.from(RELIGIONS);
        hiddenReligions.forEach((element) { remainingReligions.remove(element); });

        for (int i = 0; i < remainingReligions.length; i++) {
            answers.add(
                RotatedBox(
                    quarterTurns: 1,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            SvgPicture.asset(
                                'assets/religions/${remainingReligions[i]}.svg',
                                height: 50
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                    remainingReligions[i],
                                    style: TextStyle(
                                        color: isReligionSubmitted ? Colors.white : Colors.black
                                    )
                                )
                            )
                        ]
                    )
                )
            );
        }

        return answers;
    }

    Column getModeLanguageAnswers() {
        List<Widget> answers = [];

        for (int i = 0; i < languages.length; i++) {
            answers.add(
                Padding(
                    padding: EdgeInsets.only(bottom: i + 1 < languages.length ? 20 : 0),
                    child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: hiddenLanguageIdxs.contains(i) ? 0 : 1,
                        child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: hiddenLanguageIdxs.contains(i) || selectedLanguageIdx != -1 ? null : () { 
                                    verifyLanguage(i);
                                },
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0)
                                ),
                                child: Center(
                                    child: Text(
                                        languages.elementAt(i),
                                        style: TextStyle(
                                            fontFamily: 'Segoe UI',
                                            fontSize: 20,
                                            color: selectedLanguageIdx == - 1 || selectedLanguageIdx != i ? AppTheme.MAIN_COLOR : Colors.white,
                                            fontWeight: FontWeight.w700
                                        )
                                    )
                                )
                            ),
                            decoration: BoxDecoration(
                                color: selectedLanguageIdx == - 1 || selectedLanguageIdx != i ? Colors.white : country!.languages.contains(languages[selectedLanguageIdx]) ? Colors.green : Colors.red,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(30))
                            )
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

    Center getModeNeighborsAnswers() {
        List<Widget> neighborsList = [];

        for (int i = 0; i < neighbors.length; i++) {
            neighborsList.add(
                Visibility(
                    visible: hiddenNeighborsIdxs.contains(i) ? false : true,
                    child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: selectedNeighbors.contains(neighbors[i]) ? 1 : 0.5,
                        child: TextButton(
                            onPressed: hiddenNeighborsIdxs.contains(i) || areNeighborsSubmitted ? null : () {
                                setState(() {
                                    if (selectedNeighbors.contains(neighbors[i])) {
                                        selectedNeighbors.remove(neighbors[i]);
                                    } else {
                                        selectedNeighbors.add(neighbors[i]);

                                        if (selectedNeighbors.length == minNeighbors) {
                                            verifyNeighbors();
                                        }
                                    }
                                });
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.all(0),
                                backgroundColor: areNeighborsSubmitted && selectedNeighbors.contains(neighbors[i]) ? countryNeighbors.contains(neighbors[i].split('/')[1]) ? Colors.green : Colors.red : Colors.transparent 
                            ),
                            child: Image(
                                image: AssetImage(
                                    'assets/shapes/${neighbors[i]}.png'
                                )
                            )
                        )
                    )
                )
            );
        }

        return Center(
            child: Container(
                height: 200,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (BuildContext context, int index) {
                        return SizedBox( width: 60 );
                    },
                    itemCount: neighborsList.length,
                    itemBuilder: (BuildContext context, int index) {
                        return neighborsList[index];
                    }
                )
            )
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
            isGameFinished();

            currQuizIdx++;
            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 500), () {
                    currQuiz = quizList[currQuizIdx];
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
            isGameFinished();

            currQuizIdx++;
            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 500), () {
                    currQuiz = quizList[currQuizIdx];
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
            isGameFinished();

            currQuizIdx++;
            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 500), () {
                    currQuiz = quizList[currQuizIdx];
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

    void isGameFinished() {
        if(currQuizIdx + 1 == quizList.length) {
            AudioPlayer.play(AudioList.WIN);

            country!.isEasySolved = true;
            if (gameMode == GameMode.HARD) {
                country!.isHardSolved = true;
                country!.isNormalSolved = true;
            } else if (gameMode == GameMode.NORMAL) {
                country!.isNormalSolved = true;
            }

            CountriesList.storeData();

            Future.delayed(Duration(milliseconds: 1000), () {
                Navigator.of(context).pop(true);
            });
        } else {
            AudioPlayer.play(AudioList.CORRECT_ANSWER);
        }
    }

    void verifyPopulation() {
        isPopulationSubmitted = true;

        if (selectedPersonIdx + 1 == population.round()) {
            isGameFinished();

            isPopulationCorrect = true;
            currQuizIdx++;
            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 500), () {
                    currQuiz = quizList[currQuizIdx];
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
            isGameFinished();

            currQuizIdx++;
            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 500), () {
                    currQuiz = quizList[currQuizIdx];
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
            isGameFinished();

            areColorsCorrect = true;
            currQuizIdx++;
            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 1000), () {
                    currQuiz = quizList[currQuizIdx];
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

        if (isoLetters[isoCharIdx[0]] + isoLetters[isoCharIdx[1]] == country!.iso) {
            isGameFinished();

            isIsoCorrect = true;
            currQuizIdx++;
            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 1000), () {
                    currQuiz = quizList[currQuizIdx];
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

    void verifyLandlocked(String response) {
        isLandlockedOrCoastal = response;

        if (response == 'Landlocked' && country!.isLandlocked || 
            response == 'Coastal' && !country!.isLandlocked) {

            isGameFinished();

            isIsoCorrect = true;
            currQuizIdx++;
            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 1000), () {
                    currQuiz = quizList[currQuizIdx];
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

     void verifyReligion() {
        isReligionSubmitted = true;

        List<String> remainingReligions = List.from(RELIGIONS);
        hiddenReligions.forEach((element) { remainingReligions.remove(element); });

        if (remainingReligions[selectedReligionIdx] == country!.religion) {
            isGameFinished();

            isIsoCorrect = true;
            currQuizIdx++;
            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 1000), () {
                    currQuiz = quizList[currQuizIdx];
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

    void verifyLanguage(int idx) {
        selectedLanguageIdx = idx;

        if (country!.languages.contains(languages[idx])) {
            isGameFinished();

            currQuizIdx++;
            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 500), () {
                    currQuiz = quizList[currQuizIdx];
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

    void verifyNeighbors() {
        areNeighborsSubmitted = true;

        if (selectedNeighbors.every((neighbor) => countryNeighbors.contains(neighbor.split('/')[1]))) {
            isGameFinished();

            areNeighborsCorrect = true;
            currQuizIdx++;
            if (currQuizIdx < totalModes) {
                Future.delayed(Duration(milliseconds: 1000), () {
                    currQuiz = quizList[currQuizIdx];
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

    Future<void> showHintsDialog() {
        return showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: Colors.black54,
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
                return WillPopScope(
                    onWillPop: () {
                        return Future.value(true);
                    },
                    child: StatefulBuilder(
                        builder: (context, setState) {
                            Widget hintButton(int minHints, String txt, Function action) {
                                return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Opacity(
                                        opacity: hints >= minHints ? 1 : 0.6,
                                        child: TextButton(
                                            onPressed: hints >= minHints ? () {
                                                hints -= minHints; 
                                                action();
                                                isHintUsed = true;
                                                CountriesList.storeData();
                                                
                                                hintsAnimation = new Tween<double>(
                                                    begin: hintsAnimation!.value,
                                                    end: hints.toDouble()
                                                ).animate(new CurvedAnimation(
                                                    curve: Curves.fastOutSlowIn,
                                                    parent: hintsController!
                                                ));
                                                hintsController!.forward(from: 0.0);

                                                Navigator.pop(context);
                                            } : null,
                                            child: hintContainer(txt, null, minHints.toString())
                                        )
                                    )
                                );
                            }


                            void getModeCapitalHint() {
                                do {
                                    int capitalIdx = Random().nextInt(capitals.length);
                                    if (capitals[capitalIdx] != country!.capital) hiddenCapitalsIdxs.add(capitalIdx);
                                } while (hiddenCapitalsIdxs.length != 2);
                            }

                            void getModeContinentHint() {
                                do {
                                    int continentIdx = Random().nextInt(continents.length);
                                    if (continents[continentIdx] != country!.continent) hiddenContinentIdxs.add(continentIdx);
                                } while (hiddenContinentIdxs.length != 2);
                            }

                            void getModeShapeHint() {
                                do {
                                    int shapeIdx = Random().nextInt(shapes.length);
                                    if (!shapes[shapeIdx].contains(country!.title)) hiddenShapeIdxs.add(shapeIdx);
                                } while (hiddenShapeIdxs.length != 2);
                            }

                            void getModeFlagHint() {
                                do {
                                    int flagIdx = Random().nextInt(flags.length);
                                    if (!flags[flagIdx].contains(country!.title)) hiddenflagIdxs.add(flagIdx);
                                } while (hiddenflagIdxs.length != 2);
                            }

                            void getModeIsoHint() {
                                isoCharLockIdx = Random().nextInt(2);
                                isoCharIdx[isoCharLockIdx] = isoLetters.indexOf(country!.iso[isoCharLockIdx]);
                            }

                            void getModeReligionHint() {
                                do {
                                    int religionIdx = Random().nextInt(RELIGIONS.length);
                                    if (RELIGIONS[religionIdx] != country!.religion) hiddenReligions.add(RELIGIONS[religionIdx]);
                                } while (hiddenReligions.length != 2);
                            }

                            void getModeLanguageHint() {
                                do {
                                    int languageIdx = Random().nextInt(languages.length);
                                    if (!country!.languages.contains(languages[languageIdx])) hiddenLanguageIdxs.add(languageIdx);
                                } while (hiddenLanguageIdxs.length != 2);
                            }

                            void getModeNeighborsHint() {
                                do {
                                    int neighborIdx = Random().nextInt(neighbors.length);
                                    if (!country!.neighbors.contains(neighbors[neighborIdx].split('/')[1])) hiddenNeighborsIdxs.add(neighborIdx);
                                } while (country!.neighbors.length + hiddenNeighborsIdxs.length + 1 < neighbors.length);
                            }

                            void getModeColorsHint() {
                                do {
                                    int colorIdx = Random().nextInt(COLORS.length);
                                    if (!country!.colors.contains(COLORS[colorIdx])) hiddenColors.add(COLORS[colorIdx]);
                                } while (country!.colors.length + hiddenColors.length + 1 < COLORS.length);
                                selectedMarkers.removeAll(hiddenColors);
                            }

                            void getModePopulationHint() {
                                minPopulationIdx = population.round() - 1 - Random().nextInt(3);
                                if (selectedPersonIdx < minPopulationIdx) selectedPersonIdx = minPopulationIdx;
                                if (selectedPersonIdx > minPopulationIdx + 2) selectedPersonIdx = minPopulationIdx + 2;
                            }

                            Widget getModeHintsButton(GameQuiz quiz) {
                                if (isHintUsed) return SizedBox.shrink();

                                switch (currQuiz!) {
                                    case GameQuiz.CAPITAL: return hintButton(2, '50-50', getModeCapitalHint);
                                    case GameQuiz.CONTINENT: return hintButton(2, '50-50', getModeContinentHint);
                                    case GameQuiz.SHAPE: return hintButton(2, '50-50', getModeShapeHint);
                                    case GameQuiz.POPULATION: return hintButton(2, 'Three of a Kind', getModePopulationHint);
                                    case GameQuiz.FLAG: return hintButton(2, '50-50', getModeFlagHint);
                                    case GameQuiz.COLORS: return hintButton(2, '1 irrelative color', getModeColorsHint);
                                    case GameQuiz.ISO: return hintButton(2, 'Reveal 1 of the letters', getModeIsoHint);
                                    case GameQuiz.LANDLOCKED: return SizedBox.shrink();
                                    case GameQuiz.RELIGION: return hintButton(2, 'Three of a Kind', getModeReligionHint);
                                    case GameQuiz.LANGUAGE: return hintButton(2, '50-50', getModeLanguageHint);
                                    case GameQuiz.NEIGHBORS: return hintButton(2, '1 non-neighbor', getModeNeighborsHint);
                                }
                            }

                            return Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 27, 20, 0),
                                    child: Material(
                                        type: MaterialType.transparency,
                                        child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: isHintUsed ? 200 : 250,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: AppTheme.MAIN_COLOR
                                            ),
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
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
                                                                        AnimatedBuilder(
                                                                            animation: hintsAnimation!,
                                                                            builder: (BuildContext context, Widget? child) {
                                                                                return Text(
                                                                                    hintsAnimation!.value.toInt().toString(),
                                                                                    style: TextStyle(
                                                                                        fontFamily: 'Segoe UI',
                                                                                        fontSize: 20,
                                                                                        color: Color(0xFFFFD517),
                                                                                        fontWeight: FontWeight.w700,
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
                                                    Padding(
                                                        padding: EdgeInsets.all(15),
                                                        child: getModeHintsButton(currQuiz!)
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.all(15),
                                                        child: TextButton(
                                                            onPressed: () {
                                                                setState(() {
                                                                    getReward(RewardedAd rewardedAd, RewardItem rewardItem) {
                                                                        hints += 10;
                                                                        CountriesList.storeData();
                                                                        hintsAnimation = new Tween<double>(
                                                                            begin: hintsAnimation!.value,
                                                                            end: hints.toDouble()
                                                                        ).animate(new CurvedAnimation(
                                                                            curve: Curves.fastOutSlowIn,
                                                                            parent: hintsController!
                                                                        ));
                                                                    }
                                                                    
                                                                    AdManager.showRewardedAd(getReward);
                                                                });
                                                                hintsController!.forward(from: 0.0);
                                                            },
                                                            child: hintContainer(null, Icons.video_call, '+5')
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
                );
            }
        ).then((value) => setState(() { }));
    }

    Widget hintContainer(String? txt, IconData? icon, String hints) {
            return Container(
                height: 50,
                width: double.infinity,
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            txt != null ?
                            Text(
                                txt,
                                style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 20,
                                    color: AppTheme.MAIN_COLOR,
                                    fontWeight: FontWeight.w700
                                )
                            )
                            :
                            Icon(
                                icon,
                                color: AppTheme.MAIN_COLOR,
                                size: 40,
                            ),
                            Row(
                                children: [
                                    Text(
                                        hints,
                                        style: TextStyle(
                                            fontFamily: 'Segoe UI',
                                            fontSize: 20,
                                            color: Color(0xFFFFD517),
                                            fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center
                                    ),
                                    SizedBox( width: 5 ),
                                    SizedBox(
                                        width: 20,
                                        child: Image(image: AssetImage('assets/hint.png'), fit: BoxFit.contain)
                                    ),
                                ]
                            )
                        ]
                    )
                ),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(30))
                )
            );
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