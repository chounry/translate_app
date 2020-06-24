// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatDataModelAdapter extends TypeAdapter<ChatDataModel> {
  @override
  final typeId = 1;

  @override
  ChatDataModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatDataModel(
      text: fields[0] as String,
      isMe: fields[1] as bool,
      icon: fields[2] as String,
      isDefault: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChatDataModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.isMe)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.isDefault);
  }
}
