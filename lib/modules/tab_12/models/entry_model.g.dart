// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$Tab12EntryModelImpl _$$Tab12EntryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$Tab12EntryModelImpl(
      uuid: json['ID'] as String?,
      activity: json['activity'] as String,
      objective: json['objective'] as String,
      tab2Model:
          SchedulingModel.fromJson(json['tab2Model'] as Map<String, dynamic>),
      importance: json['importance'] as int,
    );

Map<String, dynamic> _$$Tab12EntryModelImplToJson(
        _$Tab12EntryModelImpl instance) =>
    <String, dynamic>{
      'ID': instance.uuid,
      'activity': instance.activity,
      'objective': instance.objective,
      'tab2Model': instance.tab2Model,
      'importance': instance.importance,
    };
