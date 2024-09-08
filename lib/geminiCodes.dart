import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final apiKey = dotenv.env['API_KEY'];

Future<String?> talkWithGemini() async{
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey!);
  final message = "Bana A1 seviyesinde, spor hakkında bir hikaye anlat"; // TODO: BURAYI İSTEDİĞİNİZ GİBİ EDİTLEYİN
  final content = Content.text(message);
  final response = await model.generateContent([content]);
  print("${response.text}");
  return response.text;
}

Future<List<String?>> talkWithGemini2(String prompt, String level) async{
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey!);
  final message = "Bana $level seviyesinde, '$prompt' hakkında Türkçe bir hikaye anlat";
  final content = Content.text(message);
  final response = await model.generateContent([content]);

  final title = 'Metne maksimum 5 kelimelik bir başlık yaz (başka hiçbir şey yazma): ' + response.text!;
  final titleContent = Content.text(title);
  final titleResponse = await model.generateContent([titleContent]);

  print("${response.text}");
  return [response.text, titleResponse.text];
}