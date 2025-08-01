import 'package:academi_kit/data/app_color.dart';
import 'package:academi_kit/data/notification.dart';
import 'package:academi_kit/models/class.dart';
import 'package:academi_kit/models/exam.dart';
import 'package:academi_kit/providers/course_provider.dart';
import 'package:academi_kit/providers/exam_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddQuiz extends ConsumerStatefulWidget {
  const AddQuiz({super.key, this.quiz});
  final Exam? quiz;
  @override
  ConsumerState<AddQuiz> createState() => _AddQuizState();
}

class _AddQuizState extends ConsumerState<AddQuiz> {
  static final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  DateTime dueDate = DateTime.now().subtract(const Duration(days: 7));
  int selectedStatus = 0; // Default to 'Not Started'
  String selectedClassCode = '';
  List<String> statusList = ['Not Started', 'In Progress', 'Completed'];
  List<Class> classes = [];
  @override
  void initState() {
    super.initState();
    classes = ref.read(classNotifierProvider).value ?? [];
    if (widget.quiz != null) {
      titleController.text = widget.quiz!.title;
      descriptionController.text = widget.quiz!.description;
      dueDate = widget.quiz!.examDate;
      selectedStatus = widget.quiz!.status;
      selectedClassCode = widget.quiz!.classCode;
      statusController.text = statusList[selectedStatus];
      classController.text = classes
          .where((c) => c.code == selectedClassCode)
          .map((c) => c.name)
          .join(', ');
    }
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
              widget.quiz != null ? 'Edit Quiz' : 'Add Quiz',
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
                labelText: 'Quiz Title',
                labelStyle: TextStyle(color: AppColors.offWhite),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Quiz title';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: DropdownMenu<int>(
                    label: Text(
                      'Status',
                      style: TextStyle(color: AppColors.offWhite),
                    ),
                    initialSelection: 0,
                    dropdownMenuEntries: [
                      DropdownMenuEntry<int>(
                        value: 0,
                        label: 'Not Started',
                        style: MenuItemButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                      DropdownMenuEntry<int>(
                        value: 1,
                        label: 'In Progress',
                        style: MenuItemButton.styleFrom(
                          foregroundColor: Colors.orange,
                        ),
                      ),
                      DropdownMenuEntry<int>(
                        value: 2,
                        label: 'Completed',
                        style: MenuItemButton.styleFrom(
                          foregroundColor: Colors.green,
                        ),
                      ),
                    ],
                    controller: statusController,
                    onSelected: (value) {
                      selectedStatus = value ?? 0;
                      statusController.text = statusList[value ?? 0];
                    },
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
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
                border: InputBorder.none,
              ),
              controller: descriptionController,
              maxLines: 3,
              onChanged: (value) => descriptionController.text = value,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text(widget.quiz != null ? 'Edit Quiz' : 'Add Quiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coolBlue,
                    foregroundColor: AppColors.offWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      // TODO add validations
                    }
                    // NotificationService().showNotification(
                    //   0,
                    //   'Quiz Reminder',
                    //   'You have a quiz scheduled for ${dueDate.day}/${dueDate.month}/${dueDate.year}',
                    // );
                    if (widget.quiz != null) {
                      print(widget.quiz!.id);
                      await ref
                          .read(examProvider.notifier)
                          .updateExam(
                            Exam(
                              classCode: selectedClassCode,
                              title: titleController.text,
                              description: descriptionController.text,
                              examDate: dueDate,
                              status: selectedStatus,
                              id: widget.quiz!.id,
                            ),
                          );
                      ref.invalidate(examProvider);
                      Navigator.pop(context);
                      NotificationService().scheduleNotification(
                        id: 0,
                        title: 'Quiz Reminder',
                        body:
                            'You have a quiz scheduled for ${dueDate.day}/${dueDate.month}/${dueDate.year}',
                        scheduledDate: dueDate.subtract(
                          const Duration(days: 2),
                        ),
                      );
                      return;
                    }
                    ref
                        .read(examProvider.notifier)
                        .addExam(
                          Exam(
                            classCode: selectedClassCode,
                            title: titleController.text,
                            description: descriptionController.text,
                            examDate: dueDate,
                            status: selectedStatus,
                          ),
                        );
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGrey,
                    foregroundColor: AppColors.offWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 3000)),
                    );
                    setState(() {
                      dueDate = picked ?? DateTime.now();
                    });
                  },

                  label: Text(
                    dueDate.isBefore(
                          DateTime.now().subtract(const Duration(days: 1)),
                        )
                        ? 'Select Due Date'
                        : '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                  ),
                  icon: Icon(Icons.calendar_today),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
