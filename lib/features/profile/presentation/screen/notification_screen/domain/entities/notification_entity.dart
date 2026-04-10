// lib/features/notification/domain/entities/notification_entity.dart

class NotificationEntity {
  final int id;
  final String title;
  final String body;
  final String type;
  final NotificationDataEntity data;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.isRead,
    required this.createdAt,
  });

  // ── Computed ────────────────────────────────────────────────
  bool get isBookingRelated => data.bookingId != null;

  String get displayTime {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inMinutes < 1) return 'just_now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

// ── Notification Data Entity ──────────────────────────────────────────────────

class NotificationDataEntity {
  final String? bookingId;
  final String? bookingRef;
  final String? finalAmount;

  const NotificationDataEntity({
    this.bookingId,
    this.bookingRef,
    this.finalAmount,
  });
}

// ── Response Entity ───────────────────────────────────────────────────────────

class NotificationResponseEntity {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationResponseEntity({
    required this.notifications,
    required this.unreadCount,
  });
}
