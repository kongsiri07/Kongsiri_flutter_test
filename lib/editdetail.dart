import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditGameScreen extends StatefulWidget {
  final DocumentSnapshot doc;
  EditGameScreen({required this.doc});

  @override
  _EditGameScreenState createState() => _EditGameScreenState();
}

class _EditGameScreenState extends State<EditGameScreen> {
  late TextEditingController gameNameController;
  late TextEditingController gameTypeController;

  @override
  void initState() {
    super.initState();
    var data = widget.doc.data() as Map<String, dynamic>? ?? {};
    gameNameController = TextEditingController(text: data['GameName']);
    gameTypeController = TextEditingController(text: data['GameType']);
  }

  Future<void> _updateGame() async {
    try {
      await widget.doc.reference.update({
        'GameName': gameNameController.text.trim(),
        'GameType': gameTypeController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('success!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('filed: ${e.toString()}')),
      );
    }
  }

  Future<void> _deleteGame() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure?"),
        content: Text("Do you want to delete this game?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              try {
                await widget.doc.reference.delete();
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('success!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('filed: ${e.toString()}')),
                );
              }
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField("Name", gameNameController),
            SizedBox(height: 15),
            _buildTextField("Type", gameTypeController),
            SizedBox(height: 30),

            ElevatedButton(
              onPressed: _updateGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),

            SizedBox(height: 20),

            OutlinedButton(
              onPressed: _deleteGame,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: Text('Delete', style: TextStyle(color: Colors.red, fontSize: 16)),
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
