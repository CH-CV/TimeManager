part of 'pomodoro_record.dart';

class PomodoroRecordAdapter extends TypeAdapter<PomodoroRecord> {
  @override
  final int typeId = 1;

  @override
  PomodoroRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroRecord(
      id: fields[0] as String,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as DateTime?,
      typeIndex: fields[3] as int,
      taskId: fields[4] as String?,
      completed: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.typeIndex)
      ..writeByte(4)
      ..write(obj.taskId)
      ..writeByte(5)
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
