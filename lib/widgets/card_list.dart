import 'package:academi_kit/data/app_color.dart';
import 'package:academi_kit/data/database.dart';
import 'package:academi_kit/models/class.dart';
import 'package:academi_kit/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardList extends ConsumerWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classesAsync = ref.watch(classNotifierProvider);
    // Class c1 = Class(code: 'cs103', name: 'Computer Science 103', credits: 3);
    // ref.read(classNotifierProvider.notifier).addClass(c1);
    return classesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      data: (classes) {
        // 'classes' is List<Class> - use it to build your UI
        return ListView.builder(
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final classItem = classes[index];
            return Card(
              color: AppColors.lightGrey,
              child: ListTile(
                splashColor: AppColors.coolBlue,

                onLongPress: () {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete Class'),
                        content: Text(
                          'Are you sure you want to delete this class?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(classNotifierProvider.notifier)
                                  .deleteClass(classItem.code);
                              Navigator.of(context).pop();
                            },
                            child: Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No'),
                          ),
                        ],
                      );
                    },
                  );
                },
                title: Text(classItem.name),
                subtitle: Text(
                  style: TextStyle(color: Colors.grey),
                  'Code: ${classItem.code} | Credits: ${classItem.credits}',
                ),
              ),
            );
          },
        );
      },
    );
  }
}
