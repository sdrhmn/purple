import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timely/objectbox.g.dart';

export 'package:timely/common/buttons.dart';
export 'package:timely/common/inputs.dart';

final storeProvider = FutureProvider<Store>((ref) async {
  final docsDir = await getApplicationDocumentsDirectory();

  final taskStore = await openStore(directory: join(docsDir.path, "tasks"));

  return taskStore;
});
