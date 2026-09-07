class WasteAmount {
  final double? kg;
  final double? ltr;
  final double? no; // 👈 add — count-based units (e.g. drums, containers, batteries)

  WasteAmount({this.kg, this.ltr, this.no});

  factory WasteAmount.fromJson(Map<String, dynamic>? json) {
    if (json == null) return WasteAmount();
    return WasteAmount(
      kg: json['Kg'] == null ? null : (json['Kg'] as num).toDouble(),
      ltr: json['Ltr'] == null ? null : (json['Ltr'] as num).toDouble(),
      no: json['No'] == null ? null : (json['No'] as num).toDouble(), // 👈 add
    );
  }

  Map<String, dynamic> toJson() => {
        if (kg != null) 'Kg': kg,
        if (ltr != null) 'Ltr': ltr,
        if (no != null) 'No': no, // 👈 add
      };

  /// Human readable summary, e.g. "60 Ltr, 700 Kg, 240 No" or "-" if empty.
  String get display {
    final parts = <String>[];
    if (ltr != null) parts.add('${_formatNum(ltr!)} Ltr');
    if (kg != null) parts.add('${_formatNum(kg!)} Kg');
    if (no != null) parts.add('${_formatNum(no!)} No'); // 👈 add
    return parts.isEmpty ? '-' : parts.join(', ');
  }

  static String _formatNum(double n) =>
      n == n.roundToDouble() ? n.toInt().toString() : n.toString();
}

class OfficerNotificationModel {
  final String id;
  final String membershipId;
  final String industryName;
  final WasteAmount allocated;
  final WasteAmount utilized;
  final String subject;
  final int month;
  final int year;
  final int isRead;
  final DateTime? createdAt;

  OfficerNotificationModel({
    required this.id,
    required this.membershipId,
    required this.industryName,
    required this.allocated,
    required this.utilized,
    required this.subject,
    required this.month,
    required this.year,
    required this.isRead,
    this.createdAt,
  });

  factory OfficerNotificationModel.fromJson(Map<String, dynamic> json) {
    return OfficerNotificationModel(
      id: json['id']?.toString() ?? '',
      membershipId: json['membershipId']?.toString() ?? '',
      industryName: json['industryName']?.toString() ?? '',
      allocated: WasteAmount.fromJson(json['allocated'] as Map<String, dynamic>?),
      utilized: WasteAmount.fromJson(json['utilized'] as Map<String, dynamic>?),
      subject: json['subject']?.toString() ?? '',
      month: json['month'] is int
          ? json['month']
          : int.tryParse('${json['month']}') ?? 0,
      year: json['year'] is int
          ? json['year']
          : int.tryParse('${json['year']}') ?? 0,
      isRead: json['isRead'] is int
          ? json['isRead']
          : int.tryParse('${json['isRead']}') ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'].toString()),
    );
  }

  bool get read => isRead == 1;

  static const List<String> _monthNames = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String get monthName => (month >= 1 && month <= 12) ? _monthNames[month] : '';

  /// e.g. "August 2026"
  String get periodLabel => monthName.isEmpty ? '$year' : '$monthName $year';

  /// e.g. "9 min ago", "2 hr ago", "3 days ago", or a date once it's old.
  String get timeAgo {
    if (createdAt == null) return '';
    final diff = DateTime.now().toUtc().difference(createdAt!.toUtc());
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays < 7) return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
  }
}

/// Wraps the top-level `data` array from the get-Officer-notifications response.
class OfficerNotificationListResponse {
  final List<OfficerNotificationModel> notifications;

  OfficerNotificationListResponse({required this.notifications});

  factory OfficerNotificationListResponse.fromJson(List<dynamic> data) {
    return OfficerNotificationListResponse(
      notifications: data
          .map((e) =>
              OfficerNotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}