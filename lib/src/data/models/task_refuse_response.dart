import 'package:json_annotation/json_annotation.dart';

import '../../typedefs.dart';
import 'punishments.dart';
import 'rewards.dart';

part 'task_refuse_response.g.dart';

@JsonSerializable(createToJson: false)
class TaskRefuseResponse {
  final Reward reward;
  final PendingPunishment punishment;

  const TaskRefuseResponse({required this.reward, required this.punishment});

  factory TaskRefuseResponse.fromJson(JsonMap json) => _$TaskRefuseResponseFromJson(json);
}
