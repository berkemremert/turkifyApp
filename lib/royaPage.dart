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
//
// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search Bar Example'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SearchBar(),
//           ),
//           Expanded(
//             child: Center(
//               child: Text('content'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class SearchBar extends StatefulWidget {
//   @override
//   _SearchBarState createState() => _SearchBarState();
// }
//
// class _SearchBarState extends State<SearchBar> {
//   TextEditingController _controller = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 hintText: 'Search',
//                 contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               String searchText = _controller.text;
//               print(printMyWord(searchText));
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<String> printMyWord(String word) async {
//     // CHECK meanings by printing, understand its structure.
//     final st = SimplyTranslator(EngineType.google);
//     var tr = await st.translateSimply(
//         word,
//         from: 'tr',
//         to: 'en',
//         instanceMode: InstanceMode.Loop,
//         retries: 4);
//     print("%%%%%%%%%%%%%%%%%%%");
//     var meanings = await FreeDictionary.getWordMeaning(word: tr.translations.text);
//     print(meanings[0].meanings?[0].definitions?[0].definition);
//     print("%%%%%%%%%%%%%%%%%%%");
//     var stTransl = await st.translateSimply(
//         meanings[0].meanings?[0].definitions?[0].definition as String,
//         from: 'en',
//         to: 'tr',
//         instanceMode: InstanceMode.Loop,
//         retries: 4);
//     print(stTransl.translations.text);
//     print("%%%%%%%%%%%%%%%%%%%");
//     return stTransl.translations.text;
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }


class MyHomePage extends StatelessWidget {
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
                ? Container(
              width: 200,
              height: 100,
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
              child: Center(
                child: Text(
                  _searchWord,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
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