import 'package:freezed_annotation/freezed_annotation.dart';
part 'entry_model.freezed.dart';
part 'entry_model.g.dart';

@Freezed()
class Tab9EntryModel with _$Tab9EntryModel {
  const factory Tab9EntryModel({
    // ignore: invalid_annotation_target
    @JsonKey(name: "ID") String? uuid,
    required String condition,
    required int criticality,
    required String care,
    required String lessonLearnt,
  }) = _Tab9EntryModel;

  factory Tab9EntryModel.fromJson(Map<String, dynamic> json) =>
      _$Tab9EntryModelFromJson(json);
}
