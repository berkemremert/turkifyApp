import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';
import 'package:turkify_bem/mainTools/FriendsListScreen.dart';
import 'package:turkify_bem/mainTools/imagedButton.dart';
import 'package:turkify_bem/chatScreenFiles/myChats.dart';
import 'package:turkify_bem/settingsPageFiles/settingsPage.dart';
import 'package:turkify_bem/videoMeetingFiles/videoMeetingMain.dart';

import 'filterPageFiles/FilterPage.dart';
import 'cardSlidingScreenFiles/cardSlider.dart';
import 'cardSlidingScreenFiles/src/SwiperPage.dart';
import 'listingPageFiles/listingScreen.dart';
import 'loginMainScreenFiles/transition_route_observer.dart';
import 'loginMainScreenFiles/widgets/fade_in.dart';
import 'loginMainScreenFiles/widgets/round_button.dart';
import 'videoMeetingFiles/videoMeetingMain.dart';

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

  @override
  void initState() {
    super.initState();
    gettUserData();

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
    final signOutBtn = IconButton(
        icon: const Icon(FontAwesomeIcons.rightFromBracket),
        color: baseDeepColor,
        onPressed: () {
          logOut();
          _goToLogin(context);
        });

    return AppBar(
      actions: <Widget>[
        FadeIn(
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
          child: signOutBtn,
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildHeader(ThemeData theme) {
    String firstName = _userData['name'] ?? "Name";
    String lastName = _userData['surname'] ?? "Surname";

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
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 5,
                        blurRadius: 30,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '$firstName\n$lastName',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: baseDeepColor,
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
      onPressed: () async {
        if (identifier == 'chat') {
          _loadingController!.reverse();
          await Future.delayed(Duration(milliseconds: 1295));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyChats()),
          );
        } else if (identifier == 'calendar') {
          //FILL HERE -deniz
          _loadingController!.reverse();
          await Future.delayed(Duration(milliseconds: 1300));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScaffoldWidget(
                title: '',
                child: FilterPage(),
              ),
            ),
          );
        } else if (identifier == 'task') {
          // IT'S AVAILABLE
        } else if (identifier == 'match') {
          _loadingController!.reverse();
          await Future.delayed(Duration(milliseconds: 1300));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScaffoldWidget(
                child: listingScreen(),
                title: "",
              ),
            ),
          );
        } else if (identifier == 'profile') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScaffoldWidget(
                title: 'Kelime Kartları',
                child: SwiperPage(),
              ),
            ),
          );
        } else if (identifier == 'settings') {
          _loadingController!.reverse();
          await Future.delayed(Duration(milliseconds: 1300));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScaffoldWidget(
                title: 'Settings',
                child: SettingsPage(),
              ),
            ),
          );
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
      childAspectRatio: 1,
      // crossAxisSpacing: 5,
      crossAxisCount: 3,
      children: [
        _buildButton(
          icon: FontAwesomeIcons.user,
          label: 'Profile',
          interval: const Interval(0, aniInterval),
          identifier: 'profile',
          iconColor: iconColor,
        ),
        _buildButton(
          icon: FontAwesomeIcons.comments,
          label: 'Group Chat',
          interval: const Interval(step, aniInterval + step),
          identifier: 'chat',
          iconColor: iconColor,
        ),
        _buildButton(
          icon: FontAwesomeIcons.calendar,
          label: 'Calendar',
          interval: const Interval(step * 2, aniInterval + step * 2),
          identifier: 'calendar',
          iconColor: iconColor,
        ),
        _buildButton(
          icon: FontAwesomeIcons.listCheck,
          label: 'Tasks',
          interval: const Interval(0, aniInterval),
          identifier: 'task',
          iconColor: iconColor,
        ),
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

  Widget _buildDebugButtons() {
    const textStyle = TextStyle(fontSize: 12, color: Colors.white);

    return Positioned(
      bottom: 0,
      right: 0,
      child: Row(
        children: <Widget>[
          MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Colors.red,
            onPressed: () => _loadingController!.value == 0
                ? _loadingController!.forward()
                : _loadingController!.reverse(),
            child: const Text('loading', style: textStyle),
          ),
        ],
      ),
    );
  }

  Future<String?> isBeingCalled(String userId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    var callSnapshot = await db
        .collection('currentCalls')
        .where('calleeId', isEqualTo: userId)
        .get();

    if (callSnapshot.docs.isNotEmpty) {
      return callSnapshot.docs.first.id;
    } else {
      return null;
    }
  }

  Future<void> _checkIfBeingCalled() async {
    bool beingCalled = (await isBeingCalled(user!.uid)) as bool;
    setState(() {
      _isBeingCalled = beingCalled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      onPopInvoked: (hasPopped) => hasPopped ? _goToLogin(context) : null,
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(theme),
          body: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Expanded(
                      flex: 5,
                      child: _buildHeader(theme),
                    ),
                    ImagedButton(
                        imagePath: _isBeingCalled ? "assets/callGreen.png" : "assets/callLightRed.png",
                        buttonText: _isBeingCalled ? "CALL" : "NO CALL",
                        onTap: () async {
                          _loadingController!.reverse();
                          await Future.delayed(Duration(milliseconds: 1300));
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FriendsListScreen()),
                          );
                        },
                    ),
                    const SizedBox(height: 60),
                    Expanded(
                      flex: 8,
                      child: _buildDashboardGrid(),
                    ),
                  ],
                ),
                if (!kReleaseMode) _buildDebugButtons(),
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

      // Check if the document exists
      if (userSnapshot.exists) {
        // Access the data from the document snapshot
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
        (userDoc.data() as Map<String, dynamic>) ?? {};
    setState(() {
      _userData = userData;
    });
  }
}
