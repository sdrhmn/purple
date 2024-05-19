// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$Tab9SubEntryModelImpl _$$Tab9SubEntryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$Tab9SubEntryModelImpl(
      uuid: json['ID'] as String?,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      task: json['task'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$Tab9SubEntryModelImplToJson(
        _$Tab9SubEntryModelImpl instance) =>
    <String, dynamic>{
      'ID': instance.uuid,
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'task': instance.task,
      'description': instance.description,
    };
