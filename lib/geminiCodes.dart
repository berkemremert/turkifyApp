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

Future<String?> talkWithGemini2() async{ // Örnek kullanılmayan fonksiyon
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey!);
  final message = "Bana A1 seviyesinde, Temel hakkında hakkında bir fıkra anlat"; // TODO: BURAYI İSTEDİĞİNİZ GİBİ EDİTLEYİN
  final content = Content.text(message);
  final response = await model.generateContent([content]);
  print("${response.text}");
  return response.text;
}