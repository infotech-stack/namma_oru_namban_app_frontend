// lib/features/notification/data/model/notification_model.dart

import 'package:userapp/features/profile/presentation/screen/notification_screen/domain/entities/notification_entity.dart';

class NotificationDataModel {
  final String? bookingId;
  final String? bookingRef;
  final String? finalAmount;

  const NotificationDataModel({
    this.bookingId,
    this.bookingRef,
    this.finalAmount,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(
      bookingId: _parseNullableString(json['bookingId']),
      bookingRef: _parseNullableString(json['bookingRef']),
      finalAmount: _parseNullableString(json['finalAmount']),
    );
  }

  static String? _parseNullableString(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  NotificationDataEntity toEntity() => NotificationDataEntity(
    bookingId: bookingId,
    bookingRef: bookingRef,
    finalAmount: finalAmount,
  );
}

// ── Notification Model ────────────────────────────────────────────────────────

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String type;
  final NotificationDataModel data;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: _parseInt(json['id']),
      title: _parseString(json['title']),
      body: _parseString(json['body']),
      type: _parseString(json['type']),
      data: json['data'] != null
          ? NotificationDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : const NotificationDataModel(),
      isRead: _parseBool(json['is_read']),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static String _parseString(dynamic v) => v?.toString() ?? '';

  static int _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static bool _parseBool(dynamic v) {
    if (v is bool) return v;
    if (v is int) return v == 1;
    if (v is String) return v.toLowerCase() == 'true';
    return false;
  }

  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    title: title,
    body: body,
    type: type,
    data: data.toEntity(),
    isRead: isRead,
    createdAt: createdAt,
  );
}

// ── Response Model ────────────────────────────────────────────────────────────

class NotificationResponseModel {
  final List<NotificationModel> notifications;
  final int unreadCount;

  const NotificationResponseModel({
    required this.notifications,
    required this.unreadCount,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      notifications: (json['notifications'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(NotificationModel.fromJson)
          .toList(),
      unreadCount: _parseInt(json['unreadCount']),
    );
  }

  static int _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  NotificationResponseEntity toEntity() => NotificationResponseEntity(
    notifications: notifications.map((n) => n.toEntity()).toList(),
    unreadCount: unreadCount,
  );
}
