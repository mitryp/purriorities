class ResourceNotFetchedException extends StateError {
  ResourceNotFetchedException(String? message) : super(message ?? 'Ресурс не було отримано');
}