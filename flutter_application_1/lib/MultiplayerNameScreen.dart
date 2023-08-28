import 'package:flutter/material.dart';

class MultiplayerNameScreen extends StatefulWidget {
  const MultiplayerNameScreen({Key? key}) : super(key: key);

  @override
  _MultiplayerNameScreenState createState() => _MultiplayerNameScreenState();
}

class _MultiplayerNameScreenState extends State<MultiplayerNameScreen> {
  List<TextEditingController> _nameControllers = [];

  void _addPlayer() {
    setState(() {
      _nameControllers.add(TextEditingController());
    });
  }

  void _startQuiz() {
    List<String> playerNames = _nameControllers
        .map((controller) => controller.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    if (playerNames.isNotEmpty) {
      // Navigate to the quiz screen or perform any other actions
      // with the player names here
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50), // Hide the app bar
        child: AppBar(
          backgroundColor: Color(0xFFBFD2B8),
          elevation: 0.0, // Remove the bottom border
        ),
      ),
      body: Container(
        height: screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter names of players:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Column(
                  children: List.generate(
                    _nameControllers.length,
                        (index) => TextFormField(
                      controller: _nameControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Player ${index + 1}',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addPlayer,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreen[800], // Change button color to orange
                  ),
                  child: Text('Add Player'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _startQuiz,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreen[800], // Change button color to orange
                  ),
                  child: Text('Start Quiz'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
