// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionsModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionsModelAdapter extends TypeAdapter<QuestionsModel> {
  @override
  final int typeId = 1;

  @override
  QuestionsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionsModel(
      id: fields[0] as String,
      question: fields[1] as String?,
      options: (fields[2] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, bool>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, QuestionsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.options);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
