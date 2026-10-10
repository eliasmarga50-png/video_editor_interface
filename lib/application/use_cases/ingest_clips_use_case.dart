import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class IngestClipsUseCase {
  Future<List<String>> execute(List<String> originalPaths) async {
    final appDir = await getApplicationDocumentsDirectory();
    final sandboxDir = Directory(p.join(appDir.path, 'sandbox_clips'));
    if (!await sandboxDir.exists()) {
      await sandboxDir.create(recursive: true);
    }

    final copiedPaths = <String>[];
    for (final path in originalPaths) {
      final file = File(path);
      if (await file.exists()) {
        final fileName = p.basename(path);
        final targetPath = p.join(sandboxDir.path, '${DateTime.now().millisecondsSinceEpoch}_$fileName');
        await file.copy(targetPath);
        copiedPaths.add(targetPath);
      }
    }
    return copiedPaths;
  }
}