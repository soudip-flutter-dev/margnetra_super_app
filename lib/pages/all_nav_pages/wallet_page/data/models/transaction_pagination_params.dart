import 'package:equatable/equatable.dart';
import 'package:margnetra_super_app/core/app_services/api_services/api_urls.dart';

/// Request parameters for transaction history pagination (page and size).
class TransactionPaginationParams extends Equatable {
  final int page;
  final int size;

  const TransactionPaginationParams({
    this.page = 1,
    this.size = 10,
  });

  /// Constructs the full endpoint URL including page and size query parameters.
  String toUrl() => ApiUrls.transactionList(page: page, size: size);

  /// Map representation of pagination query parameters.
  Map<String, dynamic> toQueryParameters() {
    return {
      'page': page,
      'size': size,
    };
  }

  TransactionPaginationParams copyWith({
    int? page,
    int? size,
  }) {
    return TransactionPaginationParams(
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }

  @override
  List<Object?> get props => [page, size];
}
