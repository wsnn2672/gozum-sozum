// ignore_for_file: camel_case_types
import 'package:google_generative_ai/google_generative_ai.dart';

class geminiEngine
{
  static Map<String, String> instructions = {
    'Türkçe': "Motor nöron hastalığı olan hastaların bir konuşma sırasında iletişim kurmaları için bir yapay zeka asistanısınız.\nAmacınız, yazdıkları anahtar kelimelerle konuşmanın bağlamına uyan gramer kurallarına uygun ve tutarlı bir cümle oluşturmak.\nAbartılardan, emojilerden veya alakasız bilgilerden kaçının.\nDoğru noktalama işaretleri, zaman, dilbilgisi ve büyük harf kullanımı kullanın.\nÖrneğin, 'Keywords: tavuk, Context' girdisi için: Akşam yemeğinde ne yemek istersin' girdisi için çıktı şöyle olmalıdır: “Akşam yemeğinde tavuk yemek istiyorum.'\nBaşka bir örnek için, 'Keywords: sıcak, klima, iki. Context: oda sıcaklığı iyi mi', çıktı şöyle olmalıdır: 'Çok sıcak, klimayı iki derece kısabilir misin?",
    'English': "You are an AI assistant for patients with motor neuron disease to communicate in a conversation.\nYour goal is to generate a grammatical and coherent sentence with keywords they typed that fits the conversation's context.\nAvoid exaggerations, emojis, or irrelevant information.\nUse correct punctuation, tense, grammar, capitalization.\nFor example, for the input 'Keywords: chicken, Context: What do you want to eat for dinner', the output should be: 'I want to chicken for dinner.'\nFor another example, for the input 'Keywords: hot, AC, two. Context: is the room temperature ok', the output should be: 'I am hot, can you turn the AC down by two degrees?'",
    'Español': '',
    '中国人': '',
    'Русский': '',
    'Deutsch': '',
  };

  static Future<String> sendMessage(String keywords, String context, String language) async
  {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: 'AIzaSyBZH6DdYWId03IiXaXRzgRucjAGkqnqZ6Q', systemInstruction: Content.text(instructions[language]!));
    final content = [Content.text('Keywords: $keywords, Context: $context')];

    final response = await model.generateContent(content);

    if (response.text != null)
    {
      return response.text!;
    }
    else
    {
      return "GEMINI_API_ERROR";
    }
  }
}

/*

*/
