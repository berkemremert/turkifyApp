import 'package:flutter/material.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:free_english_dictionary/free_english_dictionary.dart';

final st = SimplyTranslator(EngineType.google);

Future<String> getDic(String word) async {
  var translation = await st.translateSimply(
    word,
    from: 'tr',
    to: 'en',
    instanceMode: InstanceMode.Loop,
    retries: 4,
  );

  var meanings = await FreeDictionary.getWordMeaning(word: translation.translations.text);
  if (meanings.isNotEmpty && meanings[0].meanings != null && meanings[0].meanings!.isNotEmpty &&
      meanings[0].meanings![0].definitions != null && meanings[0].meanings![0].definitions!.isNotEmpty) {
    var meaning = meanings[0].meanings![0].definitions![0].definition;
    var transmeaning = await st.translateSimply(
      meaning!,
      from: 'en',
      to: 'tr',
      instanceMode: InstanceMode.Loop,
      retries: 4,
    );
    return transmeaning.translations.text;
  } else {
    return "No meaning found";
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RoyaPageRoya(),
    );
  }
}

class RoyaPageRoya extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Bar Example'),
      ),
      body: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  String _searchWord = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SearchBar(
            controller: _controller,
            onSearch: () {
              setState(() {
                _searchWord = _controller.text;
              });
            },
          ),
        ),
        Expanded(
          child: Center(
            child: _searchWord.isNotEmpty
                ? FutureBuilder<String>(
              future: getDic(_searchWord),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Error: ${snapshot.error}');
                } else {
                  print(snapshot.data);
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          snapshot.data ?? '',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }
              },
            )
                : Text(
              'Enter a search term',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


class SearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSearch;

  const SearchBar({Key? key, this.controller, this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: onSearch,
          ),
        ],
      ),
    );
  }
}
