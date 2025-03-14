import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddGameScreen extends StatefulWidget {
  @override
  _AddGameScreenState createState() => _AddGameScreenState();
}

class _AddGameScreenState extends State<AddGameScreen> {
  final TextEditingController _gameNameController = TextEditingController();
  final TextEditingController _gameDevController = TextEditingController();
  final TextEditingController _gameTypeController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  Future<void> _submitPost() async {
    String gameName = _gameNameController.text.trim();
    String gameDev = _gameDevController.text.trim();
    String gameType = _gameTypeController.text.trim();
    String imageUrl = _imageUrlController.text.trim();

    if (gameName.isEmpty || gameDev.isEmpty || gameType.isEmpty || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields!')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Games').add({
        'GameName': gameName,
        'GameDev': gameDev,
        'GameType': gameType,
        'ImageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Game added successfully!')),
      );

      _gameNameController.clear();
      _gameDevController.clear();
      _gameTypeController.clear();
      _imageUrlController.clear();

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Game'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField("Game Name", _gameNameController),
            SizedBox(height: 15),
            _buildTextField("Developer", _gameDevController),
            SizedBox(height: 15),
            _buildTextField("Game Type", _gameTypeController),
            SizedBox(height: 15),
            _buildTextField("Image URL", _imageUrlController),
            SizedBox(height: 30),

            ElevatedButton(
              onPressed: _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: Text('Add Game', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.indigo),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
    );
  }
}
