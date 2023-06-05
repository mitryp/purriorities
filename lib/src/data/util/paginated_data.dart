import 'package:json_annotation/json_annotation.dart';

import '../../services/http/fetch/fetch_service.dart';
import '../../typedefs.dart';

part 'paginated_data.g.dart';

@JsonSerializable(createToJson: false, genericArgumentFactories: true)
class PaginatedData<T> {
  @JsonKey(fromJson: _totalPagesFromJson)
  final int totalPages;
  final List<T> data;

  const PaginatedData({required this.data, required this.totalPages});

  static PaginatedData<T> fromJson<T>(JsonMap json, FromJsonConverter<T> converter) =>
      _$PaginatedDataFromJson(
        json,
        (json) => converter(json as JsonMap),
      );
}

@JsonSerializable(createToJson: false)
class PaginationMetadata {
  final int totalPages;

  const PaginationMetadata({
    required this.totalPages,
  });

  factory PaginationMetadata.fromJson(JsonMap json) => _$PaginationMetadataFromJson(json);
}

int _totalPagesFromJson(JsonMap json) =>
    (json['meta'] as Map<String, dynamic>)['totalPages'] as int;
