import 'package:academi_kit/data/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Modal extends StatefulWidget {
  const Modal({super.key});

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  TextEditingController classCodeController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  String? selectedCredits;

  Future<void> _addClass() async {
    final classCode = classCodeController.text.trim();
    final className = classNameController.text.trim();
    final credits = selectedCredits;
    if (classCode.isEmpty || className.isEmpty || credits == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    // This could involve saving the class data to a database or state management solution
    Navigator.of(context).pop(); // Close the modal after adding the class
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 5,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        spacing: 15,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'New Class',
            style: GoogleFonts.roboto(fontSize: 20, color: AppColors.offWhite),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormField(
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
                width: MediaQuery.of(context).size.width * 0.35,
                child: DropdownButton(
                  // borderRadius: BorderRadius.circular(10),
                  hint: Text(
                    "credits",
                    style: TextStyle(
                      color: AppColors.offWhite,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: '1', child: Text('1')),
                    DropdownMenuItem(value: '2', child: Text('2')),
                    DropdownMenuItem(value: '3', child: Text('3')),
                    DropdownMenuItem(value: '4', child: Text('4')),
                  ],
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          TextFormField(
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
              Navigator.of(context).pop();
            },
            child: Text('Add Class'),
          ),
        ],
      ),
    );
  }
}
