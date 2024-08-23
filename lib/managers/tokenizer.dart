import 'dart:convert';
import 'package:flutter/services.dart';

class Tokenizer{
  final assetFileName = 'assets/models/tokenizer.json';
  Map<String, int>? vocab;

  loadTokenizer() async {
    final jsonString = await rootBundle.loadString(assetFileName);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final model = jsonData['model'] as Map<String, dynamic>;
    final vocabData = model['vocab'] as Map<String, dynamic>;
    vocab = vocabData.map((key, value) => MapEntry(key, value as int));
  }

  List<int> encode(String s){
    final tokens = s.split(' ');
    return tokens.map((token) => vocab!["Ġ$token"] ?? vocab![token] ?? vocab!['[UNK]']!).toList();
  }
}