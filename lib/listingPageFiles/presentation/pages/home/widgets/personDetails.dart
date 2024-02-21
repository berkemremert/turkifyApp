class Skill {
  final String skill;
  final String description;

  Skill({required this.skill, required this.description});
}

class Person {
  double distance;
  String name;
  int age;
  Skill offer1;
  Skill? offer2;
  Skill? offer3;
  Skill wish1;
  Skill? wish2;
  Skill? wish3;
  String imageLink;
  String description;
  double rating;
  String email;
  String password;
  bool isAdmin;

  @override
  int compareTo(Person other) {
    bool r = distance > other.distance;
    return r ? 1 : distance == other.distance ? 0 : -1;
  }

  Person({
    required this.distance,
    required this.name,
    required this.age,
    required this.offer1,
    this.offer2,
    this.offer3,
    required this.wish1,
    this.wish2,
    this.wish3,
    required this.imageLink,
    required this.description,
    required this.rating,
    required this.email,
    required this.password,
    this.isAdmin = false,
  });
}
