import 'package:academi_kit/data/app_color.dart';
import 'package:academi_kit/models/assignment.dart';
import 'package:academi_kit/providers/assignment_provider.dart';
import 'package:academi_kit/widgets/add_assignment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting

class AssignmentsList extends ConsumerWidget {
  const AssignmentsList({super.key});

  String truncateWithEllipsis(String text) {
    const int maxLength = 20; // Maximum length before truncation
    if (text.length <= maxLength) {
      return text; // Return original if within limit
    } else {
      return '${text.substring(0, maxLength)}...'; // Truncate and add '...'
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignmentsAsync = ref.watch(assignmentProvider);
    List<Color> colors = [Colors.red, Colors.orange, Colors.green];
    return assignmentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (assignments) {
        if (assignments.isEmpty) {
          return const Center(child: Text('No assignments available'));
        }

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            final assignment = assignments[index];
            return Card(
              color: AppColors.lightGrey,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: ListTile(
                title: Text(assignment.title),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(truncateWithEllipsis(assignment.description)),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return AddAssignment(assignment: assignment);
                    },
                  );
                },
                onLongPress: () {
                  _deleteAssignment(ref, assignment.id!, context);
                },
                trailing: Text(
                  DateFormat('MMM dd, yyyy ').format(assignment.dueDate),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
                leading: CircleAvatar(
                  radius: 35,
                  backgroundColor: colors[assignment.status].withOpacity(0.7),
                  child: Text(
                    assignment.classCode.toUpperCase(),
                    style: TextStyle(color: AppColors.offWhite, fontSize: 10),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Future<void> _deleteAssignment(
  WidgetRef ref,
  int id,
  BuildContext context,
) async {
  try {
    await ref.read(assignmentProvider.notifier).deleteAssignment(id);
    ref.invalidate(assignmentProvider);
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
  }
}
