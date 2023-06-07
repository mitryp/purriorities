typedef PaginationData = ({
  int? limit,
  int? page,
  SortEntry? sort,
  Map<String, String>? filter,
});

extension PaginationDataToParams on PaginationData {
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

typedef SortEntry = (String field, SortOrder order);

enum SortOrder {
  asc,
  desc;
}

const PaginationData emptyPaginationData = (limit: null, page: null, sort: null, filter: null);
