// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sub_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Tab9SubEntryModel _$Tab9SubEntryModelFromJson(Map<String, dynamic> json) {
  return _Tab9SubEntryModel.fromJson(json);
}

/// @nodoc
mixin _$Tab9SubEntryModel {
// ignore: invalid_annotation_target
  @JsonKey(name: "ID")
  String? get uuid => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  String get task => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $Tab9SubEntryModelCopyWith<Tab9SubEntryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Tab9SubEntryModelCopyWith<$Res> {
  factory $Tab9SubEntryModelCopyWith(
          Tab9SubEntryModel value, $Res Function(Tab9SubEntryModel) then) =
      _$Tab9SubEntryModelCopyWithImpl<$Res, Tab9SubEntryModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "ID") String? uuid,
      DateTime date,
      String time,
      String task,
      String description});
}

/// @nodoc
class _$Tab9SubEntryModelCopyWithImpl<$Res, $Val extends Tab9SubEntryModel>
    implements $Tab9SubEntryModelCopyWith<$Res> {
  _$Tab9SubEntryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? date = null,
    Object? time = null,
    Object? task = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      task: null == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$Tab9SubEntryModelImplCopyWith<$Res>
    implements $Tab9SubEntryModelCopyWith<$Res> {
  factory _$$Tab9SubEntryModelImplCopyWith(_$Tab9SubEntryModelImpl value,
          $Res Function(_$Tab9SubEntryModelImpl) then) =
      __$$Tab9SubEntryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "ID") String? uuid,
      DateTime date,
      String time,
      String task,
      String description});
}

/// @nodoc
class __$$Tab9SubEntryModelImplCopyWithImpl<$Res>
    extends _$Tab9SubEntryModelCopyWithImpl<$Res, _$Tab9SubEntryModelImpl>
    implements _$$Tab9SubEntryModelImplCopyWith<$Res> {
  __$$Tab9SubEntryModelImplCopyWithImpl(_$Tab9SubEntryModelImpl _value,
      $Res Function(_$Tab9SubEntryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? date = null,
    Object? time = null,
    Object? task = null,
    Object? description = null,
  }) {
    return _then(_$Tab9SubEntryModelImpl(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      task: null == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$Tab9SubEntryModelImpl implements _Tab9SubEntryModel {
  const _$Tab9SubEntryModelImpl(
      {@JsonKey(name: "ID") this.uuid,
      required this.date,
      required this.time,
      required this.task,
      required this.description});

  factory _$Tab9SubEntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$Tab9SubEntryModelImplFromJson(json);

// ignore: invalid_annotation_target
  @override
  @JsonKey(name: "ID")
  final String? uuid;
  @override
  final DateTime date;
  @override
  final String time;
  @override
  final String task;
  @override
  final String description;

  @override
  String toString() {
    return 'Tab9SubEntryModel(uuid: $uuid, date: $date, time: $time, task: $task, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Tab9SubEntryModelImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.task, task) || other.task == task) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uuid, date, time, task, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Tab9SubEntryModelImplCopyWith<_$Tab9SubEntryModelImpl> get copyWith =>
      __$$Tab9SubEntryModelImplCopyWithImpl<_$Tab9SubEntryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$Tab9SubEntryModelImplToJson(
      this,
    );
  }
}

abstract class _Tab9SubEntryModel implements Tab9SubEntryModel {
  const factory _Tab9SubEntryModel(
      {@JsonKey(name: "ID") final String? uuid,
      required final DateTime date,
      required final String time,
      required final String task,
      required final String description}) = _$Tab9SubEntryModelImpl;

  factory _Tab9SubEntryModel.fromJson(Map<String, dynamic> json) =
      _$Tab9SubEntryModelImpl.fromJson;

  @override // ignore: invalid_annotation_target
  @JsonKey(name: "ID")
  String? get uuid;
  @override
  DateTime get date;
  @override
  String get time;
  @override
  String get task;
  @override
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$Tab9SubEntryModelImplCopyWith<_$Tab9SubEntryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
