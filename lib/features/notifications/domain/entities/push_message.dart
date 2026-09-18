// Feature: notifications · Layer: domain
// A push notification as the app sees it: display text plus the FCM `data`
// map the backend sends (`{type: action, action_id: <uuid>}`).

/// A received or tapped push notification.
class PushMessage {
  /// Creates a message.
  const PushMessage({this.title, this.body, this.data = const {}});

  /// `data.type` for a new pending action.
  static const String actionType = 'action';

  /// Notification title, when the payload has one.
  final String? title;

  /// Notification body, when the payload has one.
  final String? body;

  /// FCM data payload (string values).
  final Map<String, String> data;

  /// The action to open for this message, or `null` if it doesn't point at
  /// one (unknown type, missing / empty id).
  String? get actionId {
    final id = data['action_id'];
    if (data['type'] != actionType || id == null || id.isEmpty) return null;
    return id;
  }

  /// Builds a message from an untyped data map, keeping string values only.
  factory PushMessage.fromData(
    Map<String, dynamic> data, {
    String? title,
    String? body,
  }) =>
      PushMessage(
        title: title,
        body: body,
        data: {
          for (final entry in data.entries)
            if (entry.value is String) entry.key: entry.value as String,
        },
      );
}
