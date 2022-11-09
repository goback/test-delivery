import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

abstract class CursorPaginationBase {}

class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

class CursorPaginationLoading extends CursorPaginationBase {}

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPaginationModel<T> extends CursorPaginationBase {
  final CursorPaginationMetaModel meta;
  final List<T> data;

  CursorPaginationModel({
    required this.meta,
    required this.data,
  });

  CursorPaginationModel copyWith({
    CursorPaginationMetaModel? meta,
    List<T>? data,
  }) {
    return CursorPaginationModel(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  factory CursorPaginationModel.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationModelFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMetaModel {
  final int count;
  final bool hasMore;

  CursorPaginationMetaModel({
    required this.count,
    required this.hasMore,
  });

  CursorPaginationMetaModel copyWith({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMetaModel(
      count: count ?? this.count,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  factory CursorPaginationMetaModel.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaModelFromJson(json);
}

class CursorPaginationRefetching<T> extends CursorPaginationModel<T> {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

class CursorPaginationFetchingMore<T> extends CursorPaginationModel<T> {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}
