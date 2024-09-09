import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Model class representing an Account
class Account {
  final String name; // The name of the account holder
  final List<String> offeringSkills; // List of skills offered by the account holder
  final String referenceComments; // Comments or testimonials about the account holder
  final double rating; // Rating of the account holder
  final String? instagramProfile; // Optional: Instagram profile link
  final String? linkedinProfile; // Optional: LinkedIn profile link

  Account({
    required this.name,
    required this.offeringSkills,
    required this.referenceComments,
    required this.rating,
    this.instagramProfile,
    this.linkedinProfile,
  });
}

// Widget to display individual account information
class AccountWidget extends StatelessWidget {
  final Account account; // The account object to display

  const AccountWidget({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Displays the account name as the title
      title: Text(account.name),

      // Displays offering skills, rating, and reference comments as subtitles
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Offering Skills: ${account.offeringSkills.join(', ')}'),
          Text('Rating: ${account.rating}'),
          Text('Reference Comment: ${account.referenceComments}'),
        ],
      ),

      // Trailing section with Instagram, LinkedIn, contact button, and popup menu
      trailing: Wrap(
        spacing: 8.0,
        children: [
          if (account.instagramProfile != null)
            IconButton(
              icon: const Icon(FontAwesomeIcons.instagram),
              onPressed: () {
                // Add logic to navigate to Instagram profile
              },
            ),
          if (account.linkedinProfile != null)
            IconButton(
              icon: const Icon(FontAwesomeIcons.linkedin),
              onPressed: () {
                // Add logic to navigate to LinkedIn profile
              },
            ),
          // Contact button to initiate a contact action
          ElevatedButton(
            onPressed: () {
              // Add contact logic
            },
            child: const Text('Contact'),
          ),
          // Popup menu for additional options such as Report, Block, or Not Interested
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'report',
                child: Text('Report'),
              ),
              const PopupMenuItem(
                value: 'block',
                child: Text('Block'),
              ),
              const PopupMenuItem(
                value: 'not_interested',
                child: Text('Not Interested'),
              ),
            ],
            onSelected: (value) {
              // Handle selected option
            },
          ),
        ],
      ),
    );
  }
}

// Main page widget that lists multiple accounts using a ListView
class AccountListingPage extends StatelessWidget {
  final List<Account> accounts; // List of accounts to display

  const AccountListingPage({super.key, required this.accounts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Listing'), // Title of the page
      ),
      body: ListView.builder(
        itemCount: accounts.length, // Number of accounts to display
        itemBuilder: (context, index) {
          // Builds an AccountWidget for each account
          return AccountWidget(account: accounts[index]);
        },
      ),
    );
  }
}

// Main function to start the app with a list of sample accounts
void main() {
  List<Account> accounts = [
    Account(
      name: 'John Doe',
      offeringSkills: ['Skill 1', 'Skill 2', 'Skill 3'],
      referenceComments: 'Great teacher!',
      rating: 4.5,
      instagramProfile: 'john_doe_instagram',
      linkedinProfile: 'john_doe_linkedin',
    ),
    // Add more accounts as per your data model
  ];

  // Run the app with the AccountListingPage displaying the accounts
  runApp(MaterialApp(
    home: AccountListingPage(accounts: accounts),
  ));
}

// © 2024 Berk Emre Mert and EğiTeam