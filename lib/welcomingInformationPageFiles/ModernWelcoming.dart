import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';

class ModernWelcoming extends StatefulWidget {
  const ModernWelcoming({Key? key}) : super(key: key);

  @override
  State<ModernWelcoming> createState() => _ModernWelcomingState();
}

class _ModernWelcomingState extends State<ModernWelcoming> {
  late TextEditingController _textController;
  late FocusNode _textFieldFocusNode;
  bool _switchValue = false;
  late CarouselController _carouselController;
  int _carouselCurrentIndex = 1;
  List<String>? _dropDownValue1;
  List<String>? _dropDownValue2;
  List<String>? _dropDownValue3;
  List<String>? _dropDownValue4;
  List<String>? _choiceChipsValues;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: 'Write here...');
    _textFieldFocusNode = FocusNode();
    _carouselController = CarouselController();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_textFieldFocusNode.canRequestFocus) {
          FocusScope.of(context).requestFocus(_textFieldFocusNode);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: baseDeepColor,
          automaticallyImplyLeading: false,
          title: const Text(
              'We want to get to know you!',
          ),
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(height: 35),
                const Align(
                  alignment: Alignment.center,
                  child: Text('Which account type is better for you?'),
                ),
                Container(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Student'),
                      Switch.adaptive(
                        value: _switchValue,
                        onChanged: (newValue) {
                          setState(() {
                            _switchValue = newValue;
                          });
                        },
                        activeTrackColor: const Color(0xA8FF9192),
                        inactiveTrackColor: const Color(0xA8ED0E10),
                        inactiveThumbColor: Colors.white,
                      ),
                      const Text('Tutor'),
                    ],
                  ),
                ),
                Container(height: 35),
                Align(
                  alignment: Alignment.center,
                  child: const Text('What can you say about yourself?'),
                ),
                Container(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _textController,
                    focusNode: _textFieldFocusNode,
                    onChanged: (_) => setState(() {}),
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Label here...',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xA8ED0E10),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xA8ED0E10),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    maxLines: null,
                    minLines: 3,
                  ),
                ),
                Container(height: 35),
                Align(
                  alignment: Alignment.center,
                  child: const Text('What is your language proficiency?'),
                ),
                Container(height: 10),
                Container(
                  height: 60,
                  child: CarouselSlider(
                    items: [
                      // DropDown Widgets here
                    ],
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      initialPage: 1,
                      viewportFraction: 0.5,
                      disableCenter: true,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.25,
                      enableInfiniteScroll: true,
                      scrollDirection: Axis.horizontal,
                      autoPlay: false,
                      onPageChanged: (index, _) {
                        setState(() {
                          _carouselCurrentIndex = index;
                        });
                      },
                    ),
                  ),
                ),
                Container(height: 35),
                Align(
                  alignment: Alignment.center,
                  child: const Text(
                    'What are your interests?',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      letterSpacing: 0,
                    ),
                  ),
                ),
                Container(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    // Choice Chips Widget here
                  ),
                ),
                Container(height: 35),
                ElevatedButton(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  child: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xA8ED0E10),
                    textStyle: TextStyle(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
