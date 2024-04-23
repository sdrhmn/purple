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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Tab9EntryModel _$Tab9EntryModelFromJson(Map<String, dynamic> json) {
  return _Tab9EntryModel.fromJson(json);
}

/// @nodoc
mixin _$Tab9EntryModel {
// ignore: invalid_annotation_target
  @JsonKey(name: "ID")
  String? get uuid => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;
  int get criticality => throw _privateConstructorUsedError;
  String get care => throw _privateConstructorUsedError;
  String get lessonLearnt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $Tab9EntryModelCopyWith<Tab9EntryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Tab9EntryModelCopyWith<$Res> {
  factory $Tab9EntryModelCopyWith(
          Tab9EntryModel value, $Res Function(Tab9EntryModel) then) =
      _$Tab9EntryModelCopyWithImpl<$Res, Tab9EntryModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "ID") String? uuid,
      String condition,
      int criticality,
      String care,
      String lessonLearnt});
}

/// @nodoc
class _$Tab9EntryModelCopyWithImpl<$Res, $Val extends Tab9EntryModel>
    implements $Tab9EntryModelCopyWith<$Res> {
  _$Tab9EntryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? condition = null,
    Object? criticality = null,
    Object? care = null,
    Object? lessonLearnt = null,
  }) {
    return _then(_value.copyWith(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String,
      criticality: null == criticality
          ? _value.criticality
          : criticality // ignore: cast_nullable_to_non_nullable
              as int,
      care: null == care
          ? _value.care
          : care // ignore: cast_nullable_to_non_nullable
              as String,
      lessonLearnt: null == lessonLearnt
          ? _value.lessonLearnt
          : lessonLearnt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$Tab9EntryModelImplCopyWith<$Res>
    implements $Tab9EntryModelCopyWith<$Res> {
  factory _$$Tab9EntryModelImplCopyWith(_$Tab9EntryModelImpl value,
          $Res Function(_$Tab9EntryModelImpl) then) =
      __$$Tab9EntryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "ID") String? uuid,
      String condition,
      int criticality,
      String care,
      String lessonLearnt});
}

/// @nodoc
class __$$Tab9EntryModelImplCopyWithImpl<$Res>
    extends _$Tab9EntryModelCopyWithImpl<$Res, _$Tab9EntryModelImpl>
    implements _$$Tab9EntryModelImplCopyWith<$Res> {
  __$$Tab9EntryModelImplCopyWithImpl(
      _$Tab9EntryModelImpl _value, $Res Function(_$Tab9EntryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? condition = null,
    Object? criticality = null,
    Object? care = null,
    Object? lessonLearnt = null,
  }) {
    return _then(_$Tab9EntryModelImpl(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String,
      criticality: null == criticality
          ? _value.criticality
          : criticality // ignore: cast_nullable_to_non_nullable
              as int,
      care: null == care
          ? _value.care
          : care // ignore: cast_nullable_to_non_nullable
              as String,
      lessonLearnt: null == lessonLearnt
          ? _value.lessonLearnt
          : lessonLearnt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$Tab9EntryModelImpl implements _Tab9EntryModel {
  const _$Tab9EntryModelImpl(
      {@JsonKey(name: "ID") this.uuid,
      required this.condition,
      required this.criticality,
      required this.care,
      required this.lessonLearnt});

  factory _$Tab9EntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$Tab9EntryModelImplFromJson(json);

// ignore: invalid_annotation_target
  @override
  @JsonKey(name: "ID")
  final String? uuid;
  @override
  final String condition;
  @override
  final int criticality;
  @override
  final String care;
  @override
  final String lessonLearnt;

  @override
  String toString() {
    return 'Tab9EntryModel(uuid: $uuid, condition: $condition, criticality: $criticality, care: $care, lessonLearnt: $lessonLearnt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Tab9EntryModelImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.criticality, criticality) ||
                other.criticality == criticality) &&
            (identical(other.care, care) || other.care == care) &&
            (identical(other.lessonLearnt, lessonLearnt) ||
                other.lessonLearnt == lessonLearnt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, uuid, condition, criticality, care, lessonLearnt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Tab9EntryModelImplCopyWith<_$Tab9EntryModelImpl> get copyWith =>
      __$$Tab9EntryModelImplCopyWithImpl<_$Tab9EntryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$Tab9EntryModelImplToJson(
      this,
    );
  }
}

abstract class _Tab9EntryModel implements Tab9EntryModel {
  const factory _Tab9EntryModel(
      {@JsonKey(name: "ID") final String? uuid,
      required final String condition,
      required final int criticality,
      required final String care,
      required final String lessonLearnt}) = _$Tab9EntryModelImpl;

  factory _Tab9EntryModel.fromJson(Map<String, dynamic> json) =
      _$Tab9EntryModelImpl.fromJson;

  @override // ignore: invalid_annotation_target
  @JsonKey(name: "ID")
  String? get uuid;
  @override
  String get condition;
  @override
  int get criticality;
  @override
  String get care;
  @override
  String get lessonLearnt;
  @override
  @JsonKey(ignore: true)
  _$$Tab9EntryModelImplCopyWith<_$Tab9EntryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
