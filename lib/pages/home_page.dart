import 'package:flutter/material.dart';
import 'package:rag/managers/vector_database_manager.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final inputController = TextEditingController();
  List<String> answers = [];

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
                    final results = VectorDatabaseManager.query(inputController.text);
                    setState(() {
                      answers = [];
                      for(final result in results){
                        answers.add(result.object.text);
                      }
                    });
                  },
                  child: const Text("Search")
                ),
                const SizedBox(height: 30),
                for(final answer in answers) ... {
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(answer, textAlign: TextAlign.justify),
                  )
                }
              ],
            ),
          ),
        )
    );
  }
}