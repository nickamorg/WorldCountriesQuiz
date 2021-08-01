import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:worldcountriesquiz/AdManager.dart';

enum GameMode { EASY, NORMAL, HARD }

enum GameQuiz { CAPITAL, CONTINENT, SHAPE, POPULATION, FLAG, COLORS, ISO, LANDLOCKED, RELIGION, LANGUAGE, NEIGHBORS }

const List<String> CONTINENTS = ['Africa', 'Asia', 'Europe', 'North America', 'Oceania', 'South America'];

const List<String> RELIGIONS = ['Christianity', 'Islam', 'Judaism', 'Buddhism', 'Hinduism', 'Atheism', 'Folk'];

const List<String> COLORS = ['Black', 'Blue', 'Green', 'Red', 'White', 'Yellow', 'Orange'];

List<GameQuiz> easyQuiz = [ GameQuiz.SHAPE, GameQuiz.CONTINENT, GameQuiz.LANDLOCKED, GameQuiz.RELIGION ];
List<GameQuiz> normalQuiz = List.from(easyQuiz)..addAll([ GameQuiz.CAPITAL, GameQuiz.LANGUAGE, GameQuiz.FLAG, GameQuiz.ISO ]);
List<GameQuiz> hardQuiz = List.from(normalQuiz)..addAll([ GameQuiz.COLORS, GameQuiz.NEIGHBORS, GameQuiz.POPULATION ]);

class ModeDifficulty extends StatelessWidget {
    final Function event;
    final String? txt;

    ModeDifficulty({required this.event, this.txt});

    @override
    Widget build(BuildContext context) {
        return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child: Container(
                height: txt != null ? 40 : 88,
                width:  txt != null ? 80 : 40,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    border: Border.all(
                        color: Color(0xFF0FBEBE),
                        width: 1
                    )
                ),
                child: TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0)
                    ),
                    onPressed: () {
                        int posibilityRange = 4;

                        switch(txt) {
                            case 'Easy': {
                                posibilityRange = 12;
                                break;
                            }
                            case 'Normal': {
                                posibilityRange = 8;
                                break;
                            }
                        }

                        if (Random().nextInt(posibilityRange) == 3) {
                            AdManager.showInterstitialAd();

                            Future.delayed(Duration(milliseconds: 2000), () {
                                event();
                            });
                        } else {
                            event();
                        }
                    },
                    child: Center(
                        child: txt != null ? Text(
                            txt!,
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF0FBEBE)
                            )
                        ) : SvgPicture.asset(
                            'assets/devil.svg',
                            height: 25
                        )
                    )
                )
            )
        );
    }
}

class Star extends StatelessWidget {
    final double height;
    
    Star({this.height = 30});

    @override
    Widget build(BuildContext context) {
        return SvgPicture.asset(
            'assets/star.svg',
            height: height
        );
    }
}


    Widget getCountryCardTitle(String title) {
        return Padding(
            padding: EdgeInsets.all(10),
            child: Center(
                child: FittedBox(
                  child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 30,
                            color: Color(0xFF0FBEBE),
                            fontWeight: FontWeight.bold
                        )
                    )
                )
            )
        );
    }