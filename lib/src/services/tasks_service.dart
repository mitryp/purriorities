import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../data/models/task.dart';
import 'http/util/fetch_result.dart';

class TasksService {
  final Dio client;
  final BuildContext context;

  const TasksService(this.context, this.client);

  Future<FetchResult<dynamic>> completeTask(Task task) async {
    return const FetchResult.failure();
  }

  Future<FetchResult<dynamic>> refuseTask(Task task) async {
    return const FetchResult.failure();
  }
}
