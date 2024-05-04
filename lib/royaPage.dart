import 'package:flutter/material.dart';
import 'package:free_english_dictionary/free_english_dictionary.dart';
import 'package:simplytranslate/simplytranslate.dart';

class royasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Bar Example'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(),
          ),
          Expanded(
            child: Center(
              child: Text('content'),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search',
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              String searchText = _controller.text;
              print(printMyWord(searchText));
            },
          ),
        ],
      ),
    );
  }

  Future<String> printMyWord(String word) async {
    // CHECK meanings by printing, understand its structure.
    final st = SimplyTranslator(EngineType.google);
    var tr = await st.translateSimply(
        word,
        from: 'tr',
        to: 'en',
        instanceMode: InstanceMode.Loop,
        retries: 4);
    print("%%%%%%%%%%%%%%%%%%%");
    var meanings = await FreeDictionary.getWordMeaning(word: tr.translations.text);
    print(meanings[0].meanings?[0].definitions?[0].definition);
    print("%%%%%%%%%%%%%%%%%%%");
    var stTransl = await st.translateSimply(
        meanings[0].meanings?[0].definitions?[0].definition as String,
        from: 'en',
        to: 'tr',
        instanceMode: InstanceMode.Loop,
        retries: 4);
    print(stTransl.translations.text);
    print("%%%%%%%%%%%%%%%%%%%");
    return stTransl.translations.text;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
