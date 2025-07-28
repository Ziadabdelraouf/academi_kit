import 'package:academi_kit/data/app_color.dart';
import 'package:academi_kit/models/class.dart';
import 'package:academi_kit/providers/course_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Modal extends StatefulWidget {
  const Modal({super.key, this.reClass});

  final Class? reClass;

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  TextEditingController classCodeController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  TextEditingController creditsController = TextEditingController();
  int selectedcredits = 2; // Default value
  String oldclassCode = '';
  @override
  void initState() {
    super.initState();
    if (widget.reClass != null) {
      classCodeController.text = widget.reClass!.code;
      classNameController.text = widget.reClass!.name;
      selectedcredits = widget.reClass!.credits;
      oldclassCode = widget.reClass!.code;
      return;
    }
  }

  Future<void> _addClass(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    final classCode = classCodeController.text;
    final className = classNameController.text;
    Class c1 = Class(
      code: classCode,
      name: className,
      credits: selectedcredits,
    );
    print('-------------------------------------------');
    print(c1.toMap());
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }
    formKey.currentState!.save();
    // This could involve saving the class data to a database or state management solution
    await ProviderScope.containerOf(
      context,
    ).read(classNotifierProvider.notifier).addClass(c1);
    ProviderScope.containerOf(context).invalidate(classNotifierProvider);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _editClass(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    final classCode = classCodeController.text;
    final className = classNameController.text;
    Class c1 = Class(
      code: classCode,
      name: className,
      credits: selectedcredits,
    );
    print('-------------------------------------------');
    print(c1.toMap());
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }
    formKey.currentState!.save();
    // This could involve saving the class data to a database or state management solution
    await ProviderScope.containerOf(
      context,
    ).read(classNotifierProvider.notifier).updateClass(c1, oldclassCode);
    ProviderScope.containerOf(context).invalidate(classNotifierProvider);
    if (mounted) Navigator.pop(context);
  }

  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 5,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      color: AppColors.charcoal,
      child: Form(
        key: formKey,
        child: Column(
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'New Class',
              style: GoogleFonts.roboto(
                fontSize: 20,
                color: AppColors.offWhite,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextFormField(
                    onChanged: (value) {
                      classCodeController.text = value;
                    },
                    autofocus: false,
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter class code' : null;
                    },
                    controller: classCodeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Class Code',
                      labelStyle: TextStyle(color: AppColors.offWhite),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: DropdownMenu<String>(
                    initialSelection: selectedcredits.toString(),
                    controller: creditsController,
                    // borderRadius: BorderRadius.circular(10),
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: '1', label: '1'),
                      DropdownMenuEntry(value: '2', label: '2'),
                      DropdownMenuEntry(value: '3', label: '3'),
                      DropdownMenuEntry(value: '4', label: '4'),
                    ],
                    onSelected: (value) {
                      setState(() {
                        selectedcredits = int.tryParse(value ?? '') ?? 2;
                      });
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  classNameController.text = value;
                });
              },
              validator: (value) =>
                  value!.isEmpty ? 'Please enter class name' : null,
              controller: classNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Class Name',
                labelStyle: TextStyle(color: AppColors.offWhite),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (oldclassCode == '') {
                  _addClass(context, formKey);
                  return;
                }
                _editClass(context, formKey);
              },
              child: Text('Add Class'),
            ),
          ],
        ),
      ),
    );
  }
}
