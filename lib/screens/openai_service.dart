import 'package:google_generative_ai/google_generative_ai.dart';

class OpenAIService {
  // ⚠️ METS TA CLÉ ICI ENTRE LES GUILLEMETS
  final String apiKey = "AIzaSyBqyoTTtuWuAJCbSrq-dl1qYRozbcI2RiY"; 

  Future<String> sendMessage(String message) async {
    // Petit test de sécurité
    if (apiKey == "TON_API_KEY_ICI" || apiKey.isEmpty) {
      return "Oups ! Tu as oublié d'ajouter ta clé API Gemini dans le fichier openai_service.dart.";
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-flash-latest',
        apiKey: apiKey,
      );

      final content = [Content.text(message)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        return response.text!;
      } else {
        return "Gemini n'a pas pu générer de texte.";
      }
    } catch (e) {
      // Si la clé est mauvaise, Google renvoie une erreur ici
      return "Erreur de connexion : Vérifie que ta clé API est correcte et active.";
    }
  }
}