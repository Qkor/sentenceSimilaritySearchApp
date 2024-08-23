import 'package:flutter/material.dart';
import 'package:rag/managers/file_manager.dart';
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      TextField(
                        controller: inputController,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: (){
                              final results = VectorDatabaseManager.query(inputController.text);
                              setState(() {
                                answers = [];
                                for(final result in results){
                                  answers.add(result.object.text);
                                }
                              });
                            },
                            icon: const Icon(Icons.search)
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,40,10,10),
                  child: TextButton(
                      onPressed: () async {
                        String? text = await FileManager.loadTextFile();
                        if(text != null){
                          VectorDatabaseManager.chunkAndPut(text);
                        }
                        if(context.mounted){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("File content loaded"), backgroundColor: Colors.green));
                        }
                      },
                      child: const Row(children: [
                        Icon(Icons.file_open),
                        Text('Load vector database from txt file')
                      ])
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: () {
                      VectorDatabaseManager.clearDatabase();
                      if(context.mounted){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Database cleared"), backgroundColor: Colors.green));
                      };
                    },
                      child: const Row(children: [
                        Icon(Icons.clear_outlined),
                        Text('Clear the database')
                      ])
                  ),
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