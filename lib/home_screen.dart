import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';
import 'dart:math';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _random = Random();
  final webScraper = WebScraper('https://www.urbandictionary.com');
  // final webScraper = WebScraper('https://corsproxy.io/?https%3A%2F%2Fwww.urbandictionary.com');
  String? answer_1;  
  String? answer_2;
  String? answer_3;
  String? description_1;
  String? description_2;
  String? description_3;
  String? correctAnswer;
  String? correctDescription;
  String? showenDescription;
  String? chosenAnswer;
  String? answerMessage;
  bool loaded = false;
  String? favSelected;
  var selectedIndex = 0;
  final Map<String, String> favoritesDict = {};
  Map<String, String> answersDict = {};
  // List history = <Map> [];

  // checkAnswer() {
  //   chosenAnswer == correctAnswer ? 
  //     const Text('Correct!') : const Text('False!');
  // }

  void pickAnswer(chosenAnswer) {
    setState(() {
      this.chosenAnswer = chosenAnswer;
      // print('Answer has been chosen!');
      // notifyListeners();
      chosenAnswer == correctAnswer ? 
        answerMessage = 'Correct!':
        answerMessage = 'False!';
    });
  }
  void setCorrectAnswer(correctAnswer) {
    this.correctAnswer = correctAnswer;
    print('correctAnswer has been set!');
    // notifyListeners();
  }
  // getrandomNumberCorrect() {
  //   int randomNumberCorrect = _random.nextInt(3);
  //   return randomNumberCorrect;
  //   // notifyListeners();
  // }

  void toggleFavorite(String urbanWordKey) {
    setState(() {
      // String urbanWordKey = urbanWord.keys.toList().first;
      String urbanWordValue = answersDict[urbanWordKey] ?? '';
      // Map<String, String> urbanWord = {urbanWordKey: urbanWordValue};

      if (favoritesDict.containsKey(urbanWordKey)) {
        favoritesDict.remove(urbanWordKey);
        // someMap.update("a", (value) => value + 100);
        // favorites.remove(urbanWord);
        print('Remove from Favorites : $urbanWordKey');
      } else {
        // favorites.add(urbanWord);
        favoritesDict[urbanWordKey] = urbanWordValue;
        print('Add to Favorites : $urbanWordKey');
      }
      // print(this.favorites);
    });
  }

  void removeFavorite(String urbanWordKey) {
    setState(() {
      favoritesDict.remove(urbanWordKey);
    });
  }

  void getWords() async {
    int randomNumberPage = _random.nextInt(925);
    print(randomNumberPage);
    if (await webScraper.loadWebPage('/?page=$randomNumberPage')) {
    // if (await webScraper.loadWebPage('%2F%3Fpage%3D$randomNumberPage')) {
      setState(() {
        int pageLength = webScraper.getElement('.word.text-denim', ['href']).length;

        var randomPicker = List<int>.generate(pageLength, (i) => i + 1)..shuffle();

        int random1 = randomPicker.removeLast()-1;
        int random2 = randomPicker.removeLast()-1;
        int random3 = randomPicker.removeLast()-1;

        print([random1,random2,random3]);
        // print(randomPicker);

        answer_1 = webScraper.getElement('.word.text-denim', ['href'])[random1]['title'];
        description_1 = webScraper.getElement('.break-words.meaning', ['href', 'title'])[random1]['title'];
        answer_2 = webScraper.getElement('.word.text-denim', ['href'])[random2]['title'];
        description_2 = webScraper.getElement('.break-words.meaning', ['href', 'title'])[random2]['title'];
        answer_3 = webScraper.getElement('.word.text-denim', ['href'])[random3]['title'];
        description_3 = webScraper.getElement('.break-words.meaning', ['href', 'title'])[random3]['title'];

        int randomNumberCorrect = _random.nextInt(3);

        answersDict = {
          answer_1 as String: description_1 as String, 
          answer_2 as String: description_2 as String, 
          answer_3 as String: description_3 as String
          };

        // List<String> answers_list = answers_dict.entries.toList();
        correctAnswer = answersDict.entries.toList()[randomNumberCorrect].key;
        correctDescription = answersDict[correctAnswer];
        showenDescription = answersDict[correctAnswer];

        loaded = true;
        answerMessage = null;
        chosenAnswer = null;
      });
    }
  }

  void updateShowenDescription (description) {
    setState(() {
      showenDescription = description;
    });
  }

  void checkFavSelected(String favoriteWord) {
    setState(() {
      if (favSelected == favoriteWord) {
      favSelected = null;} 
      else {
      favSelected = favoriteWord;}
      });
  }

  drawerContent() {
    return SafeArea(
      child: NavigationRail(
        extended: true, //constraints.maxWidth >= 600,
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.home),
            label: Text('Home'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.favorite),
            label: Text('Favorites'),
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
    );
  }

  containerDescription () {
    return  Padding(
        padding: const EdgeInsets.all(20.0),
        child: 
      showenDescription == correctDescription ?
      Container(
          padding: const EdgeInsets.all(15),
          child: Text(showenDescription ?? ''),
      ) :
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red[100] as Color, width: 4),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: 
            Text(showenDescription ?? ''),
            // Text(showenDescription ?? '', style: TextStyle(color: Colors.red[900])),
        // Text("Surrounded by a border"),
      ));
  }

  answerCard (String answer) {

    String answersDescription = answersDict[answer] ?? '';
    // Map<String, String> answersMap = {answer: answersDescription};

    // print(answersMap);

    IconData icon;
    if (favoritesDict.containsKey(answer)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }


    return chosenAnswer == null ?
      Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                child: Text(answer),
                onPressed: () {
                  // chosenAnswer = answer_2;
                  // setCorrectAnswer(correctAnswer);
                  pickAnswer(answer);
                },
              ),
            ],
          ) :
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: 
                    answer == correctAnswer ?
                      Border.all(color: Colors.limeAccent[100] as Color, width: 4) :
                      Border.all(color: Colors.red[100] as Color, width: 4), //Border.all(color: Colors.blue, width: 4),
                  borderRadius: BorderRadius.circular(20.0),
                  // color: Colors.yellow,
                  // shape: BoxShape.circle,
                ),
                child: ElevatedButton(
                  onPressed: null,
                  child: Text(answer),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      toggleFavorite(answer);
                      // print(answersMap);
                      // if      (answer == answer_1) { updateShowenDescription(description_1); } 
                      // else if (answer == answer_2) { updateShowenDescription(description_2); }
                      // else if (answer == answer_3) { updateShowenDescription(description_3); }
                    },
                    icon: Icon(
                      icon,
                      size: 18.0,
                      color: Colors.deepPurple,
                    ),
                  ),
                  // const SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      updateShowenDescription(answersDescription);
                    },
                    icon: const Icon(
                      Icons.question_mark_rounded,
                      size: 18.0,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              )
            ],
          );
  }

  mainPage () {
    return SafeArea(
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(child: 
                    containerDescription(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  answerCard(answer_1 ?? ''),
                  const SizedBox(width: 10),
                  answerCard(answer_2 ?? ''),
                  const SizedBox(width: 10),
                  answerCard(answer_3 ?? ''),
                ],
              ),
            ),
            // const AnswerCard(),
            chosenAnswer == null? 
              const Spacer(
                flex: 2,
              )
              : Expanded(
              flex: 2,
              child: Container(
                color:
                answerMessage == 'Correct!' ?
                  Colors.limeAccent[100] :
                  Colors.red[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(answerMessage ?? '', 
                      style: TextStyle(
                        // height: 5, 
                        fontSize: 32,
                        color:
                        answerMessage == 'Correct!' ?
                          Colors.green[900] :
                          Colors.red[900],//.withOpacity(0.85),
                        fontWeight: FontWeight.bold
                        ),
                    ),
                    const SizedBox(width: 25),
        
                      ElevatedButton(
                        child: const Text('Next!'),
                        onPressed: () {
                          getWords();
                        },
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  favoritesPage(){
    if (favoritesDict.isEmpty) {
      return const Center(
        child: Text('No favorites yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('You have '
              '${favoritesDict.length} favorites:'),
        ),
        Expanded(
          // Make better use of wide windows with a grid.
          flex: 4,
          child: GridView(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 400 / 80,
            ),
            children: [
              for (var favoriteWord in favoritesDict.keys.toList())
                ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    // color: theme.colorScheme.primary,
                    onPressed: () {
                      removeFavorite(favoriteWord);
                    },
                  ),
                  title: Text(
                    favoriteWord,
                    semanticsLabel: favoriteWord,
                  ),
                  onTap: () {
                    checkFavSelected(favoriteWord);
                    // print(1);
                  },
                ),
            ],
          ),
        ),
        favSelected != null ?
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1),
                // color: Theme.of(context).colorScheme.secondaryContainer,
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(favoritesDict[favSelected ?? ''] ?? '')),
          ), //Text(favoritesDict[favSelected]),
        ) :
        const Text(''),
      ],
    );
//   }
// }
  }

  @override
  void initState() {
    super.initState();
    // Requesting to fetch before UI drawing starts    
    getWords();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    // var appState = context.watch<AppStates>();

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = mainPage();
        break;
      case 1:
        page = favoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.primaryContainer, //colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );


    // print(answer_1);

    return loaded == false // answer_1 == null
    ? const Center(
        child:
            CircularProgressIndicator(), // Loads Circular Loading Animation
      )
    : 
    Scaffold(
        appBar: AppBar(
          title: const Text('Urban Dictionary Quiz'),
          backgroundColor: colorScheme.primary, // Colors.deepPurple,
        ),
        drawer: Drawer(
          child: drawerContent(),
        ),
        body: LayoutBuilder(
        builder: (context, constraints) {
          return mainArea; //favoritesPage(); // mainPage(); //Expanded(child: mainPage()); // mainArea
        }),
      );
}
}
