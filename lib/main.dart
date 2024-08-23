import 'package:flutter/material.dart';
import 'package:rag/pages/home_page.dart';
import 'package:rag/pages/loading_page.dart';

import 'managers/embeddings_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool appReady = false;

  @override
  void initState() {
    super.initState();
    initializeModel();
  }

  @override
  void dispose() {
    super.dispose();
    EmbeddingsManager.release();
  }

  initializeModel() async{
    await EmbeddingsManager.initModel();
    setState(() {appReady = true;});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        home: appReady ? const HomePage() : const LoadingPage()
    );
  }
}