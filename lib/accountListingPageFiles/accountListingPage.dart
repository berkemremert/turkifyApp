import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Account {
  final String name;
  final List<String> offeringSkills;
  final String referenceComments;
  final double rating;
  final String? instagramProfile;
  final String? linkedinProfile;

  Account({
    required this.name,
    required this.offeringSkills,
    required this.referenceComments,
    required this.rating,
    this.instagramProfile,
    this.linkedinProfile,
  });
}

class AccountWidget extends StatelessWidget {
  final Account account;

  const AccountWidget({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(account.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Offering Skills: ${account.offeringSkills.join(', ')}'),
          Text('Rating: ${account.rating}'),
          Text('Reference Comment: ${account.referenceComments}'),
        ],
      ),
      trailing: Wrap(
        spacing: 8.0,
        children: [
          if (account.instagramProfile != null)
            IconButton(
              icon: const Icon(FontAwesomeIcons.instagram),
              onPressed: () {
                // Navigate to Instagram profile
              },
            ),
          if (account.linkedinProfile != null)
            IconButton(
              icon: const Icon(FontAwesomeIcons.linkedin),
              onPressed: () {
                // Navigate to LinkedIn profile
              },
            ),
          ElevatedButton(
            onPressed: () {
              // Contact logic
            },
            child: const Text('Contact'),
          ),
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

class AccountListingPage extends StatelessWidget {
  final List<Account> accounts;

  const AccountListingPage({super.key, required this.accounts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Listing'),
      ),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          return AccountWidget(account: accounts[index]);
        },
      ),
    );
  }
}

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

  runApp(MaterialApp(
    home: AccountListingPage(accounts: accounts),
  ));
}
