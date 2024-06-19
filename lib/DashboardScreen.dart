import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkify_bem/listingPageFiles/StudentsListingPage.dart';
import 'package:turkify_bem/listingPageFiles/TutorsListingPage.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';
import 'package:turkify_bem/mainTools/imagedButton.dart';
import 'package:turkify_bem/readingPage/screens/home/CategoryScreen.dart';
import 'package:turkify_bem/settingsPageFiles/settingsPageStudent.dart';
import 'package:turkify_bem/settingsPageFiles/settingsPageTutor.dart';
import 'package:turkify_bem/videoMeetingFiles/videoMeetingMain.dart';
import 'package:turkify_bem/wordCardFiles/wordCards.dart';

import 'cardSlidingScreenFiles/cardSlider.dart';
import 'dictionaryPageFiles/WordMeaningPage.dart';
import 'filterPageFiles/FilterPage.dart';
import 'listingPageFiles/presentation/pages/home/view/TutorsPresentation.dart';
import 'loginMainScreenFiles/transition_route_observer.dart';
import 'loginMainScreenFiles/widgets/fade_in.dart';
import 'loginMainScreenFiles/widgets/round_button.dart';
import 'mainTools/progressBar.dart';
import 'notificationFiles/Notification.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/auth')
        .then((_) => false);
  }

  final routeObserver = TransitionRouteObserver<PageRoute?>();
  static const headerAniInterval = Interval(.1, .3, curve: Curves.easeOut);
  late Animation<double> _headerScaleAnimation;
  AnimationController? _loadingController;
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> _userData = {};
  bool _isBeingCalled = false;
  Map<String, dynamic> _callerData = {};
  String _callerName = "";
  bool _isLoadingCall = true;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _callStream;
  Map<String, bool> isReadMap = {};
  bool _isTutor = false;
  bool _isThereTutor = false;

  @override
  void initState() {
    super.initState();
    gettUserData();
    _createIsRead();
    _listenToCallField();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
      value: 1,
    );

    _headerScaleAnimation = Tween<double>(begin: .6, end: 1).animate(
      CurvedAnimation(
        parent: _loadingController!,
        curve: headerAniInterval,
      ),
    );

    _checkIfBeingCalled();

    NotificationMethods().requestPermissions();
    NotificationMethods().initNotification(user!);
  }

  Future<void> _listenToCallField() async {
    _callStream = FirebaseFirestore.instance
        .collection('currentCalls')
        .where('calleeId', isEqualTo: user!.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _isBeingCalled = true;
        isBeingCalled(user!.uid);
      } else {
        _isBeingCalled = false;
      }
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
      this,
      ModalRoute.of(context) as PageRoute<dynamic>?,
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController!.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() => _loadingController!.forward();

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await FirebaseAuth.instance.signOut();
  }

  AppBar _buildAppBar(ThemeData theme) {
    final text = Text(
      "Turkify",
      style: TextStyle(
        color: textColor(),
        fontSize: 24,
        fontFamily: 'Pacifico',
      ),
    );

    return AppBar(
      title: FadeIn(
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
          child: text,
        ),
      backgroundColor: backGroundColor(),
      elevation: 0,
      leading: null,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildHeader(ThemeData theme) {
    String firstName = _userData['name'] ?? "Name";
    // String lastName = _userData['surname'] ?? "Surname";

    DateTime now = DateTime.now();
    int currentHour = now.hour;

    int index = 0;
    if (currentHour >= 6 && currentHour < 12) {
      index = 0;
    } else if(currentHour >= 12 && currentHour < 14.30){
      index = 1;
    } else if(currentHour >= 14.30 && currentHour < 23){
      index = 2;
    } else {
      index = 3;
    }

    List<String> welcomingWords = [
      'Good morning',
      'Good afternoon',
      'Good evening',
      'Good night',
    ];

    String welcoming = welcomingWords[index];

    return ScaleTransition(
      scale: _headerScaleAnimation,
      child: FadeIn(
        controller: _loadingController,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.bottomToTop,
        offset: .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        // color: Colors.black.withOpacity(0.1),
                        color: Colors.black.withOpacity(0),
                        spreadRadius: 5,
                        blurRadius: 30,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                      // color: welcomeColor(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          welcoming,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displaySmall!.copyWith(
                            fontWeight: FontWeight.w300,
                            color: textColor(),
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          firstName,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displaySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: textColor(),
                            fontSize: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    String? label,
    required Interval interval,
    required String identifier,
    required iconColor,
  }) {
    _loadingController!.forward();
    return RoundButton(
    icon: Icon(
      icon,
      color: iconColor,
    ),
    label: label,
    loadingController: _loadingController,
    interval: Interval(
      interval.begin,
      interval.end,
      curve: const ElasticOutCurve(0.42),
    ),
    isRead: isReadMap.values.contains(false) && identifier == 'chat',
    onPressed: () async {
      if (identifier == 'chat') {
        _loadingController!.reverse();
        await Future.delayed(const Duration(milliseconds: 1295));
        Navigator.push(
          context,
          MaterialPageRoute(
            // builder: (context) => ReviewPage(tutorUid: 'fNRxolmhX2dY2HcwEyJOCaamc7U2'),
            builder: (context) => WordCards(),
          ),
        );
      } else if (identifier == 'calendar') {
        _loadingController!.reverse();
        await Future.delayed(const Duration(milliseconds: 1300));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScaffoldWidget(
              title: '',
              child: FilterPage(userData: _userData),
            ),
          ),
        );
      } else if (identifier == 'match') {
        _loadingController!.reverse();
        await Future.delayed(const Duration(milliseconds: 1300));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Roboto',
            ),
            home: DictionaryPage(),
            ),
          ),
        );
      }
      else if (identifier == 'profile') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScaffoldWidget(
              title: 'Kelime Kartları',
              child: Container(),
            ),
          ),
        );
      }
      else if (identifier == 'settings') {
        _loadingController!.reverse();
        await Future.delayed(const Duration(milliseconds: 1300));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _isTutor ? SettingsPageTutor() : SettingsPageStudent(),
          ),
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const ScaffoldWidget(
        //       title: '',
        //       child: FilterPage(),
        //     ),
        //   ),
        // );
      }
    },
            );
  }

  Widget _buildDashboardGrid() {
    const step = 0.04;
    const aniInterval = 0.75;

    Color iconColor = Colors.white;

    return GridView.count(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
      ),
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.4,
      // crossAxisSpacing: 5,
      crossAxisCount: 3,
      children: [
        // _buildButton(
        //   icon: FontAwesomeIcons.user,
        //   label: 'Profile',
        //   interval: const Interval(0, aniInterval),
        //   identifier: 'profile',
        //   iconColor: iconColor,
        // ),
        _buildButton(
          icon: FontAwesomeIcons.comments,
          label: 'Group Chat',
          interval: const Interval(step, aniInterval + step),
          identifier: 'chat',
          iconColor: iconColor,
        ),
        // _buildButton(
        //   icon: FontAwesomeIcons.calendar,
        //   label: 'Calendar',
        //   interval: const Interval(step * 2, aniInterval + step * 2),
        //   identifier: 'calendar',
        //   iconColor: iconColor,
        // ),
        // _buildButton(
        //   icon: FontAwesomeIcons.listCheck,
        //   label: 'Tasks',
        //   interval: const Interval(0, aniInterval),
        //   identifier: 'task',
        //   iconColor: iconColor,
        // ),
        _buildButton(
          icon: FontAwesomeIcons.personMilitaryToPerson,
          label: 'Match',
          interval: const Interval(step * 2, aniInterval + step * 2),
          identifier: 'match',
          iconColor: iconColor,
        ),
        _buildButton(
          icon: FontAwesomeIcons.sliders,
          label: 'Settings',
          interval: const Interval(step * 2, aniInterval + step * 2),
          identifier: 'settings',
          iconColor: iconColor,
        ),
      ],
    );
  }

  Future<String?> isBeingCalled(String userId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    var callSnapshot = await db
        .collection('currentCalls')
        .where('calleeId', isEqualTo: userId)
        .get();

    if (callSnapshot.docs.isNotEmpty) {
      for (var doc in callSnapshot.docs) {
        var callerId = doc.data()['callerId'];
        var callerData = await getUserData(callerId);
        setState(() {
          _callerData = callerData as Map<String, dynamic>;
          _callerName = _callerData['name'];
          _isLoadingCall = false;
        });
      }
      return callSnapshot.docs.first.id;
    } else {
      setState(() {
        _isLoadingCall = false;
      });
      return null;
    }
  }

  Future<void> _checkIfBeingCalled() async {
    bool beingCalled = (await isBeingCalled(user!.uid)) as bool;
    _isBeingCalled = beingCalled;
    setState(() {});
  }

  @override
  Widget build(context) {
    final theme = Theme.of(context);
    return PopScope(
      onPopInvoked: (hasPopped) => hasPopped ? _goToLogin(context) : null,
      child: SafeArea(
        child: Scaffold(
          // appBar: _buildAppBar(theme),
          body: Container(
            color: backGroundColor(),
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Stack(
                        children: [
                          _buildHeader(theme),
                          Positioned.fill(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: _isBeingCalled ? 5.0 : 0.0, sigmaY:  _isBeingCalled ? 5.0 : 0.0), // Adjust sigma values for blur intensity
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _isLoadingCall ?
                    SizedBox(
                      width: 100,
                      height: 113,
                      child: Transform.scale(
                        scale: 0.3,
                        child: CircularProgressIndicator(
                          strokeWidth: 13,
                          valueColor: AlwaysStoppedAnimation<Color>(baseDeepColor),
                        ),
                      ),
                    )
                        :
                    _buildImagedButton(
                      imagePath: _isBeingCalled
                          ? "assets/callGreen.png"
                          : "assets/tutorsListingPage/yourTutorsMain.png",
                      buttonText: _isBeingCalled ?
                      "$_callerName\nis calling you"
                          :
                      _isTutor ? "STUDENTS" : "TUTORS",
                      onTap: () async {
                        _loadingController!.reverse();
                        await Future.delayed(const Duration(milliseconds: 1300));
                        if (_isBeingCalled) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoMeetingPage(calleeId: user!.uid),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                !_isTutor ? (_isThereTutor ? TutorsListingPage() : const TutorsPresentation()) : StudentsListingPage(),
                            ),
                          );
                        }
                      },
                      animationController: _loadingController!,
                    ),
                    SizedBox(height: 50,),
                    // ProgressBar(highlightedButton: 2,),
                    const SizedBox(height: 50),
                    Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: _buildDashboardGrid(),
                        ),
                        ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: _isBeingCalled ? 5 : 0.0, sigmaY: _isBeingCalled ? 5 : 0.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> getUserData(String documentId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(documentId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
        userSnapshot.data() as Map<String, dynamic>;
        return userData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return null;
    }
  }

  void gettUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    Map<String, dynamic> userData =
        (userDoc.data() as Map<String, dynamic>);
    _userData = userData;
    if(_userData['isTutor'] != null) {
      _isTutor = _userData['isTutor'];
    }
    if(_userData['friends'] != null && _userData['friends'].isNotEmpty){
      _isThereTutor = true;
    }
    setState(() {
    });
  }

  Widget _buildImagedButton({
    required String imagePath,
    required String buttonText,
    required void Function() onTap,
    required AnimationController animationController,
  }) {
    return FadeIn(
      controller: animationController,
      curve: headerAniInterval,
      fadeDirection: FadeDirection.bottomToTop,
      offset: .5,
      child: ImagedButton(
        imagePath: imagePath,
        buttonText: buttonText,
        onTap: onTap,
        letterSpacing: 2.5,
        isCall: _isBeingCalled,
      ),
    );
  }

  void _createIsRead() async {
    final messagesCollection = FirebaseFirestore.instance.collection('messages');
    messagesCollection.snapshots().listen((snapshot) {
      snapshot.docs.forEach((doc) {
        final data = doc.data();
        if (data.containsKey('isRead')) {
          final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
          final docId = doc.id;
          final halfLength = docId.length ~/ 2;

          String key;
          if (docId.startsWith(userId)) {
            key = docId.substring(halfLength);
            setState(() {
              if (data['isRead'] == 1) {
                isReadMap[key] = false;
              } else {
                isReadMap[key] = true;
              }
            });
          } else {
            key = docId.substring(0, halfLength);
            setState(() {
              if (data['isRead'] == 2) {
                isReadMap[key] = false;
              } else {
                isReadMap[key] = true;
              }
            });
          }
        }
      });
    });
  }
}
