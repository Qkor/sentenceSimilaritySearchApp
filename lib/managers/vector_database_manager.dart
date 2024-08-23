import 'dart:io';
import 'package:rag/managers/embeddings_manager.dart';
import 'package:rag/models/paragraph.dart';
import 'package:rag/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class VectorDatabaseManager{
  static late Store _store;
  static late Box<Paragraph> _box;

  static init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    _store = await openStore(directory: "${dir.path}/vectorStore");
    _box = _store.box<Paragraph>();
  }

  static close(){
    _store.close();
  }

  put(String text){
    _box.put(Paragraph(embedding: EmbeddingsManager.encode(text), text: text));
  }
}