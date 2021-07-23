import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:worldcountriesquiz/AdManager.dart';
import 'package:worldcountriesquiz/Logos.dart';
import 'package:worldcountriesquiz/AudioPlayer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:math';

class LogoScreen extends StatelessWidget {
    final int catIdx;
    final int logoIdx;

    LogoScreen({ Key? key, required this.catIdx, required this.logoIdx }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return LogoQuery(catIdx: catIdx, logoIdx: logoIdx);
	}
}

class LogoState extends State<LogoQuery> with TickerProviderStateMixin {
    int? catIdx;
    int logoIdx = -1;
    int selectedResponseIdx = -1;
    String? correctLogoTitle;
    List<String> answersTitlesList = [];
    List<AnimatedOpacity> answers = [];
    Set<String> answersTitles = {};
    int gameMode = 0;
    bool areAllLogosSolved = false;
    bool isCurrLogoSolved = false;
    List<String> hiddenAnswers = [];
    AnimationController? hintsController;
    Animation<double>? hintsAnimation;
    bool toGetMoreHints = true;
    List<String> availableLetters = [];
    List<String> placedLetters = [];
    List<String> hiddenLetters = [];
    List<int> hiddenLetterIndxs = [];
    bool isHalfSolved = false;
    List<int> allSolvedListToExclude = [];

    ScrollController scrollController = new ScrollController(
        initialScrollOffset: 0.0,
        keepScrollOffset: true,
    );

    @override
	void initState() {
        hintsController = new AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 1500)
        );

        hintsAnimation = new Tween<double>(
            begin: hints.toDouble(),
            end: hints.toDouble(),
        ).animate(new CurvedAnimation(
            curve: Curves.fastOutSlowIn,
            parent: hintsController!
        ));

		super.initState();

        AdManager.loadRewardedAd();

        catIdx = widget.catIdx;
        logoIdx = widget.logoIdx;

        areAllLogosSolved = LogosList.categories[catIdx!].getTotalSolvedLogos() == LogosList.categories[catIdx!].logos.length;
        isCurrLogoSolved = logoIdx != -1;

        initRandomGameMode();
	}

    @override
    void dispose() {
        hintsController!.dispose();
        super.dispose();
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
                                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                            height: 35,
                                            child: areAllLogosSolved && !isCurrLogoSolved ? Icon(
                                                Icons.arrow_back,
                                                color: const Color(0xffce17ac),
                                                size: 20,
                                            ) : Row(
                                                children: [
                                                    Icon(
                                                        Icons.arrow_back,
                                                        color: const Color(0xffce17ac),
                                                        size: 20,
                                                    ),
                                                    SizedBox(
                                                        width: 10
                                                    ),
                                                    Text(
                                                        LogosList.categories[catIdx!].title + (isCurrLogoSolved ? '' : ' ' +
                                                        LogosList.categories[catIdx!].getTotalSolvedLogos().toString() + '/' +
                                                        LogosList.categories[catIdx!].logos.length.toString()),
                                                        style: TextStyle(
                                                            fontFamily: 'Segoe UI',
                                                            fontSize: 20,
                                                            color: const Color(0xffce17ac),
                                                            fontWeight: FontWeight.w700
                                                        ),
                                                        textAlign: TextAlign.center
                                                    )
                                                ]
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(Radius.circular(30))
                                            )
                                        )
                                    ), areAllLogosSolved && !isCurrLogoSolved ?
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                        height: 35,
                                        child: Row(
                                            children: [
                                                Text(
                                                    allSolvedListToExclude.length.toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Segoe UI',
                                                        fontSize: 20,
                                                        color: Color(0xFFFFD517),
                                                        fontWeight: FontWeight.w700
                                                    )
                                                ),
                                                SizedBox(
                                                    width: 10
                                                ),
                                                SizedBox(
                                                    width: 30,
                                                    child: Image(image: AssetImage('assets/crown.png'), fit: BoxFit.contain)
                                                ),
                                                SizedBox(
                                                    width: 10
                                                ),
                                                Text(
                                                    LogosList.categories[catIdx!].highScore.toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Segoe UI',
                                                        fontSize: 20,
                                                        color: Color(0xFFFFD517),
                                                        fontWeight: FontWeight.w700
                                                    )
                                                )
                                            ]
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(Radius.circular(30))
                                        )
                                    )
                                    :
                                    SizedBox.shrink(),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.all(0)
                                        ),
                                        onPressed: () => {
                                            showHintsDialog(context, 0)
                                        },
                                        child: Container(
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
                            )
                        ),
                        Expanded(
                            child: randomGameMode(context)
                        )
                    ]
                )
            )
        );
    }

    void initRandomGameMode() {
        hiddenAnswers = [];
        toGetMoreHints = true;

        gameMode = Random().nextInt(4);
        // gameMode = 3;

        while(logoIdx == -1) {
            int rndIdx = Random().nextInt(LogosList.categories[catIdx!].logos.length);
            if(areAllLogosSolved) {
                if(allSolvedListToExclude.contains(rndIdx)) continue;
                logoIdx = rndIdx;
                print(allSolvedListToExclude);
                print("NEW   " + logoIdx.toString());
                break;
            } else {
                if (!LogosList.categories[catIdx!].logos[rndIdx].isSolved) logoIdx = rndIdx;
            }
        }

        correctLogoTitle = LogosList.categories[catIdx!].logos[logoIdx].title;

        if (gameMode == 0) {
            answers = [];
            answersTitles = {LogosList.categories[catIdx!].logos[logoIdx].title};

            while(answersTitles.length < 4) {
                int idx = Random().nextInt(LogosList.categories[catIdx!].logos.length);
                answersTitles.add(LogosList.categories[catIdx!].logos[idx].title);
            }

            answersTitlesList = answersTitles.toList();
            answersTitlesList.shuffle();
        } else if (gameMode == 1) {
            Set<String> answersTitles = {LogosList.categories[catIdx!].logos[logoIdx].title};
        
            while(answersTitles.length < 4) {
                int idx = Random().nextInt(LogosList.categories[catIdx!].logos.length);
                answersTitles.add(LogosList.categories[catIdx!].logos[idx].title);
            }

            answersTitlesList = answersTitles.toList();
            answersTitlesList.shuffle();
        } else if (gameMode == 2) {
            getRandomAvailableLetters();
        } else if (gameMode == 3) {
            availableLetters = correctLogoTitle!.toUpperCase().split('');
            do {
                availableLetters.shuffle();
            } while (availableLetters.join('').compareTo(correctLogoTitle!) == 0);
        }

        setState(() { });
    }

    Widget randomGameMode(BuildContext context) {
        return gameMode == 0 ?
            Column(
                children: [
                    Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0, style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        margin: const EdgeInsets.all(15),
                        color: Colors.white,
                        child: SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: SvgPicture.asset('assets/logos/'+ LogosList.categories[catIdx!].title + '/'  + LogosList.categories[catIdx!].logos[logoIdx].title + '.svg', fit: BoxFit.contain)
                            )
                        )
                    ),
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: getMode1Answers()
                        )
                    )
                ]
            )
            : gameMode == 1 ?
            Column(
                children: [
                    Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0, style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        margin: const EdgeInsets.all(15),
                        color: Colors.white,
                        child: Container(
                            alignment: Alignment.center,
                            height: 90,
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                    LogosList.categories[catIdx!].logos[logoIdx].title,
                                    style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 20,
                                        color: const Color(0xFF6B246F),
                                        fontWeight: FontWeight.w700
                                    )
                                )
                            )
                        )
                    ),
                    Expanded(
                        child: SizedBox.shrink()
                    ),
                    getMode2Answers()
                ]      
            )
            :
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0, style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        margin: const EdgeInsets.all(15),
                        color: Colors.white,
                        child: SizedBox(
                            height: 220,
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: SvgPicture.asset('assets/logos/'+ LogosList.categories[catIdx!].title + '/'  + LogosList.categories[catIdx!].logos[logoIdx].title + '.svg', fit: BoxFit.contain)
                            )
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 15, right: 40),
                        child: Row(
                            children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 40, 0),
                                    child: Container(
                                        height: 40,
                                        width: 40,
                                        alignment: Alignment.center,
                                        child: Text(
                                            LogosList.categories[catIdx!].logos[logoIdx].title.length.toString(),
                                            style: TextStyle(
                                                fontFamily: 'Segoe UI',
                                                fontSize: 20,
                                                color: const Color(0xffce17ac),
                                                fontWeight: FontWeight.w700,
                                            )
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(Radius.circular(30))
                                        )
                                    )
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      controller: scrollController,
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: mode3AnswerTiles()
                                      )
                                    )
                                )
                            ]
                        )
                    ),
                    Expanded(
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding: EdgeInsets.only(top: 10, right: 20),
                                child: Column(
                                    children: [
                                        TextButton(
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.all(0)
                                            ),
                                            onPressed: clearPlacedLetters,
                                            child: Container(
                                                height: 30,
                                                width: 30,
                                                child: Icon(
                                                    Icons.delete,
                                                    color: const Color(0xffce17ac),
                                                    size: 20,
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
                                            onPressed: removeLetter,
                                            child: Container(
                                                height: 30,
                                                width: 30,
                                                child: Icon(
                                                    Icons.remove,
                                                    color: const Color(0xffce17ac),
                                                    size: 20,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.rectangle,
                                                    borderRadius: BorderRadius.all(Radius.circular(30))
                                                )
                                            )
                                        )
                                    ]
                                )
                            )
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                                height: availableLetters.length < 5 ? 50 : 100,
                                child: GridView.builder(
                                    scrollDirection: Axis.horizontal,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: availableLetters.length < 5 ? 1 : 2,
                                        childAspectRatio: 1,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20
                                    ),
                                    shrinkWrap: true,
                                    itemCount: availableLetters.length,
                                    itemBuilder: (BuildContext context, int index) {
                                        return AnimatedOpacity(
                                            opacity: gameMode == 3 ? hiddenLetterIndxs.contains(index) ? 0 : 1 : hiddenLetters.contains(availableLetters.elementAt(index)) ? 0 : 1,
                                            duration: const Duration(milliseconds: 500),
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                    padding: EdgeInsets.all(0)
                                                ),
                                                onPressed: (gameMode == 2 || (gameMode == 3 && !hiddenLetterIndxs.contains(index))) && placedLetters.length < correctLogoTitle!.length ? () => placeSelectedLetter(index) : null,
                                                child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        availableLetters.elementAt(index),
                                                        style: TextStyle(
                                                            fontFamily: 'Segoe UI',
                                                            fontSize: 20,
                                                            color: const Color(0xffce17ac),
                                                            fontWeight: FontWeight.w700,
                                                        )
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.rectangle,
                                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                                    )
                                                )
                                            )
                                        );
                                    }
                                )
                            )
                        )
                    )
                ]
            );
    }

    Column getMode1Answers() {
        answers = [];

        for (int i = 0; i < answersTitlesList.length; i++) {
            answers.add(
                AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: hiddenAnswers.contains(answersTitlesList[i]) ? 0 : 1,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.all(0)
                            ),
                            onPressed: selectedResponseIdx != -1 ? null : () => { verifyResponse(i) },
                            child: Container(
                                height: 50,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                    answersTitlesList[i],
                                    style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 20,
                                        color: selectedResponseIdx == -1 || selectedResponseIdx != i ? Color(0xFF6B246F) : correctLogoTitle == answersTitlesList[selectedResponseIdx] ? Colors.white : Colors.white,
                                        fontWeight: FontWeight.w700
                                    )
                                ),
                                decoration: BoxDecoration(
                                    color: selectedResponseIdx == -1 || selectedResponseIdx != i ? Colors.white : correctLogoTitle == answersTitlesList[selectedResponseIdx] ? Colors.green : Colors.red,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.all(Radius.circular(30))
                                )
                            )
                        )
                    )
                )
            );
        }

        return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: answers
        );
    }

    GridView getMode2Answers() {
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
            ),
            shrinkWrap: true,
            itemCount: answersTitlesList.length,
            itemBuilder: (BuildContext context, int index) {
                return AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: hiddenAnswers.contains(answersTitlesList[index]) ? 0 : 1,
                    child: Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0, style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        margin: const EdgeInsets.all(15),
                        color: selectedResponseIdx == -1 || selectedResponseIdx != index ? Colors.white : correctLogoTitle == answersTitlesList[selectedResponseIdx] ? Colors.green : Colors.red,
                        child: TextButton(
                            onPressed: selectedResponseIdx != -1 ? null : () => { verifyResponse(index) },
                            child: SizedBox(
                                child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: SvgPicture.asset('assets/logos/'+ LogosList.categories[catIdx!].title + '/'  + answersTitlesList[index] + '.svg', fit: BoxFit.contain)
                                )
                            )
                        )
                    )
                );
            }
        );
    }

    List<Padding> mode3AnswerTiles() {
        List<Padding> answerTiles = [];

        for (int i = 0; i < LogosList.categories[catIdx!].logos[logoIdx].title.length; i++) {
            answerTiles.add(
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.5),
                    child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: Text(
                            i < placedLetters.length ? placedLetters[i] : '',
                            style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 20,
                                color: correctLogoTitle!.length != placedLetters.length ? Color(0xffce17ac) :
                                   correctLogoTitle!.toUpperCase().compareTo(placedLetters.join('').toString()) == 0 ? Colors.white : Colors.white,
                                fontWeight: FontWeight.w700,
                            )
                        ),
                        decoration: BoxDecoration(
                            color: correctLogoTitle!.length != placedLetters.length ? Colors.white :
                                   correctLogoTitle!.toUpperCase().compareTo(placedLetters.join('').toString()) == 0 ? Colors.green : Colors.red,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        )
                    )
                )
            );
        }

        return answerTiles;
    }

    void verifyResponse(int idx) {
        selectedResponseIdx = idx;

        if(correctLogoTitle == answersTitlesList[selectedResponseIdx]) {
            AudioPlayer.play(AudioList.CORRECT_ANSWER);
        } else {
            AudioPlayer.play(AudioList.WRONG_ANSWER);
        }

        if (!isCurrLogoSolved && !areAllLogosSolved && correctLogoTitle == answersTitlesList[selectedResponseIdx]) {
            LogosList.categories[catIdx!].logos[logoIdx].isSolved = true;

            if (LogosList.categories[catIdx!].getTotalSolvedLogos() == LogosList.categories[catIdx!].logos.length) {
                hints += LogosList.categories[catIdx!].logos.length ~/ 2;
                LogosList.storeData();
            }

            if (toGetMoreHints) {
                hints += 1;
                LogosList.storeData();

                hintsAnimation = new Tween<double>(
                    begin: hintsAnimation!.value,
                    end: hints.toDouble()
                ).animate(new CurvedAnimation(
                    curve: Curves.fastOutSlowIn,
                    parent: hintsController!
                ));
                hintsController!.forward(from: 0.0);
            }

            LogosList.storeData();
        }
        
        setState(() { });

        Future.delayed(const Duration(milliseconds: 1000), () {
            if (areAllLogosSolved) {
                if (correctLogoTitle == answersTitlesList[selectedResponseIdx]) {
                    allSolvedListToExclude.add(logoIdx);
                    if (allSolvedListToExclude.length > LogosList.categories[catIdx!].highScore) {
                        LogosList.categories[catIdx!].highScore = allSolvedListToExclude.length;
                    }
                    LogosList.storeData();
                    if (allSolvedListToExclude.length == LogosList.categories[catIdx!].logos.length) Navigator.of(context).pop(true);
                } else {
                    allSolvedListToExclude = [];
                }
            }

            logoIdx = -1;
            selectedResponseIdx = -1;
            answersTitlesList = [];
            answers = [];
            answersTitles = {};

            if (!isCurrLogoSolved && (areAllLogosSolved || LogosList.categories[catIdx!].getTotalSolvedLogos() < LogosList.categories[catIdx!].logos.length)) {
                initRandomGameMode();
            } else {
                Navigator.of(context).pop(true);
            }
        });
    }

    void hide2Answer() {
        hide1Answer();
        hide1Answer();
    }

    void solveLogo() {
        for (int i = 0; i < answersTitlesList.length; i++) {
            if (answersTitlesList.elementAt(i) == correctLogoTitle) {
                toGetMoreHints = false;
                verifyResponse(i);

                return;
            }
        }
    }

    void hide1Answer() {
        if (hiddenAnswers.length == 3) return;

        int idx = 0;
        do {
            idx =  Random().nextInt(answersTitlesList.length);
        } while (answersTitlesList.elementAt(idx) == correctLogoTitle || hiddenAnswers.contains(answersTitlesList.elementAt(idx)));

        hiddenAnswers.add(answersTitlesList.elementAt(idx));

        if (hiddenAnswers.length == 3) solveLogo();
    }

    void hideLetters(int count) {
        Set<String> hiddenLettersSet = {};

        do {
            int idx = Random().nextInt(availableLetters.length);
            
            if (!hiddenLetters.contains(availableLetters.elementAt(idx)) && !correctLogoTitle!.toUpperCase().split('').contains(availableLetters.elementAt(idx))) {

                hiddenLettersSet.add(availableLetters.elementAt(idx));
            }
        } while(hiddenLettersSet.length < count);

        hiddenLetters.addAll(hiddenLettersSet.toList());
    }

    Future<void> showHintsDialog(BuildContext context, int modeIdx) {
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
                                                LogosList.storeData();
                                                
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

                            Column getModeHintsButton(int mode) {
                                if (mode == 0) {
                                    return Column(
                                        children: [
                                            hintButton(3, 'Remove 1 answer', hide1Answer),
                                            hintButton(5, 'Remove 2 answers', hide2Answer),
                                            hintButton(8, 'Solved', solveLogo)
                                        ]
                                    );
                                } else if (mode == 1) {
                                    return Column(
                                        children: [
                                            hintButton(3, 'Remove 1 answer', hide1Answer),
                                            hintButton(5, 'Remove 2 answers', hide2Answer),
                                            hintButton(8, 'Solved', solveLogo)
                                        ]
                                    );
                                } else if (mode == 2) {
                                    return Column(
                                        children: [
                                            hintButton(3, '50% extra letters', () => hideLetters(3)),
                                            hintButton(5, '0% extra letters', () => hideLetters(6)),
                                            hintButton(8, 'Solved', solveLogoLetters)
                                        ]
                                    );
                                } else {
                                    return Column(
                                        children: [
                                            hintButton(5, '50% solved', solveHalfLogoLetters),
                                            hintButton(8, 'Solved', solveLogoLetters)
                                        ]
                                    );
                                }
                            }

                            return Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(15, 22, 15, 0),
                                    child: Material(
                                        type: MaterialType.transparency,
                                        child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: 400,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                gradient: LinearGradient(
                                                    begin: Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                        Color(0xFFCA08A6),
                                                        Color(0xFFF69CE4)
                                                    ]
                                                )
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
                                                        child: getModeHintsButton(gameMode)
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.all(15),
                                                        child: TextButton(
                                                            onPressed: () {
                                                                setState(() {
                                                                    getReward(RewardedAd rewardedAd, RewardItem rewardItem) {
                                                                        hints += 10;
                                                                        LogosList.storeData();
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
                                                            child: hintContainer(null, Icons.video_call, '+10')
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
                                    color: const Color(0xFFCA08A6),
                                    fontWeight: FontWeight.w700
                                )
                            )
                            :
                            Icon(
                                icon,
                                color: Color(0xFFCA08A6),
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

    getRandomAvailableLetters() {
        Set<String> lettersSet = correctLogoTitle!.toUpperCase().split('').toSet();
        int length = lettersSet.length;

        while (lettersSet.length < length + 6) {
            lettersSet.add(String.fromCharCode(97 + Random().nextInt(26)).toUpperCase());
        }

        availableLetters = lettersSet.toList();
        availableLetters.shuffle();
    }

    placeSelectedLetter(int index) {
        hiddenLetterIndxs.add(index);
        placedLetters.add(availableLetters.elementAt(index));

        if (placedLetters.length == correctLogoTitle!.length) verifyPlacedLettersResponse();

        setState(() { });
    }

    removeLetter() {
        if (placedLetters.length == 0) return;

        if (isHalfSolved && placedLetters.length <= correctLogoTitle!.length ~/ 2) {
            return;
        } else {
            hiddenLetterIndxs.removeLast();
            placedLetters.removeLast();
        }

        setState(() { });
    }

    clearPlacedLetters() {
        if (isHalfSolved) {
            placedLetters = placedLetters.getRange(0, correctLogoTitle!.length ~/ 2).toList();
            hiddenLetterIndxs = hiddenLetterIndxs.getRange(0, correctLogoTitle!.length ~/ 2).toList();
        } else {
            hiddenLetterIndxs = [];
            placedLetters = [];
        }

        setState(() { });
    }

    void solveHalfLogoLetters() {
        if (isHalfSolved) {
            solveLogoLetters();
            return;
        }

        placedLetters = correctLogoTitle!.substring(0, correctLogoTitle!.length ~/ 2).toUpperCase().split('');
        
        for (int i = 0; i < correctLogoTitle!.length ~/ 2; i++) {
            hiddenLetterIndxs.add(availableLetters.indexOf(placedLetters[i]));
        }

        isHalfSolved = true;
    }

    void solveLogoLetters() {
        placedLetters = correctLogoTitle!.toUpperCase().split('');
        verifyPlacedLettersResponse();
    }

    void verifyPlacedLettersResponse() {
        if(correctLogoTitle!.toUpperCase().compareTo(placedLetters.join('').toString()) == 0) {
            AudioPlayer.play(AudioList.CORRECT_ANSWER);
        } else {
            AudioPlayer.play(AudioList.WRONG_ANSWER);
        }

        if (!isCurrLogoSolved && !areAllLogosSolved && correctLogoTitle!.toUpperCase().compareTo(placedLetters.join('').toString()) == 0) {
            
            LogosList.categories[catIdx!].logos[logoIdx].isSolved = true;

            if (LogosList.categories[catIdx!].getTotalSolvedLogos() == LogosList.categories[catIdx!].logos.length) {
                hints += LogosList.categories[catIdx!].logos.length ~/ 2;
                LogosList.storeData();
            }

            if (toGetMoreHints) {
                hints += 1;
                LogosList.storeData();

                hintsAnimation = new Tween<double>(
                    begin: hintsAnimation!.value,
                    end: hints.toDouble()
                ).animate(new CurvedAnimation(
                    curve: Curves.fastOutSlowIn,
                    parent: hintsController!
                ));
                hintsController!.forward(from: 0.0);
            }

            LogosList.storeData();
        }
        
        setState(() { });

        Future.delayed(const Duration(milliseconds: 1000), () {
            if (areAllLogosSolved) {
                if (correctLogoTitle!.toUpperCase().compareTo(placedLetters.join('').toString()) == 0) {
                    allSolvedListToExclude.add(logoIdx);
                    if (allSolvedListToExclude.length > LogosList.categories[catIdx!].highScore) {
                        LogosList.categories[catIdx!].highScore = allSolvedListToExclude.length;
                    }
                    LogosList.storeData();
                    if (allSolvedListToExclude.length == LogosList.categories[catIdx!].logos.length) {
                        Navigator.of(context).pop(true);
                        return;
                    }
                } else {
                    allSolvedListToExclude = [];
                }
            }
            
            logoIdx = -1;
            selectedResponseIdx = -1;
            answersTitlesList = [];
            answers = [];
            answersTitles = {};
            availableLetters = [];
            placedLetters = [];
            hiddenLetters = [];
            hiddenLetterIndxs = [];
            isHalfSolved = false;

            if (!isCurrLogoSolved && (areAllLogosSolved || LogosList.categories[catIdx!].getTotalSolvedLogos() < LogosList.categories[catIdx!].logos.length)) {
                initRandomGameMode();
            } else {
                Navigator.of(context).pop(true);
            }
        });
    }
}

class LogoQuery extends StatefulWidget {
    final int catIdx;
    final int logoIdx;

    LogoQuery({ Key? key, required this.catIdx, required this.logoIdx }) : super(key: key);
    
	@override
	State createState() => LogoState();
}