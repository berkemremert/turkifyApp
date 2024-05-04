import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';
import 'forms/dictionaryBar.dart';

class SwiperPage extends StatefulWidget {
  const SwiperPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SwiperState();
  }
}

class CardContext {
  final String text;
  final String imageLink;
  bool isTapped;

  CardContext({
    required this.text,
    required this.imageLink,
    this.isTapped = false,
  });
}

class gay extends StatelessWidget {
  const gay({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){}, child: Text("AOAO"));
  }
}

class _SwiperState extends State<SwiperPage>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _animation10;
  late Animation<double> _animation11;
  late Animation<double> _animation12;
  late Animation<double> _animation13;

  List<CardContext> words= [
    CardContext(text: "Elma", imageLink: "https://images.pexels.com/photos/206959/pexels-photo-206959.jpeg?auto=compress&cs=tinysrgb&w=800"),
    CardContext(text: "Armut", imageLink: "https://images.pexels.com/photos/7214835/pexels-photo-7214835.jpeg?auto=compress&cs=tinysrgb&w=800"),
    CardContext(text: "Karpuz", imageLink: "https://images.pexels.com/photos/5946081/pexels-photo-5946081.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
    CardContext(text: "Kokonat", imageLink: "https://images.pexels.com/photos/3986706/pexels-photo-3986706.jpeg?auto=compress&cs=tinysrgb&w=800"),

  ];

  _SwiperState();

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(vsync: this);
    _animation10 = Tween(begin: 0.0, end: 1.0).animate(controller);
    _animation11 = Tween(begin: 0.0, end: 1.0).animate(controller);
    _animation12 = Tween(begin: 0.0, end: 1.0).animate(controller);
    _animation13 = Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.animateTo(1.0, duration: const Duration(seconds: 3));
    super.initState();
  }

  Widget buildDynamicCard(CardContext word) {
    return InkWell(
      onTap: () {
        setState(() {
          word.isTapped = !word.isTapped;
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Card(
          elevation: 2.0,
          color: white,
          child: Stack(
            children: [
              if (word.isTapped == true)
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(word.imageLink),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      word.text,
                      style: TextStyle(
                        fontSize: 40,
                        color: white,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(
                            offset: const Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Container(
                  color: baseDeepColor,
                  child: Center(
                    child: Text(
                      word.text,
                      style: TextStyle(
                        fontSize: 40,
                        color: white,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(
                            offset: const Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate((c, i) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const dictionaryBar(),
                  const SizedBox(height: 20), // Adding a SizedBox for spacing
                  Text(
                    'Kelime Kartları',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: redAccent,
                    ),
                  ),
                  const SizedBox(height: 20), // Adding another SizedBox for spacing
                  SizedBox(
                    height: 400.0,
                    child: Swiper(
                      outer: true,
                      itemBuilder: (c, i) {
                        return buildDynamicCard(words[i]);
                      },
                      pagination: SwiperPagination(
                        alignment: Alignment.topCenter,
                        builder: DotSwiperPaginationBuilder(color: Colors.grey, activeColor: redAccent), //this is for the dots under the cards, I styled them
                        //alternatively you can remove them completely by using the following:
                        //builder: SwiperPagination.rect
                      ),
                      itemCount: words.length,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: SizedBox(
                          width: 150,
                          height: 60,
                          child: ElevatedButton(
                                  onPressed: (){},
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: white,
                                    backgroundColor: redAccent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                    elevation: 3,
                                  ),
                                  child: const Text("Biliyorum"),
                          ),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: SizedBox(
                          width: 150,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              foregroundColor: white,
                              backgroundColor: redAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              elevation: 3,
                            ),
                            child: const Text("Bilmiyorum "),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            }, childCount: 1),
          )
        ],
      ),
    );
  }
}
