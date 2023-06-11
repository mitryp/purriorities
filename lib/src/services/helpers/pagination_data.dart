typedef SortEntry = (String field, SortOrder order);

class PaginationData {
  final int? limit;
  final int? page;
  final SortEntry? sort;
  final Map<String, String>? filter;

  const PaginationData({this.limit, this.page, this.sort, this.filter});

  Map<String, String> toParams() {
    final filter = this.filter;
    final sort = this.sort;
    final (sortField, sortOrder) = sort ?? (null, null);

    return {
      if (limit != null) 'limit': '$limit',
      if (page != null) 'page': '$page',
      if (filter != null)
        for (final e in filter.entries) 'filter.${e.key}': e.value,
      if (sortField != null && sortOrder != null) 'sortBy': '$sortField:${sortOrder.name}',
    };
  }
}

enum SortOrder {
  asc,
  desc;
}
