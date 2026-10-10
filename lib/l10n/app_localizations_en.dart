// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AI Cockpit';

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
  String get sendCode => 'Email me a code';

  @override
  String get brandTagline => 'Control panel for AI agents';

  @override
  String get brandMarkLabel => 'AI Cockpit';

  @override
  String get configErrorTitle => 'This build can\'t start';

  @override
  String get configErrorBody =>
      'It\'s missing its server settings. Please install AI Cockpit from the Play Store, or contact support.';

  @override
  String get signInHeadline => 'Approve what your agents do — from your phone.';

  @override
  String signInBody(int digits) {
    return 'Sign in with your email. We\'ll send you a $digits-digit code — no password to remember.';
  }

  @override
  String get emailHint => 'you@company.com';

  @override
  String get invalidEmail => 'Enter a valid email address.';

  @override
  String get termsNotice =>
      'By continuing you agree to the Terms & Privacy Policy.';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get sectionLegal => 'Legal';

  @override
  String get linkOpenFailed => 'Couldn\'t open the page. Try again later.';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountWarningTitle => 'This can\'t be undone';

  @override
  String get deleteAccountWarningAccount =>
      'Your account, profile and sign-in are deleted right away.';

  @override
  String get deleteAccountWarningDevice =>
      'This device stops getting notifications.';

  @override
  String get deleteAccountWarningOwner =>
      'If you own the workspace, its agents, actions and audit history are deleted too. Other members keep their accounts, each in a new workspace.';

  @override
  String get deleteAccountWarningApprover =>
      'If you\'re an approver, your past decisions stay in the workspace history without your name.';

  @override
  String get deleteAccountConfirmLabel => 'Type your email to confirm';

  @override
  String get deleteAccountConfirmMismatch =>
      'This doesn\'t match your account email.';

  @override
  String get deleteAccountButton => 'Delete my account';

  @override
  String deleteAccountFailed(String reason) {
    return 'Your account wasn\'t deleted. $reason';
  }

  @override
  String get deleteAccountDone => 'Your account was deleted.';

  @override
  String get back => 'Back';

  @override
  String otpSentTo(String email, int digits, int minutes) {
    return 'We sent a $digits-digit code to $email. It\'s valid for $minutes minutes.';
  }

  @override
  String get otpCodeLabel => 'Code';

  @override
  String get otpCodeHint => '123456';

  @override
  String get verifyCode => 'Verify code';

  @override
  String get changeEmail => 'Change email';

  @override
  String otpIncomplete(int digits) {
    return 'Enter all $digits digits.';
  }

  @override
  String get otpWrongOrExpired =>
      'That code is wrong or has expired. Check the latest email or send a new code.';

  @override
  String get resendCode => 'Resend code';

  @override
  String resendCodeIn(String time) {
    return 'Resend code in $time';
  }

  @override
  String get codeResent => 'We sent a new code.';

  @override
  String get otpTooManyRequests =>
      'Too many codes requested. Try again in a few minutes.';

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

  @override
  String get triggerRunLabel => 'Run agent';

  @override
  String get triggerStarted => 'Started';

  @override
  String get triggerRunFailed => 'Run failed';

  @override
  String triggerRateLimited(int seconds) {
    return 'Try again in ${seconds}s';
  }

  @override
  String triggerLastRun(String ago) {
    return 'last run · $ago';
  }

  @override
  String get triggerSectionTitle => 'Run from app (optional)';

  @override
  String get triggerAllowRunning => 'Allow running this agent from the app';

  @override
  String get triggerUrlLabel => 'Trigger URL';

  @override
  String get triggerUrlHint => 'https://your-workflow.example/start';

  @override
  String get triggerSave => 'Save trigger';

  @override
  String get triggerShownOnce => 'Trigger secret — shown once, copy it now';

  @override
  String get triggerSecretLabel => 'Trigger secret';

  @override
  String get triggerManageTitle => 'Run from app';

  @override
  String get triggerManageOpen => 'Manage run from app';

  @override
  String get triggerStatusNotSetUp => 'Not set up';

  @override
  String get triggerStatusOn => 'On';

  @override
  String get triggerStatusOff => 'Off';

  @override
  String triggerSecretHint(String hint) {
    return 'Secret ends in $hint';
  }

  @override
  String get triggerRotate => 'Rotate secret';

  @override
  String get triggerRotateTitle => 'Issue a new trigger secret?';

  @override
  String get triggerRotateBody =>
      'The current secret stops working immediately. Update your agent\'s verify step with the new secret.';

  @override
  String get triggerRotateConfirm => 'Continue';

  @override
  String get triggerNoInternet => 'No internet connection';

  @override
  String get triggerAgentRejected => 'Agent didn\'t accept the run';

  @override
  String get auditTriggerFired => 'Run requested';

  @override
  String get auditTriggerFailed => 'Run failed';

  @override
  String get errorFeatureDisabled => 'This feature isn\'t available yet.';

  @override
  String get errorTriggerDisabled => 'Running this agent is turned off.';

  @override
  String get errorForbidden => 'Only the workspace owner can do this.';

  @override
  String get errorAgentDisabled =>
      'This agent is turned off. Turn it back on to use it.';

  @override
  String get errorNotFound =>
      'This item no longer exists. Refresh and try again.';

  @override
  String get noAgentsApproverMessage =>
      'Ask your workspace owner to connect an agent. You\'ll review its actions here.';
}
