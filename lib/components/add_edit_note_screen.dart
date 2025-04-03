import 'package:flutter/material.dart';
import 'package:capture_costs_for_household/components/database/database_helper.dart';
import 'package:capture_costs_for_household/components/database/notes.dart';
import 'package:capture_costs_for_household/components/notizen.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreen();
}

class _AddEditNoteScreen extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Color _selectedColor = Colors.amber;
  final List<Color> _colors = [
    const Color.fromARGB(255, 255, 218, 185),
    const Color.fromARGB(255, 244, 164, 96),
    const Color.fromARGB(255, 240, 230, 140),
    const Color.fromARGB(255, 135, 206, 250)
  ];

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = Color(int.parse(widget.note!.color));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title:
            Text(widget.note == null ? 'Notiz hinzufügen' : 'Notiz bearbeiten'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,

                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Titel",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Bitte geben Sie ein Titel ein!";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: screenSize.height * 0.01,
                  ),
                  TextFormField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      hintText: "Notiz",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Bitte gebe ihre Notiz ein!";
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _colors.map(
                          (color) {
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedColor = color),
                              child: Container(
                                height: screenSize.height * 0.08, // 30,
                                width: screenSize.width * 0.1, //30,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _selectedColor == color
                                        ? Colors.black45
                                        : Colors.transparent,
                                    width: screenSize.width * 0.006, //2,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _saveNote();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotizenSeite(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF50C878),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Speichern",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final note = Note(
          id: widget.note?.id,
          title: _titleController.text,
          content: _contentController.text,
          color: _selectedColor.value.toString());
      if (widget.note == null) {
        await _databaseHelper.insertNote(note);
      } else {
        await _databaseHelper.updateNote(note);
      }
    }
  }
}
