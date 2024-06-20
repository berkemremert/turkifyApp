import 'dart:math';
import '../mainTools/firebaseMethods.dart';

List<Map<String, dynamic>> createQuestion(String level, List<String> usedQuestions){
  /*
  DOCSTRING
  INPUT:
    String Level: "A1" or "A2" according to wanted level of words. (May add other levels later.)
    List<String> usedQuestions: ID's of previously asked questions for not asking again. If none give empty list.

  OUTPUT:
    type: List<Map<String, dynamic>>
    explanation: First 4 indexes are chosen word maps and 3 of them is wrong choices obviously. (keys: english_word, turkish_word, level, picture)
      Last index is also a map which includes information about the question. (keys: used_id, asked_word_in_english, asked_word_in_turkish, correct_position, new_used_list)

  SUGGESTIONS:
    For the next questions, give the new_used_list as the new input parameter usedQuestions.
   */
  int total_option_count = 4;
  List<String> all_id = getQuestionsInLevel(level);
  List<String> can_be_asked = List.from(all_id);

  //remove used ones
  for (String id in usedQuestions){
    can_be_asked.remove(id);
  }

  //for picking the one which is going to be asked
  Random rand_gen = Random();
  int index = rand_gen.nextInt(can_be_asked.length);
  Map<String, dynamic> picked_as_question = getWordForQuiz(can_be_asked[index]);

  all_id.remove(can_be_asked[index]);
  List<Map<String, dynamic>> picked_words = [];

  //pick wrong options
  for (int i = 0; i<(total_option_count-1); i++){
    int ind = rand_gen.nextInt(all_id.length);
    Map<String, dynamic> picked_temp = getWordForQuiz(all_id[ind]);
    picked_words.add(picked_temp);
    all_id.removeAt(ind);
  }

  int correct_position = rand_gen.nextInt(4);
  picked_words.insert(correct_position, picked_as_question);

  //creating new used for next use
  usedQuestions.add(can_be_asked[index]);

  //creating info map as last element
  Map<String, dynamic> info = {
    "used_id": can_be_asked[index],
    "asked_word_in_turkish": picked_as_question["turkish_word"],
    "asked_word_in_english": picked_as_question["english_word"],
    "correct_position": correct_position,
    "new_used_list": usedQuestions,
  };
  picked_words.add(info);
  return picked_words;
}
