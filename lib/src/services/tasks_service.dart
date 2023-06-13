import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../data/models/rewards.dart';
import '../data/models/task_refuse_response.dart';
import '../typedefs.dart';
import 'http/util/fetch_result.dart';

class TasksService {
  final String basePath;
  final Dio client;
  final BuildContext context;

  const TasksService(this.context, this.client, [this.basePath = 'api/tasks']);

  /// Sends a complete task request to the server and returns a [Reward].
  Future<FetchResult<Reward>> completeTask(String taskId) {
    return FetchResult.transformResponse(
      client.post<JsonMap>('$basePath/$taskId/complete'),
      Reward.fromJson,
    );
  }

  /// Sends a complete task request to the server and returns a [TaskRefuseResponse].
  Future<FetchResult<TaskRefuseResponse>> refuseTask(String taskId) {
    return FetchResult.transformResponse(
      client.post<JsonMap>('$basePath/$taskId/refuse'),
      TaskRefuseResponse.fromJson,
    );
  }
}
