import 'package:flutter/material.dart';

class QuizManagementPage extends StatefulWidget {
  const QuizManagementPage({super.key});

  @override
  State<QuizManagementPage> createState() => _QuizManagementPageState();
}

class _QuizManagementPageState extends State<QuizManagementPage> {
  final List<String> questions = [
    'What is the capital of France?',
    'Who painted the Mona Lisa?',
    'What is the largest planet in our solar system?',
    'Who wrote "To Kill a Mockingbird"?',
    'What is the chemical symbol for gold?',
    'Who is known as the "Father of Computers"?',
    'What is the tallest mountain in the world?',
    'Who discovered penicillin?',
    'What is the smallest country in the world?',
    'Who was the first person to walk on the moon?',
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  bool _isFormVisible = false;
  final _questionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Management'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isFormVisible = !_isFormVisible;
              });
            },
            icon: Icon(Icons.arrow_downward),
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: AnimatedContainer(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(color: Colors.transparent),
              duration: Duration(milliseconds: 300),
              height: _isFormVisible ? 100 : 0,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 150),
                          opacity: _isFormVisible ? 1.0 : 0.0,
                          child: TextFormField(
                            controller: _questionController,
                            focusNode: _questionFocusNode,
                            decoration: InputDecoration(
                              labelText: 'New Question',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a question';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              questions.add(_questionController.text);
                              // _questionFocusNode.unfocus();
                              _questionController.clear();
                            });
                          }

                          /* if (_questionController.text.isNotEmpty) {
                            setState(() {
                              questions.add(_questionController.text);
                              _questionController.clear();
                            });
                          } */
                        },
                        child: Text('Add'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(questions[index]),
                  onDismissed: (direction) {
                    setState(() {
                      questions.removeAt(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: InkWell(
                      child: Text(questions[index]),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Edit functionality coming soon!'),
                          ),
                        );
                      },
                    ),
                    trailing: Icon(Icons.edit),
                  ),
                );
              },
              // padding: EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _questionFocusNode.dispose();
    _questionController.dispose();
    super.dispose();
  }
}
