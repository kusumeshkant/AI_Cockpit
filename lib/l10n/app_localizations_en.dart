// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cockpit';

  @override
  String get navFeed => 'Actions';

  @override
  String get navConnections => 'Connections';

  @override
  String get navAudit => 'Audit log';

  @override
  String get navSettings => 'Settings';

  @override
  String get navConnectShort => 'Connect';

  @override
  String get navAuditShort => 'Audit';

  @override
  String metaPair(String first, String second) {
    return '$first · $second';
  }

  @override
  String get feedTitle => 'Pending';

  @override
  String needsReviewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count need your review',
      one: '1 needs your review',
      zero: 'Nothing to review',
    );
    return '$_temp0';
  }

  @override
  String quotedPreview(String text) {
    return '“$text”';
  }

  @override
  String approvedAt(String time) {
    return 'Approved $time';
  }

  @override
  String rejectedAt(String time) {
    return 'Rejected $time';
  }

  @override
  String get justNow => 'just now';

  @override
  String minutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String get platformN8n => 'n8n';

  @override
  String get platformMake => 'Make';

  @override
  String get platformZapier => 'Zapier';

  @override
  String get platformCustom => 'Custom';

  @override
  String pendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pending actions',
      one: '1 pending action',
      zero: 'No pending actions',
    );
    return '$_temp0';
  }

  @override
  String get emptyPendingTitle => 'All clear';

  @override
  String get emptyPendingMessage =>
      'When an agent proposes an action, it will appear here.';

  @override
  String get actionDetailTitle => 'Review action';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get edit => 'Edit';

  @override
  String get approveWithEdits => 'Approve with edits';

  @override
  String get cancel => 'Cancel';

  @override
  String get rejectReasonHint => 'Reason (optional)';

  @override
  String get alreadyDecided => 'This action was already decided.';

  @override
  String get decisionRecorded => 'Decision recorded';

  @override
  String get whatItWantsToDo => 'What it wants to do';

  @override
  String get rejectSheetTitle => 'Reject this action?';

  @override
  String get emailTo => 'To';

  @override
  String get emailSubject => 'Subject';

  @override
  String get emailBody => 'Body';

  @override
  String get emailEditableHint => 'Subject & body are editable';

  @override
  String get fieldsEditableHint => 'Some fields are editable';

  @override
  String get payloadLabel => 'Payload';

  @override
  String get diffBefore => 'Before';

  @override
  String get diffAfter => 'After';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusExpired => 'Expired';

  @override
  String get connectionsTitle => 'Connections';

  @override
  String get connectAgent => 'Connect agent';

  @override
  String get connect => 'Connect';

  @override
  String get statusLive => 'Live';

  @override
  String get statusPaused => 'Paused';

  @override
  String lastActionAgo(String ago) {
    return 'last action $ago';
  }

  @override
  String get noActionsYet => 'no actions yet';

  @override
  String get pausedMeta => 'paused';

  @override
  String get connectAgentTitle => 'Connect an agent';

  @override
  String get nameLabel => 'Name';

  @override
  String get agentNameHint => 'Email agent';

  @override
  String get platformLabel => 'Platform';

  @override
  String get callbackUrlHint => 'https://your-workflow.example/webhook';

  @override
  String get createConnection => 'Create connection';

  @override
  String get shownOnceWarning => 'Shown once — copy it now';

  @override
  String get signingSecret => 'Signing secret';

  @override
  String waitingForTest(String platform) {
    return 'Waiting for your first test action from $platform…';
  }

  @override
  String firstActionReceived(String platform) {
    return 'First action received from $platform — check your Actions feed.';
  }

  @override
  String get testActionSent => 'Test action sent — check your Actions feed.';

  @override
  String get invalidAgentName => 'Enter a name (1–60 characters).';

  @override
  String get invalidCallbackUrl => 'Enter a valid https:// URL.';

  @override
  String get noAgentsTitle => 'No agents connected';

  @override
  String get noAgentsMessage =>
      'Connect your n8n, Make, Zapier or custom agent with a signed webhook.';

  @override
  String get agentName => 'Agent name';

  @override
  String get callbackUrl => 'Callback URL';

  @override
  String get inboundUrl => 'Inbound URL';

  @override
  String get inboundSecret => 'Inbound secret';

  @override
  String get secretShownOnceWarning =>
      'Copy this secret now. For your security it will not be shown again.';

  @override
  String get sendTestAction => 'Send a test action';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String get auditTitle => 'Audit log';

  @override
  String get noAuditEntries => 'No decisions recorded yet.';

  @override
  String get filterAll => 'All';

  @override
  String get editedBeforeApprove => 'edited before approve';

  @override
  String noteQuoted(String reason) {
    return 'note: “$reason”';
  }

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get email => 'Email';

  @override
  String get sendMagicLink => 'Send magic link';

  @override
  String get brandTagline => 'Control panel for AI agents';

  @override
  String get signInHeadline => 'Approve what your agents do — from your phone.';

  @override
  String get signInBody =>
      'Sign in with your email. We\'ll send you a secure magic link — no password to remember.';

  @override
  String get emailHint => 'you@company.com';

  @override
  String get invalidEmail => 'Enter a valid email address.';

  @override
  String get termsNotice =>
      'By continuing you agree to the Terms & Privacy Policy.';

  @override
  String get back => 'Back';

  @override
  String otpSentTo(String email) {
    return 'We sent a sign-in email to $email. Enter the 6-digit code from it.';
  }

  @override
  String get otpCodeLabel => 'Code';

  @override
  String get otpCodeHint => '123456';

  @override
  String get verifyCode => 'Verify code';

  @override
  String get useDifferentEmail => 'Use a different email';

  @override
  String get invalidOtp => 'Enter the 6-digit code from the email.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceDescription =>
      'Choose how Cockpit looks on this device.';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageDescription => 'Choose the language used across the app.';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get themeLabel => 'Theme';

  @override
  String get appLanguage => 'App language';

  @override
  String get sectionAccount => 'Account';

  @override
  String get planSolo => 'Solo plan';

  @override
  String get planPro => 'Pro plan';

  @override
  String get planConsultant => 'Consultant plan';

  @override
  String workspaceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count workspaces',
      one: '1 workspace',
    );
    return '$_temp0';
  }

  @override
  String get about => 'About';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get loading => 'Loading';

  @override
  String get retry => 'Retry';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'You appear to be offline. Check your connection.';

  @override
  String get errorServer => 'The server could not complete the request.';

  @override
  String get errorAuth => 'Your session has expired. Please sign in again.';

  @override
  String get errorExpired =>
      'This action has expired and can no longer be decided.';

  @override
  String get notificationChannelName => 'Actions to review';

  @override
  String get notificationChannelDescription =>
      'Alerts when an agent proposes an action that needs your decision.';

  @override
  String get errorRateLimited =>
      'Too many requests. Please wait a moment and try again.';

  @override
  String get errorValidation =>
      'Some details are invalid. Please check and try again.';

  @override
  String get comingSoon => 'Coming soon';
}
