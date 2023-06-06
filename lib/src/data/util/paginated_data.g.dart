// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedData<T> _$PaginatedDataFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    PaginatedData<T>(
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
      meta: json['meta'] == null
          ? null
          : PaginationMetadata.fromJson(json['meta'] as Map<String, dynamic>),
    );

PaginationMetadata _$PaginationMetadataFromJson(Map<String, dynamic> json) =>
    PaginationMetadata(
      totalPages: json['totalPages'] as int,
    );
