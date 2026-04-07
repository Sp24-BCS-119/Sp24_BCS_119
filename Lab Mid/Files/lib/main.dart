import 'package:flutter/widgets.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bootstrap = await TaskFlowBootstrap.initialize();
  runApp(TaskFlowApp(bootstrap: bootstrap));
}
