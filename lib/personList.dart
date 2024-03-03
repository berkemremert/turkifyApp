import 'listingPageFiles/presentation/pages/home/widgets/personDetails.dart';

List<Person> persons = [
  Person(distance: 0.2,
    name: 'Berk Emre Mert',
    age: 21,
    offer1: Skill(skill: "Cucumber", description: ""),
    wish1: skillMap['Turkish']!,
    wish2: skillMap['Biology']!,
    wish3: skillMap['Design']!,
    imageLink: 'https://images.pexels.com/photos/1300402/pexels-photo-1300402.jpeg',
    description: 'I am Berk I love the world!!',
    rating: 4.9,
    email: 'b@.com',
    password: '.',
    ),
  Person(distance: 1.8,
    name: 'Burak Özbağcı',
    age: 100,
    offer1: skillMap['Turkish']!,
    offer2: skillMap['Biology']!,
    wish1: skillMap['Mathematics']!,
    imageLink: 'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    description: 'I am Burak I love cats!!',
    rating: 1.1,
    email: 'bb@.com',
    password: '.',
  ),
  Person(distance: 1.8,
    name: 'Ronaldo',
    age: 36,
    offer1: skillMap['Design']!,
    offer2: skillMap['Biology']!,
    wish1: Skill(
      skill: 'Tea',
      description: 'I wanna learn good tea',
    ),
    imageLink: 'https://img.a.transfermarkt.technology/portrait/big/8198-1694609670.jpg?lm=1',
    description: 'I am Ronaldo I love the world!!',
    rating: 4.9,
    email: 'r@.com',
    password: '.',
  ),
  Person(
    distance: 1.8,
    name: 'Ahmet Yılmaz',
    age: 28,
    offer1: Skill(
      description: 'I am skilled in software development.',
      skill: 'Software Development',
    ),
    wish1: Skill(
      skill: 'Data Science',
      description: 'I want to learn data science.',
    ),
    imageLink: 'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    description: 'I am Ahmet Yılmaz.',
    rating: 4.5,
    email: 'ahmet.yilmaz@example.com',
    password: 'ahmet123',
    isAdmin: false,
  ),
  Person(
    distance: 2.0,
    name: 'Ayşe Kaya',
    age: 31,
    offer1: skillMap['Design']!,
    wish1: Skill(
      skill: 'Machine Learning',
      description: 'I want to learn machine learning.',
    ),
    imageLink: 'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    description: 'I am Ayşe Kaya.',
    rating: 4.7,
    email: 'ayse.kaya@example.com',
    password: 'ayse456',
    isAdmin: true,
  ),
  Person(
    distance: 1.5,
    name: 'Mehmet Şahin',
    age: 35,
    offer1: Skill(
      description: 'I am experienced in project management.',
      skill: 'Project Management',
    ),
    offer2: skillMap['Biology']!,
    wish1: Skill(
      skill: 'Artificial Intelligence',
      description: 'I want to learn artificial intelligence.',
    ),
    imageLink: 'https://images.pexels.com/photos/1121796/pexels-photo-1121796.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    description: 'I am Mehmet Şahin.',
    rating: 4.2,
    email: 'mehmet.sahin@example.com',
    password: 'mehmet789',
    isAdmin: false,
  ),
  Person(
    distance: 2.2,
    name: 'Fatma Arslan',
    age: 29,
    offer1: Skill(
      description: 'I can provide legal consultancy services.',
      skill: 'Legal Consultancy',
    ),
    wish1: Skill(
      skill: 'Digital Marketing',
      description: 'I want to learn digital marketing strategies.',
    ),
    imageLink: 'https://images.pexels.com/photos/1036622/pexels-photo-1036622.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    description: 'I am Fatma Arslan.',
    rating: 4.9,
    email: 'fatma.arslan@example.com',
    password: 'fatma101',
    isAdmin: true,
  ),
  Person(
    distance: 1.7,
    name: 'Mustafa Erdoğan',
    age: 33,
    offer1: Skill(
      description: 'I am a skilled graphic designer.',
      skill: 'Graphic Design',
    ),
    wish1: Skill(
      skill: 'Web Development',
      description: 'I want to improve my web development skills.',
    ),
    imageLink: 'https://images.pexels.com/photos/1516680/pexels-photo-1516680.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    description: 'I am Mustafa Erdoğan.',
    rating: 4.6,
    email: 'mustafa.erdogan@example.com',
    password: 'mustafa2022',
    isAdmin: false,
  ),
  Person(
    distance: 1.9,
    name: 'Emine Çelik',
    age: 27,
    offer1: Skill(
      description: 'I am an experienced nurse.',
      skill: 'Nursing',
    ),
    wish1: Skill(
      skill: 'Foreign Languages',
      description: 'I want to learn new languages.',
    ),
    imageLink: 'https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    description: 'I am Emine Çelik.',
    rating: 4.3,
    email: 'emine.celik@example.com',
    password: 'emine999',
    isAdmin: false,
  ),
  Person(
    distance: 1.8,
    name: 'Hüseyin Yıldırım',
    age: 30,
    offer1: Skill(
      description: 'I can provide financial advisory services.',
      skill: 'Financial Advisory',
    ),
    wish1: Skill(
      skill: 'Photography',
      description: 'I want to learn photography techniques.',
    ),
    imageLink: 'https://images.pexels.com/photos/839011/pexels-photo-839011.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    description: 'I am Hüseyin Yıldırım.',
    rating: 4.8,
    email: 'huseyin.yildirim@example.com',
    password: 'huseyin123',
    isAdmin: true,
  ),
  Person(
    distance: 1.6,
    name: 'Zeynep Tekin',
    age: 32,
    offer1: Skill(
      description: 'I am skilled in customer service.',
      skill: 'Customer Service',
    ),
    wish1: Skill(
      skill: 'Cooking',
      description: 'I want to improve my cooking skills.',
    ),
    imageLink: 'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    description: 'I am Zeynep Tekin.',
    rating: 4.1,
    email: 'zeynep.tekin@example.com',
    password: 'zeynep777',
    isAdmin: false,
  ),
  Person(
    distance: 2.1,
    name: 'Ali Aksoy',
    age: 29,
    offer1: Skill(
      description: 'I can provide legal consultancy services.',
      skill: 'Legal Consultancy',
    ),
    wish1: Skill(
      skill: 'Digital Marketing',
      description: 'I want to learn digital marketing strategies.',
    ),
    imageLink: 'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    description: 'I am Ali Aksoy.',
    rating: 4.9,
    email: 'ali.aksoy@example.com',
    password: 'ali999',
    isAdmin: true,
  ),
  Person(
    distance: 1.7,
    name: 'Seda Baş',
    age: 31,
    offer1: Skill(
      description: 'I am a skilled graphic designer.',
      skill: 'Graphic Design',
    ),
    wish1: Skill(
      skill: 'Web Development',
      description: 'I want to improve my web development skills.',
    ),
    imageLink: 'https://images.pexels.com/photos/1065084/pexels-photo-1065084.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    description: 'I am Seda Baş.',
    rating: 4.6,
    email: 'seda.bas@example.com',
    password: 'seda2022',
    isAdmin: false,
  ),
];

List<Person> personsDistance = [...persons];

void distanceListCreator(){
  personsDistance.sort((a, b) => a.distance.compareTo(b.distance));
  personsDistance.removeWhere((person) => person.email == currentUser.email);
}

Person currentUser = Person(
  distance: 0,
  name: 'John Doe',
  age: 25,
  offer1: Skill(
    description: 'I can teach very well English.', skill: 'English',
  ),
  wish1: Skill(
    skill: 'Mathematics',
    description: 'I wanna learn good math!!',
  ),
  imageLink: 'https://example.com/avatar.jpg',
  description: 'I am John Doe.',
  rating: 4.5,
  email: 'c@.com',
  password: '.',
);

Map<String, String> mockUsers = {};

void mockUsersUpdater() {
  // Populate mockUsers based on persons list
  for (var person in persons) {
    final email = person.email;
    final password = person.password;
    mockUsers[email] = password;
  }

  mockUsers.forEach((key, value) {
    print('$key: $value');
  });
}

void currentUserUpdater(String email){
  Person? personEntering;

  for (var person in persons) {
    if (person.email == email) {
      personEntering = person;
      break;
    }
  }

  currentUser.email = personEntering!.email;
  currentUser.password = personEntering!.password;
  currentUser.name = personEntering!.name;
  currentUser.age = personEntering!.age;
  currentUser.offer1 = personEntering!.offer1;
  currentUser.offer2 = personEntering!.offer2;
  currentUser.offer3 = personEntering!.offer3;
  currentUser.wish1 = personEntering!.wish1;
  currentUser.wish2 = personEntering!.wish2;
  currentUser.wish3 = personEntering!.wish3;
  currentUser.imageLink = personEntering!.imageLink;
  currentUser.description = personEntering!.description;
  currentUser.rating = personEntering!.rating;
  currentUser.isAdmin = true;
}

Map<String, Skill> skillMap = {
  'Programming': Skill(
    skill: 'Programming',
    description: 'Proficient in multiple programming languages.',
  ),
  'Data Science': Skill(
    skill: 'Data Science',
    description: 'Skilled in analyzing large datasets.',
  ),
  'Mathematics': Skill(
    skill: 'Mathematics',
    description: 'Proficient in teaching calculus concepts.',
  ),
  'Turkish': Skill(
    skill: 'Turkish',
    description: 'Skilled in teaching Turkish grammar.',
  ),
  'Law': Skill(
    skill: 'Law',
    description: 'Skilled in providing legal advice on contracts.',
  ),
  'Design': Skill(
    skill: 'Design',
    description: 'Proficient in Adobe Photoshop for graphic design.',
  ),
  'Communication': Skill(
    skill: 'Communication',
    description: 'Excellent communication skills for customer service.',
  ),
  'Biology': Skill(
    skill: 'Biology',
    description: 'Proficient in teaching biology concepts.',
  ),
  'Physics': Skill(
    skill: 'Physics',
    description: 'Proficient in teaching physics concepts.',
  ),
  'English': Skill(
    skill: 'English',
    description: 'Proficient in teaching English concepts.',
  ),
};

int numberOfWishes(){
  int counter = 1;
  if(currentUser.wish2 != null){
    counter += 1;
  }
  if(currentUser.wish3 != null){
    counter += 1;
  }
  return counter;
}

List<String> wishList(Person person){
  List<String> wishes = [currentUser.wish1.skill];
  if(person.wish2 != null){
    wishes.add(person.wish2!.skill);
  }
  if(person.wish3 != null){
    wishes.add(person.wish3!.skill);
  }
  return wishes;
}

int numberOfOffers(){
  int counter = 1;
  if(currentUser.offer2 != null){
    counter += 1;
  }
  if(currentUser.offer3 != null){
    counter += 1;
  }
  return counter;
}

List<String> offerList(Person person){
  List<String> offers = [person.offer1.skill];
  if(person.offer2 != null){
    offers.add(person.offer2!.skill);
  }
  if(person.offer3 != null){
    offers.add(person.offer3!.skill);
  }
  return offers;
}