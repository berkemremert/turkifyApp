import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';
import '../mainTools/firebaseMethods.dart';

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  String searchQuery = '';
  bool searched = false;
  List<dynamic> meanings = [];
  TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Map<String, dynamic> wordOfTheDay = {'word' : 'Word of The Day', 'meanings' : []};
  Map<String, dynamic> wordWithAPicture= {'word' : 'Word with a Picture', 'pictureLink' : 'link'};
  Map<String, dynamic> proverbOfTheDay = {'phrase' : 'Proverb of the Day', 'meaning' : 'Meaning of the Proverb'};

  Future<void> initAll() async {
    await initWordOfTheDay();
    await initWordWithAPicture();
    await initProverbOfTheDay();
  }

  Future<void> initWordOfTheDay() async {
    wordOfTheDay = await getWordOfTheDay(DateFormat('yyyy-MM-dd').format(DateTime.now())) as Map<String, dynamic>;
  }

  Future<void> initWordWithAPicture() async {
    wordWithAPicture = await getAnimalandPicture(DateTime.now().day.toInt()) as Map<String, dynamic>;
  }

  Future<void> initProverbOfTheDay() async {
    proverbOfTheDay = await getProverb(DateTime.now().day.toInt()) as Map<String, dynamic>;
  }

  void _onSearch() async {
    searchQuery = _searchController.text;
    var result = await getDictWordByWord(searchQuery);
    if (result != null) {
      meanings = result["meanings"];
    } else {
      meanings = [];
    }
    searched = true;
    _focusNode.unfocus();
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (query) {
                    _onSearch();
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.search, color: Colors.red),
                onPressed: _onSearch,
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<void>(
        future: initAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(
              color: baseDeepColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (searched) ...[
                      meanings.isNotEmpty
                          ? _buildMeaningsCard(meanings)
                          : _buildError(),
                      SizedBox(height: 16.0),
                    ],
                    _buildWordOfTheDayCard(),
                    SizedBox(height: 16.0),
                    _buildWordOfTheDayImage(),
                    SizedBox(height: 16.0),
                    _buildPhraseOfTheDay(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMeaningsCard(List<dynamic> meanings) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              searchQuery[0].toUpperCase() + searchQuery.substring(1),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12,),
            Text(
              'Meanings',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            ...meanings.asMap().entries.map((entry) {
              int idx = entry.key + 1;
              String meaning = entry.value;
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('$idx. $meaning'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWordOfTheDayCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Word of the Day',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red[300],
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                wordOfTheDay['word'][0].toUpperCase() + wordOfTheDay['word'].substring(1),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 5.0,
                      color: Color.fromARGB(150, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ...wordOfTheDay['meanings'].asMap().entries.map((entry) {
              int idx = entry.key + 1;
              String meaning = entry.value;
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('$idx. $meaning'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              searchQuery,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16,),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Word not found',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordOfTheDayImage() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Word with a Picture',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red[200],
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                wordWithAPicture['word'][0].toUpperCase() + wordWithAPicture['word'].substring(1),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 5.0,
                      color: Color.fromARGB(150, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                wordWithAPicture['pictureLink'],
                fit: BoxFit.cover,
                height: 200.0,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhraseOfTheDay() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Proverb of the Day',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    proverbOfTheDay['phrase'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 5.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),)
            ),
            SizedBox(height: 16.0),
            Text(
              proverbOfTheDay['meaning'],
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}