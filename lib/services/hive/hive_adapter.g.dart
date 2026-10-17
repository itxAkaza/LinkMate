// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapter.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class LinkItemAdapter extends TypeAdapter<LinkItem> {
  @override
  final typeId = 0;

  @override
  LinkItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LinkItem(
      metaDescription: fields[9] == null ? "link..." : fields[9] as String?,
      metaTitle: fields[10] as String?,
      metaImage: fields[11] as String?,
      url: fields[5] as String,
      description: fields[1] as String?,
      category: fields[2] as String?,
      tags: fields[3] == null ? const [] : (fields[3] as List).cast<String>(),
      reminder: fields[4] as DateTime?,
      isPrivate: fields[6] == null ? false : fields[6] as bool,
      status: fields[7] == null ? 'pending' : fields[7] as String,
      isFavourite: fields[8] == null ? false : fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LinkItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.reminder)
      ..writeByte(5)
      ..write(obj.url)
      ..writeByte(6)
      ..write(obj.isPrivate)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.isFavourite)
      ..writeByte(9)
      ..write(obj.metaDescription)
      ..writeByte(10)
      ..write(obj.metaTitle)
      ..writeByte(11)
      ..write(obj.metaImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
