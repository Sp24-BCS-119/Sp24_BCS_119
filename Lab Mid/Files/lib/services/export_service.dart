import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../models/task.dart';

class ExportService {
  Future<void> exportCsv(List<Task> tasks) async {
    final file = await _createFile('taskflow_tasks.csv');
    final buffer = StringBuffer()
      ..writeln(
        'Title,Description,Due Date,Status,Repeat,Progress,Notification Sound',
      );

    for (final task in tasks) {
      buffer.writeln([
        _escape(task.title),
        _escape(task.description),
        _escape(DateFormat('dd MMM yyyy, hh:mm a').format(task.dueDate)),
        _escape(task.isCompleted ? 'Completed' : 'Pending'),
        _escape(_repeatLabel(task)),
        _escape('${task.progressPercent}%'),
        _escape(task.notificationSound),
      ].join(','));
    }

    await file.writeAsString(buffer.toString());
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'TaskFlow CSV Export',
      ),
    );
  }

  Future<void> exportPdf(List<Task> tasks) async {
    final document = pw.Document();
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Text(
              'TaskFlow Task Report',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 16),
            pw.TableHelper.fromTextArray(
              headers: const [
                'Title',
                'Due',
                'Status',
                'Repeat',
                'Progress',
              ],
              data: tasks
                  .map(
                    (task) => [
                      task.title,
                      dateFormat.format(task.dueDate),
                      task.isCompleted ? 'Completed' : 'Pending',
                      _repeatLabel(task),
                      '${task.progressPercent}%',
                    ],
                  )
                  .toList(),
            ),
          ];
        },
      ),
    );

    final file = await _createFile('taskflow_tasks.pdf');
    await file.writeAsBytes(await document.save());
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'TaskFlow PDF Export',
      ),
    );
  }

  Future<void> exportEmail(List<Task> tasks) async {
    final summary = tasks
        .map(
          (task) =>
              '- ${task.title} | ${DateFormat('dd MMM yyyy, hh:mm a').format(task.dueDate)} | ${task.isCompleted ? 'Completed' : 'Pending'}',
        )
        .join('\n');

    await SharePlus.instance.share(
      ShareParams(
        text: 'TaskFlow task summary\n\n$summary',
        subject: 'TaskFlow task summary',
      ),
    );
  }

  Future<File> _createFile(String name) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$name');
    if (await file.exists()) {
      await file.delete();
    }
    return file.create(recursive: true);
  }

  String _repeatLabel(Task task) {
    return switch (task.repeatType) {
      RepeatType.none => 'None',
      RepeatType.daily => 'Daily',
      RepeatType.weeklyCustom => 'Weekly',
    };
  }

  String _escape(String input) {
    final safe = input.replaceAll('"', '""');
    return '"$safe"';
  }
}
