import 'package:flutter/material.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';

import '../../../listingPageFiles/gen/assets.gen.dart';
import '../../../listingPageFiles/presentation/themes/colors.dart';
import '../../../listingPageFiles/presentation/themes/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../listingPageFiles/presentation/themes/config_files/screen_size_config.dart';

// A widget that represents a search bar with a search icon next to it
class DictionaryBar extends StatelessWidget {
  const DictionaryBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Adds padding to the top/bottom and left/right of the row
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),

      // The search bar and search icon are placed in a row
      child: Row(
        children: <Widget>[
          // Container for the text input (search bar)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16.0),
            decoration: BoxDecoration(
              color: kColorSecondary, // Background color of the search bar
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            width: MediaQuery.of(context).size.width * 77 / 100, // Takes up 77% of screen width
            height: 48, // Fixed height of the search bar
            child: Row(
              children: <Widget>[
                kSizedBoxWidth_8, // Adds horizontal spacing
                const Expanded(
                  // The text field for searching
                  child: TextField(
                    style: kSearchTextStyle, // Text style defined below
                    cursorColor: kColorPrimary, // Color of the cursor
                    decoration: InputDecoration(
                      border: InputBorder.none, // Removes border
                      hintText: 'Kelime Ara', // Placeholder text for the search bar
                      hintStyle: TextStyle(
                          color: Colors.black38 // Color of the hint text
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Spacer to create space between the search bar and the icon
          const Spacer(),

          // Search icon container
          GestureDetector(
            onTap: () {
              // Logic for handling search action goes here
            },
            child: Container(
              padding: const EdgeInsets.all(12), // Padding inside the container
              height: 48, // Fixed height matching the search bar
              width: 48, // Square shape with equal height and width
              decoration: BoxDecoration(
                color: baseDeepColor, // Background color of the search icon button
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Icon(
                FontAwesomeIcons.search, // Search icon from FontAwesome
                color: white, // Color of the search icon
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Text style for the search text field
const kSearchTextStyle = TextStyle(
  fontSize: 12, // Font size of the text
  fontWeight: FontWeight.w500, // Medium font weight
  letterSpacing: 0.5, // Slight spacing between letters
);

// © 2024 Berk Emre Mert and EğiTeam