import 'package:academi_kit/data/app_color.dart';
import 'package:academi_kit/models/note.dart';
import 'package:academi_kit/models/class.dart';
import 'package:academi_kit/providers/course_provider.dart';
import 'package:academi_kit/providers/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: complete the AddNote widget to allow users to add notes for classes

class AddNote extends ConsumerStatefulWidget {
  const AddNote({super.key});

  // //final int? id;
  //   final String classCode;
  //   final String title;
  //   final String description;
  //   final DateTime dueDate;
  //   final int status; // 0 = pending, 1 = complete
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddNoteState();
  }
}

class _AddNoteState extends ConsumerState<AddNote> {
  static final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  String selectedClassCode = '';
  List<String> statusList = ['Not Started', 'In Progress', 'Completed'];
  List<Class> classes = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classes = ref.read(classNotifierProvider).value ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.charcoal,
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: Form(
        key: formKey,
        child: Column(
          spacing: 15,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Add Note',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.offWhite,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              onChanged: (value) {
                titleController.text = value;
              },
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Note Title',
                labelStyle: TextStyle(color: AppColors.offWhite),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter note title';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: DropdownMenu(
                    label: Text(
                      'Status',
                      style: TextStyle(color: AppColors.offWhite),
                    ),
                    controller: statusController,
                    onSelected: (value) =>
                        statusController.text = statusList[value ?? 0],
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 0,
                        label: 'Not Started',
                        style: MenuItemButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                      DropdownMenuEntry(
                        value: 1,
                        label: 'In Progress',
                        style: MenuItemButton.styleFrom(
                          foregroundColor: Colors.orange,
                        ),
                      ),
                      DropdownMenuEntry(
                        value: 2,
                        label: 'Completed',
                        style: MenuItemButton.styleFrom(
                          foregroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: DropdownMenu(
                    label: Text(
                      'Class',
                      style: TextStyle(color: AppColors.offWhite),
                    ),
                    controller: classController,
                    dropdownMenuEntries: [
                      for (var classItem in classes)
                        DropdownMenuEntry(
                          value: classItem.code,
                          label: classItem.name,
                        ),
                    ],
                    onSelected: (value) {
                      setState(() {
                        selectedClassCode = value ?? '';
                      });
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: AppColors.offWhite),
                border: OutlineInputBorder(),
              ),
              controller: descriptionController,
              onChanged: (value) => descriptionController.text = value,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add Note'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coolBlue,
                    foregroundColor: AppColors.offWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      // TODO add validations
                    }
                    ref
                        .read(notesProvider.notifier)
                        .addNote(
                          Note(
                            classCode: selectedClassCode,
                            title: titleController.text,
                            content: descriptionController.text,
                          ),
                        );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
