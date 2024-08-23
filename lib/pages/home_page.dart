import 'package:flutter/material.dart';
import 'package:rag/managers/embeddings_manager.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final inputController = TextEditingController();
  List<double> embedding = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                TextField(
                  controller: inputController,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      embedding = EmbeddingsManager.encode(inputController.text);
                    });
                  },
                  child: const Text("Generate sentence embedding")
                ),
                const SizedBox(height: 30),
                Text(embedding.toString())
              ],
            ),
          ),
        )
    );
  }
}