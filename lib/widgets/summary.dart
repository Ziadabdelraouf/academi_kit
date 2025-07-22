import 'package:academi_kit/data/app_color.dart';
import 'package:academi_kit/providers/assignment_provider.dart';
import 'package:academi_kit/providers/exam_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AssignSummary extends ConsumerWidget {
  const AssignSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignmentsAsync = ref.watch(assignmentProvider);
    final examsAsync = ref.watch(examProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        assignmentsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          data: (assignments) {
            return CircularPercentIndicator(
              radius: 50.0,
              lineWidth: 5.0,
              animation: true,
              percent: ref.watch(upcomingAssignmentsProvider).total == 0
                  ? 0.0
                  : ref.watch(upcomingAssignmentsProvider).completed /
                        ref.watch(upcomingAssignmentsProvider).total,
              center: Text(
                "${ref.watch(upcomingAssignmentsProvider).completed}/${ref.watch(upcomingAssignmentsProvider).total}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              footer: Text(
                "Assignments",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              ),
              circularStrokeCap: CircularStrokeCap.butt,
              backgroundColor: Colors.grey,
              progressColor: Colors.blue,
            );
          },
        ),

        examsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          data: (exams) {
            return Text(
              'Due exams: ${ref.watch(upcomingExamsProvider).total}',
              style: GoogleFonts.roboto(
                fontSize: 24,
                color: AppColors.offWhite,
              ),
            );
          },
        ),
      ],
    );
  }
}
