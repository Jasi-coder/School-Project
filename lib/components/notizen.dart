import 'package:flutter/material.dart';
import 'package:capture_costs_for_household/components/add_edit_note_screen.dart';
import 'package:capture_costs_for_household/components/database/database_helper.dart';
import 'package:capture_costs_for_household/components/database/notes.dart';
import 'package:capture_costs_for_household/components/menu_page.dart';
import 'package:capture_costs_for_household/components/view_note_screen.dart';

class NotizenSeite extends StatefulWidget {
  const NotizenSeite({super.key});

  @override
  State<NotizenSeite> createState() => _NotizenSeiteState();
}

class _NotizenSeiteState extends State<NotizenSeite> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _databaseHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Menupage(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Meine Notizen",
          style: TextStyle(fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 11, 130, 177),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            final note = _notes[index];
            final color = Color(int.parse(note.color));
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewNoteScreen(
                        note: note,
                      ),
                    ),
                  );
                  await _loadNotes();
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          note.title,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.edit),
                            SizedBox(
                              width: screenSize.width * 0.05,
                            ),
                            const Icon(Icons.delete)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 11, 130, 177),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditNoteScreen(),
            ),
          );
          await _loadNotes();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
