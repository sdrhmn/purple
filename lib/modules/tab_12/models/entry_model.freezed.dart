// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tab12EntryModel _$Tab12EntryModelFromJson(Map<String, dynamic> json) {
  return _Tab12EntryModel.fromJson(json);
}

/// @nodoc
mixin _$Tab12EntryModel {
// ignore: invalid_annotation_target
  @JsonKey(name: "ID")
  String? get uuid => throw _privateConstructorUsedError;
  String get activity => throw _privateConstructorUsedError;
  String get objective => throw _privateConstructorUsedError;
  SchedulingModel get tab2Model => throw _privateConstructorUsedError;
  int get importance => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $Tab12EntryModelCopyWith<Tab12EntryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Tab12EntryModelCopyWith<$Res> {
  factory $Tab12EntryModelCopyWith(
          Tab12EntryModel value, $Res Function(Tab12EntryModel) then) =
      _$Tab12EntryModelCopyWithImpl<$Res, Tab12EntryModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "ID") String? uuid,
      String activity,
      String objective,
      SchedulingModel tab2Model,
      int importance});
}

/// @nodoc
class _$Tab12EntryModelCopyWithImpl<$Res, $Val extends Tab12EntryModel>
    implements $Tab12EntryModelCopyWith<$Res> {
  _$Tab12EntryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? activity = null,
    Object? objective = null,
    Object? tab2Model = null,
    Object? importance = null,
  }) {
    return _then(_value.copyWith(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      activity: null == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as String,
      objective: null == objective
          ? _value.objective
          : objective // ignore: cast_nullable_to_non_nullable
              as String,
      tab2Model: null == tab2Model
          ? _value.tab2Model
          : tab2Model // ignore: cast_nullable_to_non_nullable
              as SchedulingModel,
      importance: null == importance
          ? _value.importance
          : importance // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$Tab12EntryModelImplCopyWith<$Res>
    implements $Tab12EntryModelCopyWith<$Res> {
  factory _$$Tab12EntryModelImplCopyWith(_$Tab12EntryModelImpl value,
          $Res Function(_$Tab12EntryModelImpl) then) =
      __$$Tab12EntryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "ID") String? uuid,
      String activity,
      String objective,
      SchedulingModel tab2Model,
      int importance});
}

/// @nodoc
class __$$Tab12EntryModelImplCopyWithImpl<$Res>
    extends _$Tab12EntryModelCopyWithImpl<$Res, _$Tab12EntryModelImpl>
    implements _$$Tab12EntryModelImplCopyWith<$Res> {
  __$$Tab12EntryModelImplCopyWithImpl(
      _$Tab12EntryModelImpl _value, $Res Function(_$Tab12EntryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? activity = null,
    Object? objective = null,
    Object? tab2Model = null,
    Object? importance = null,
  }) {
    return _then(_$Tab12EntryModelImpl(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      activity: null == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as String,
      objective: null == objective
          ? _value.objective
          : objective // ignore: cast_nullable_to_non_nullable
              as String,
      tab2Model: null == tab2Model
          ? _value.tab2Model
          : tab2Model // ignore: cast_nullable_to_non_nullable
              as SchedulingModel,
      importance: null == importance
          ? _value.importance
          : importance // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$Tab12EntryModelImpl implements _Tab12EntryModel {
  _$Tab12EntryModelImpl(
      {@JsonKey(name: "ID") this.uuid,
      required this.activity,
      required this.objective,
      required this.tab2Model,
      required this.importance});

  factory _$Tab12EntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$Tab12EntryModelImplFromJson(json);

// ignore: invalid_annotation_target
  @override
  @JsonKey(name: "ID")
  final String? uuid;
  @override
  final String activity;
  @override
  final String objective;
  @override
  final SchedulingModel tab2Model;
  @override
  final int importance;

  @override
  String toString() {
    return 'Tab12EntryModel(uuid: $uuid, activity: $activity, objective: $objective, tab2Model: $tab2Model, importance: $importance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Tab12EntryModelImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.activity, activity) ||
                other.activity == activity) &&
            (identical(other.objective, objective) ||
                other.objective == objective) &&
            (identical(other.tab2Model, tab2Model) ||
                other.tab2Model == tab2Model) &&
            (identical(other.importance, importance) ||
                other.importance == importance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, uuid, activity, objective, tab2Model, importance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Tab12EntryModelImplCopyWith<_$Tab12EntryModelImpl> get copyWith =>
      __$$Tab12EntryModelImplCopyWithImpl<_$Tab12EntryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$Tab12EntryModelImplToJson(
      this,
    );
  }
}

abstract class _Tab12EntryModel implements Tab12EntryModel {
  factory _Tab12EntryModel(
      {@JsonKey(name: "ID") final String? uuid,
      required final String activity,
      required final String objective,
      required final SchedulingModel tab2Model,
      required final int importance}) = _$Tab12EntryModelImpl;

  factory _Tab12EntryModel.fromJson(Map<String, dynamic> json) =
      _$Tab12EntryModelImpl.fromJson;

  @override // ignore: invalid_annotation_target
  @JsonKey(name: "ID")
  String? get uuid;
  @override
  String get activity;
  @override
  String get objective;
  @override
  SchedulingModel get tab2Model;
  @override
  int get importance;
  @override
  @JsonKey(ignore: true)
  _$$Tab12EntryModelImplCopyWith<_$Tab12EntryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
