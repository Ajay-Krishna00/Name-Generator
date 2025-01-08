import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Name Generator',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 255, 34, 240)),
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var prev = [];
  var delay = [];
  var favorites = <WordPair>[];

  MyAppState() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final savedFavorites = await loadFavoriteNames();
    favorites = savedFavorites
        .map((name) => WordPair(name.split(' ')[0], name.split(' ')[1]))
        .toList();
    notifyListeners();
  }

  void getNext() {
    prev.add(current);
    if (delay.isNotEmpty) {
      current = delay.last;
      delay.removeLast();
    } else {
      current = WordPair.random();
    }
    notifyListeners();
  }

  void toggleLike() async {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    // Save the updated favorites list
    await saveFavoriteNames(
        favorites.map((pair) => '${pair.first} ${pair.second}').toList());
    notifyListeners();
  }

  Future<List<String>> loadFavoriteNames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorite_names') ?? [];
  }

  Future<void> saveFavoriteNames(List<String> names) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_names', names);
  }

  void getPrev() {
    if (prev.isNotEmpty) {
      delay.add(current);
      current = prev.last;
      prev.removeLast();
      notifyListeners();
    }
  }

  void removeFavorites(WordPair pair) async {
    favorites.remove(pair);
    // Save the updated favorites list after removal
    await saveFavoriteNames(
        favorites.map((pair) => '${pair.first} ${pair.second}').toList());
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() =>
      _MyHomePageState(); //"_" makes that class private and is enforced by the compiler
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GenerateNamePage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        //LayoutBuilder's builder callback is called every time the constraints change. This happens when, for example:
        // The user resizes the app's window
        // The user rotates their phone from portrait mode to landscape mode, or back
        // Some widget next to MyHomePage grows in size, making MyHomePage's constraints smaller
        // And so on
        if (constraints.maxWidth >= 500) {
          return Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 650,
                  destinations: [
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
              ),
              Expanded(child: mainArea),
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(child: mainArea),
              SafeArea(
                child: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      label: 'Favorites',
                    ),
                  ],
                  currentIndex: selectedIndex,
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              )
            ],
          );
        }
      }),
    );
  }
}

class GenerateNamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    icon = appState.favorites.contains(pair)
        ? Icons.favorite
        : Icons.favorite_border_rounded;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'A random name:',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          BigCard(pair: pair),
          SizedBox(height: 15),
          Row(
            mainAxisSize: MainAxisSize
                .min, //This tells Row not to take all available horizontal space.
            children: [
              ElevatedButton(
                onPressed: () {
                  appState.getPrev();
                },
                child: Text("Previous"),
              ),
              SizedBox(width: 13),
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleLike();
                },
                icon: Icon(icon),
                label: Text("Like"),
              ),
              SizedBox(width: 13),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appstate = context.watch<MyAppState>();
    var fav = appstate.favorites; // Load favorites

    if (fav.isEmpty) {
      return Center(
        child: Text("No favorites yet!"),
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "You have ${fav.length} favorites:",
              style: TextStyle(fontSize: 18),
            ),
          ),
          for (var i in fav)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Card(
                elevation: 5,
                child: ListTile(
                  title: Text(i.asPascalCase),
                  trailing: IconButton(
                    onPressed: () {
                      appstate.removeFavorites(i);
                    },
                    tooltip: "Remove from favorites",
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final txtTheme = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      elevation: 10,
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asPascalCase,
          style: txtTheme,
          semanticsLabel: "${pair.first} ${pair.second},",
        ),
      ),
    );
  }
}
