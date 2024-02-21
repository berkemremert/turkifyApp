import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turkify_bem/groupChatScreen.dart';
import 'package:turkify_bem/personList.dart';
import 'package:turkify_bem/taskCalendarScreenFiles/taskScreenBase.dart';
import 'calendarFiles/calendarScreen.dart';
import 'cardSlidingScreenFiles/cardSlider.dart';
import 'cardSlidingScreenFiles/src/SwiperPage.dart';
import 'listingPageFiles/listingScreen.dart';
import 'loginMainScreenFiles/transition_route_observer.dart';
import 'loginMainScreenFiles/widgets/fade_in.dart';
import 'loginMainScreenFiles/widgets/round_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation = Tween<double>(begin: .6, end: 1).animate(
      CurvedAnimation(
        parent: _loadingController!,
        curve: headerAniInterval,
      ),
    );
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

  AppBar _buildAppBar(ThemeData theme) {
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.rightFromBracket),
      color: Colors.deepPurple,
      onPressed: () => _goToLogin(context),
    );

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
    final primaryColor =
        Colors.primaries.where((c) => c == theme.primaryColor).first;
    final accentColor =
        Colors.primaries.where((c) => c == theme.colorScheme.secondary).first;
    final linearGradient = LinearGradient(
      colors: [
        primaryColor.shade800,
        primaryColor.shade200,
      ],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 418.0, 78.0));

    List<String> nameParts = currentUser.name.split(' ');

    String firstName = '';
    String lastName = '';

    for (int i = 0; i < nameParts.length; i++) {
      if (i != nameParts.length - 1) {
        if(i == nameParts.length - 2){
          firstName += nameParts[i];
        }
        else {
          firstName += nameParts[i] + ' ';
        }
      }
      else{
        lastName = nameParts[i];
      }
    }

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
                Text(
                  firstName + '\n' + lastName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    Widget? icon,
    String? label,
    required Interval interval,
    required String identifier,
  }) {
    return RoundButton(
      icon: icon,
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: const ElasticOutCurve(0.42),
      ),
      onPressed: () {
        if (identifier == 'chat') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatPage()),
          );
        } else if (identifier == 'calendar') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalendarScreen()),
          );
        } else if (identifier == 'task'){
          taskScreenCalendarMain();
        } else if (identifier == 'match'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScaffoldWidget(
              child: listingScreen(),
              title: "",
            ),),
          );
        } else if (identifier == 'profile'){
          //FILL HERE -BERK
        } else if (identifier == 'settings'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScaffoldWidget(
              child: SwiperPage(),
              title: "Kelime Kartları",
            ),),
          );
        }
      },
    );
  }

  Widget _buildDashboardGrid() {
    const step = 0.04;
    const aniInterval = 0.75;

    return GridView.count(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 100,
      ),
      childAspectRatio: .9,
      // crossAxisSpacing: 5,
      crossAxisCount: 3,
      children: [
        _buildButton(
          icon: const Icon(FontAwesomeIcons.user),
          label: 'Profile',
          interval: const Interval(0, aniInterval),
          identifier: 'profile'
        ),
        _buildButton(
          icon: Container(
            // fix icon is not centered like others for some reasons
            padding: const EdgeInsets.only(left: 16.0),
            alignment: Alignment.centerLeft,
            child: const Icon(
              FontAwesomeIcons.comments,
              size: 20,
            ),
          ),
          label: 'Group Chat',
          interval: const Interval(step, aniInterval + step),
          identifier: 'chat'
        ),
        _buildButton(
          icon: const Icon(FontAwesomeIcons.calendar),
          label: 'Calendar',
          interval: const Interval(step * 2, aniInterval + step * 2),
          identifier: 'calendar'
        ),
        _buildButton(
          icon: const Icon(FontAwesomeIcons.listCheck),
          label: 'Tasks',
          interval: const Interval(0, aniInterval),
          identifier: 'task'
        ),
        _buildButton(
          icon: const Icon(FontAwesomeIcons.personMilitaryToPerson),
          label: 'Match',
          interval: const Interval(step * 2, aniInterval + step * 2),
          identifier: 'match'
        ),
        _buildButton(
          icon: const Icon(FontAwesomeIcons.sliders, size: 20),
          label: 'Settings',
          interval: const Interval(step * 2, aniInterval + step * 2),
          identifier: 'settings'
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
            onPressed: ()  => _loadingController!.value == 0
                ? _loadingController!.forward()
                : _loadingController!.reverse(),
            child: const Text('loading', style: textStyle),
          ),
        ],
      ),
    );
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
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 60),
                    Expanded(
                      flex: 5,
                      child: _buildHeader(theme),
                    ),
                    Expanded(
                      flex: 10,
                      child: ShaderMask(
                        // blendMode: BlendMode.srcOver,
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Colors.deepPurpleAccent.shade100,
                              Colors.deepPurple.shade100,
                              Colors.deepPurple.shade100,
                              Colors.deepPurple.shade100,
                              // Colors.red,
                              // Colors.yellow,
                            ],
                          ).createShader(bounds);
                        },
                        child: _buildDashboardGrid(),
                      ),
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
}
