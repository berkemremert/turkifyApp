import 'package:flutter/material.dart';
import '../../../../../referencePageFiles/referencePage.dart';
import '../../../components/button.dart';
import '../../../components/text.dart';
import '../widgets/header_image.dart';
import '../widgets/image_gallery.dart';
import '../widgets/map.dart';
import '../widgets/user_profile.dart';
import '../../../themes/colors.dart';
import '../../../themes/config.dart';
import '../../home/widgets/personDetails.dart';

class ScreenDetails extends StatelessWidget {
  final Person person;

  const ScreenDetails({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Scaffold(
      backgroundColor: kColorScaffold,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  kSizedBoxHeight_16,
                  HeaderImage__widget(person: person,),
                  kSizedBoxHeight_24,
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16), // Adjust padding as needed
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.6), // Adjust the opacity as needed
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelSmall__text(text: 'Who am I?',
                        color: Colors.white,),
                        kSizedBoxHeight_16,
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: person.description,
                            style: kBodySmallTextstylee,
                          ),
                        ),
                      ],
                    ),
                  ),
                  kSizedBoxHeight_24,
                  // Add a big button saying "References" here
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1), // Adjust the opacity as needed
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CommentPage()),
                        );                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'References',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple, // Text color
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${person.rating}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple, // Text color
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  kSizedBoxHeight_24,
                  GestureDetector(
                    onTap: () {
                      print("aaaa");
                    },
                    child: const Map__widget(),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: ScreenConfig.screenWidth,
              decoration: BoxDecoration(
                color: kColorWhite,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.6, 1.0],
                  colors: [
                    kColorWhite,
                    kColorWhite.withOpacity(0.0),
                  ],
                ),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BodyMedium__text(text: person.name + ' offering', color: kColorText2),
                        kSizedBoxHeight_8,
                        LabelMedium__text(text: person.offer1.skill),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.2),
                          offset: Offset(0, 15),
                          blurRadius: 15,
                        ),
                      ]),
                      child: Accent__Button__Medium(
                        text: 'Match Now',
                        leftIconVisibility: false,
                        rightIconVisibility: false,
                        onTap: () {},
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
