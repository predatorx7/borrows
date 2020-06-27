import 'dart:async';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A repository which holds a Hive [Box] with helper functions.
class BaseRepository<M> {
  final TypeAdapter<M> adapter;
  final Box<M> box;
  final String boxName;

  M get first => box.values.first;

  Iterable<M> iterable() => box.values;

  bool get isRepositoryEmpty => box?.isEmpty ?? true;

  /// Creates a [BaseRepository] to wrap an open [box] of [adapter] with name [boxName]
  BaseRepository(this.boxName, this.adapter, this.box);

  /// Initiates Hive for flutter and returns a Hive [Box] wrapped with [BaseRepository]
  static Future<BaseRepository<M>> create<M>(
      String boxName, TypeAdapter<M> adapter) async {
    await Hive.initFlutter();
    Hive.registerAdapter<M>(adapter);
    final Box box = await Hive.openBox<M>(boxName);
    return BaseRepository<M>(boxName, adapter, box);
  }

  /// Check if box is open
  bool isBoxOpen() {
    return box?.isOpen ?? false;
  }

  /// Subscribe to Stream of BoxEvent which is triggered when a read/write
  /// operation is performed on [box]
  StreamSubscription<BoxEvent> listenStream(void Function(BoxEvent) onData) {
    return this.box.watch().listen(onData);
  }
}
