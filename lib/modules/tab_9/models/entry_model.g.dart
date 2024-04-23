// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$Tab9EntryModelImpl _$$Tab9EntryModelImplFromJson(Map<String, dynamic> json) =>
    _$Tab9EntryModelImpl(
      uuid: json['ID'] as String?,
      condition: json['condition'] as String,
      criticality: json['criticality'] as int,
      care: json['care'] as String,
      lessonLearnt: json['lessonLearnt'] as String,
    );

Map<String, dynamic> _$$Tab9EntryModelImplToJson(
        _$Tab9EntryModelImpl instance) =>
    <String, dynamic>{
      'ID': instance.uuid,
      'condition': instance.condition,
      'criticality': instance.criticality,
      'care': instance.care,
      'lessonLearnt': instance.lessonLearnt,
    };
