import 'package:academi_kit/data/app_color.dart';
import 'package:academi_kit/providers/exam_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting

class QuizList extends ConsumerWidget {
  const QuizList({super.key});
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
    final quizzesAsync = ref.watch(examProvider);

    return quizzesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (quizzes) {
        if (quizzes.isEmpty) {
          return const Center(child: Text('No quizzes available'));
        }

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: quizzes.length,
          itemBuilder: (context, index) {
            final quiz = quizzes[index];
            return Card(
              color: AppColors.lightGrey,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: ListTile(
                title: Text(quiz.title),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [Text(truncateWithEllipsis(quiz.description))],
                    ),
                  ],
                ),
                onTap: () {
                  // Handle assignment tap
                },
                trailing: Text(
                  DateFormat('MMM dd, yyyy ').format(quiz.examDate),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
                leading: CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.coolBlue,
                  child: Text(
                    quiz.classCode.toUpperCase(),
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

Future<void> _deleteQuiz(WidgetRef ref, int id, BuildContext context) async {
  try {
    await ref.read(examProvider.notifier).deleteExam(id);
    ref.invalidate(examProvider);
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
  }
}
