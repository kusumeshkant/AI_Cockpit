import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Cockpit'**
  String get appTitle;

  /// Navigation label for the pending actions feed
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get navFeed;

  /// Navigation label for connected agents
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get navConnections;

  /// Navigation label for the audit log
  ///
  /// In en, this message translates to:
  /// **'Audit log'**
  String get navAudit;

  /// Navigation label for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Short bottom-nav label for connections
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get navConnectShort;

  /// Short bottom-nav label for the audit log
  ///
  /// In en, this message translates to:
  /// **'Audit'**
  String get navAuditShort;

  /// Joins two short metadata values, e.g. platform · agent name
  ///
  /// In en, this message translates to:
  /// **'{first} · {second}'**
  String metaPair(String first, String second);

  /// Title of the pending actions feed
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get feedTitle;

  /// Feed subtitle: number of actions awaiting a decision
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing to review} =1{1 needs your review} other{{count} need your review}}'**
  String needsReviewCount(int count);

  /// Quoted excerpt of a drafted message
  ///
  /// In en, this message translates to:
  /// **'“{text}”'**
  String quotedPreview(String text);

  /// When an action was approved
  ///
  /// In en, this message translates to:
  /// **'Approved {time}'**
  String approvedAt(String time);

  /// When an action was rejected
  ///
  /// In en, this message translates to:
  /// **'Rejected {time}'**
  String rejectedAt(String time);

  /// Relative time under a minute
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// Relative time in minutes
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String minutesAgo(int count);

  /// Relative time in hours
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String hoursAgo(int count);

  /// Relative time in days
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String daysAgo(int count);

  /// Day label for yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Platform name (brand)
  ///
  /// In en, this message translates to:
  /// **'n8n'**
  String get platformN8n;

  /// Platform name (brand)
  ///
  /// In en, this message translates to:
  /// **'Make'**
  String get platformMake;

  /// Platform name (brand)
  ///
  /// In en, this message translates to:
  /// **'Zapier'**
  String get platformZapier;

  /// Agent built with custom code
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get platformCustom;

  /// Number of actions awaiting a decision
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No pending actions} =1{1 pending action} other{{count} pending actions}}'**
  String pendingCount(int count);

  /// Empty feed title
  ///
  /// In en, this message translates to:
  /// **'All clear'**
  String get emptyPendingTitle;

  /// Empty feed message
  ///
  /// In en, this message translates to:
  /// **'When an agent proposes an action, it will appear here.'**
  String get emptyPendingMessage;

  /// Title of the action detail screen
  ///
  /// In en, this message translates to:
  /// **'Review action'**
  String get actionDetailTitle;

  /// Approve an action
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// Reject an action
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Edit an action before approving
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Approve an edited action
  ///
  /// In en, this message translates to:
  /// **'Approve with edits'**
  String get approveWithEdits;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Hint for the reject reason field
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get rejectReasonHint;

  /// Shown when a decision was made elsewhere
  ///
  /// In en, this message translates to:
  /// **'This action was already decided.'**
  String get alreadyDecided;

  /// Snackbar after a decision is saved; delivery to the agent happens (and is retried) in the background, so don't claim it was sent
  ///
  /// In en, this message translates to:
  /// **'Decision recorded'**
  String get decisionRecorded;

  /// Label above the action summary
  ///
  /// In en, this message translates to:
  /// **'What it wants to do'**
  String get whatItWantsToDo;

  /// Title of the reject confirmation sheet
  ///
  /// In en, this message translates to:
  /// **'Reject this action?'**
  String get rejectSheetTitle;

  /// Email recipient label
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get emailTo;

  /// Email subject label
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get emailSubject;

  /// Email body label (edit mode)
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get emailBody;

  /// Footer on email drafts whose subject and body can be edited
  ///
  /// In en, this message translates to:
  /// **'Subject & body are editable'**
  String get emailEditableHint;

  /// Footer on actions with editable fields
  ///
  /// In en, this message translates to:
  /// **'Some fields are editable'**
  String get fieldsEditableHint;

  /// Label above raw action data
  ///
  /// In en, this message translates to:
  /// **'Payload'**
  String get payloadLabel;

  /// Diff: previous value
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get diffBefore;

  /// Diff: proposed value
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get diffAfter;

  /// Action status: pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// Action status: approved
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// Action status: rejected
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// Action status: expired
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get statusExpired;

  /// Title of the connections screen
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get connectionsTitle;

  /// Create a new agent connection
  ///
  /// In en, this message translates to:
  /// **'Connect agent'**
  String get connectAgent;

  /// Compact button to connect a new agent
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Agent status: accepting actions
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get statusLive;

  /// Agent status: disabled
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get statusPaused;

  /// When the agent last sent an action, e.g. 'last action 4 min ago'
  ///
  /// In en, this message translates to:
  /// **'last action {ago}'**
  String lastActionAgo(String ago);

  /// Agent has never sent an action
  ///
  /// In en, this message translates to:
  /// **'no actions yet'**
  String get noActionsYet;

  /// Lowercase activity note for a paused agent
  ///
  /// In en, this message translates to:
  /// **'paused'**
  String get pausedMeta;

  /// Title of the connect-agent screen
  ///
  /// In en, this message translates to:
  /// **'Connect an agent'**
  String get connectAgentTitle;

  /// Agent name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// Agent name placeholder
  ///
  /// In en, this message translates to:
  /// **'Email agent'**
  String get agentNameHint;

  /// Platform picker label
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platformLabel;

  /// Callback URL placeholder
  ///
  /// In en, this message translates to:
  /// **'https://your-workflow.example/webhook'**
  String get callbackUrlHint;

  /// Create the agent connection
  ///
  /// In en, this message translates to:
  /// **'Create connection'**
  String get createConnection;

  /// Credentials are displayed only once
  ///
  /// In en, this message translates to:
  /// **'Shown once — copy it now'**
  String get shownOnceWarning;

  /// HMAC signing secret label
  ///
  /// In en, this message translates to:
  /// **'Signing secret'**
  String get signingSecret;

  /// Banner after creating an agent
  ///
  /// In en, this message translates to:
  /// **'Waiting for your first test action from {platform}…'**
  String waitingForTest(String platform);

  /// Banner once a newly connected agent has sent its first action
  ///
  /// In en, this message translates to:
  /// **'First action received from {platform} — check your Actions feed.'**
  String firstActionReceived(String platform);

  /// Snackbar after sending a test action
  ///
  /// In en, this message translates to:
  /// **'Test action sent — check your Actions feed.'**
  String get testActionSent;

  /// Agent name validation error
  ///
  /// In en, this message translates to:
  /// **'Enter a name (1–60 characters).'**
  String get invalidAgentName;

  /// Callback URL validation error
  ///
  /// In en, this message translates to:
  /// **'Enter a valid https:// URL.'**
  String get invalidCallbackUrl;

  /// Empty connections title
  ///
  /// In en, this message translates to:
  /// **'No agents connected'**
  String get noAgentsTitle;

  /// Empty connections message
  ///
  /// In en, this message translates to:
  /// **'Connect your n8n, Make, Zapier or custom agent with a signed webhook.'**
  String get noAgentsMessage;

  /// Agent name field label
  ///
  /// In en, this message translates to:
  /// **'Agent name'**
  String get agentName;

  /// Callback URL field label
  ///
  /// In en, this message translates to:
  /// **'Callback URL'**
  String get callbackUrl;

  /// Inbound webhook URL label
  ///
  /// In en, this message translates to:
  /// **'Inbound URL'**
  String get inboundUrl;

  /// Inbound signing secret label
  ///
  /// In en, this message translates to:
  /// **'Inbound secret'**
  String get inboundSecret;

  /// Warning that the secret is shown only once
  ///
  /// In en, this message translates to:
  /// **'Copy this secret now. For your security it will not be shown again.'**
  String get secretShownOnceWarning;

  /// Send a sample action for an agent
  ///
  /// In en, this message translates to:
  /// **'Send a test action'**
  String get sendTestAction;

  /// Copy to clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Confirmation after copying
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// Title of the audit log screen
  ///
  /// In en, this message translates to:
  /// **'Audit log'**
  String get auditTitle;

  /// Empty audit log
  ///
  /// In en, this message translates to:
  /// **'No decisions recorded yet.'**
  String get noAuditEntries;

  /// Audit filter: every decision
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// Audit note: the action was edited, then approved
  ///
  /// In en, this message translates to:
  /// **'edited before approve'**
  String get editedBeforeApprove;

  /// Audit note quoting the rejection reason
  ///
  /// In en, this message translates to:
  /// **'note: “{reason}”'**
  String noteQuoted(String reason);

  /// Sign in button / title
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Sign out button
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Request a sign-in link
  ///
  /// In en, this message translates to:
  /// **'Send magic link'**
  String get sendMagicLink;

  /// Tagline under the wordmark (rendered uppercase)
  ///
  /// In en, this message translates to:
  /// **'Control panel for AI agents'**
  String get brandTagline;

  /// Sign-in headline
  ///
  /// In en, this message translates to:
  /// **'Approve what your agents do — from your phone.'**
  String get signInHeadline;

  /// Sign-in explanation
  ///
  /// In en, this message translates to:
  /// **'Sign in with your email. We\'ll send you a secure magic link — no password to remember.'**
  String get signInBody;

  /// Email field placeholder
  ///
  /// In en, this message translates to:
  /// **'you@company.com'**
  String get emailHint;

  /// Email validation error
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get invalidEmail;

  /// Legal notice under the sign-in button
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to the Terms & Privacy Policy.'**
  String get termsNotice;

  /// Back button tooltip
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Shown after the sign-in email is sent
  ///
  /// In en, this message translates to:
  /// **'We sent a sign-in email to {email}. Enter the 6-digit code from it.'**
  String otpSentTo(String email);

  /// One-time code field label
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get otpCodeLabel;

  /// One-time code placeholder
  ///
  /// In en, this message translates to:
  /// **'123456'**
  String get otpCodeHint;

  /// Submit the one-time code
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get verifyCode;

  /// Go back to the email step
  ///
  /// In en, this message translates to:
  /// **'Use a different email'**
  String get useDifferentEmail;

  /// One-time code is malformed, wrong or expired
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from the email.'**
  String get invalidOtp;

  /// Title of the settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings section: theme
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Theme section description
  ///
  /// In en, this message translates to:
  /// **'Choose how Cockpit looks on this device.'**
  String get appearanceDescription;

  /// Follow system theme
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Settings section: language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language section description
  ///
  /// In en, this message translates to:
  /// **'Choose the language used across the app.'**
  String get languageDescription;

  /// Follow the device language
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// English, written in English (endonym)
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Hindi, written in Hindi (endonym)
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// Theme control title
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// Language control title (wide layout)
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// Settings section: account
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get sectionAccount;

  /// Solo subscription plan
  ///
  /// In en, this message translates to:
  /// **'Solo plan'**
  String get planSolo;

  /// Pro subscription plan
  ///
  /// In en, this message translates to:
  /// **'Pro plan'**
  String get planPro;

  /// Consultant subscription plan
  ///
  /// In en, this message translates to:
  /// **'Consultant plan'**
  String get planConsultant;

  /// Number of workspaces the user belongs to
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 workspace} other{{count} workspaces}}'**
  String workspaceCount(int count);

  /// Settings section: about
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// App version
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// Accessibility label for loaders
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// Retry after an error
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Generic error
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// Network error
  ///
  /// In en, this message translates to:
  /// **'You appear to be offline. Check your connection.'**
  String get errorNetwork;

  /// Server error
  ///
  /// In en, this message translates to:
  /// **'The server could not complete the request.'**
  String get errorServer;

  /// Authentication error
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorAuth;

  /// Action expired (HTTP 410)
  ///
  /// In en, this message translates to:
  /// **'This action has expired and can no longer be decided.'**
  String get errorExpired;

  /// Android notification channel name (system settings)
  ///
  /// In en, this message translates to:
  /// **'Actions to review'**
  String get notificationChannelName;

  /// Android notification channel description (system settings)
  ///
  /// In en, this message translates to:
  /// **'Alerts when an agent proposes an action that needs your decision.'**
  String get notificationChannelDescription;

  /// HTTP 429 rate_limited
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment and try again.'**
  String get errorRateLimited;

  /// Request rejected as invalid (HTTP 422)
  ///
  /// In en, this message translates to:
  /// **'Some details are invalid. Please check and try again.'**
  String get errorValidation;

  /// Placeholder for screens not yet implemented
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// Run button tooltip / semantics (Agent Triggers)
  ///
  /// In en, this message translates to:
  /// **'Run agent'**
  String get triggerRunLabel;

  /// Status pill after a successful run
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get triggerStarted;

  /// Inline note when a run fails
  ///
  /// In en, this message translates to:
  /// **'Run failed'**
  String get triggerRunFailed;

  /// Inline note when runs are too frequent
  ///
  /// In en, this message translates to:
  /// **'Try again in {seconds}s'**
  String triggerRateLimited(int seconds);

  /// Last run time in the agent row
  ///
  /// In en, this message translates to:
  /// **'last run · {ago}'**
  String triggerLastRun(String ago);

  /// Collapsible section on the connect-agent screen
  ///
  /// In en, this message translates to:
  /// **'Run from app (optional)'**
  String get triggerSectionTitle;

  /// Switch label
  ///
  /// In en, this message translates to:
  /// **'Allow running this agent from the app'**
  String get triggerAllowRunning;

  /// Trigger URL field label
  ///
  /// In en, this message translates to:
  /// **'Trigger URL'**
  String get triggerUrlLabel;

  /// Trigger URL placeholder
  ///
  /// In en, this message translates to:
  /// **'https://your-workflow.example/start'**
  String get triggerUrlHint;

  /// Save the trigger configuration
  ///
  /// In en, this message translates to:
  /// **'Save trigger'**
  String get triggerSave;

  /// Warning above the one-time trigger secret
  ///
  /// In en, this message translates to:
  /// **'Trigger secret — shown once, copy it now'**
  String get triggerShownOnce;

  /// Trigger secret field label
  ///
  /// In en, this message translates to:
  /// **'Trigger secret'**
  String get triggerSecretLabel;

  /// Audit entry for trigger_fired
  ///
  /// In en, this message translates to:
  /// **'Agent run started'**
  String get auditTriggerFired;

  /// Audit entry for trigger_failed
  ///
  /// In en, this message translates to:
  /// **'Run failed'**
  String get auditTriggerFailed;

  /// feature_disabled error
  ///
  /// In en, this message translates to:
  /// **'This feature isn\'t available yet.'**
  String get errorFeatureDisabled;

  /// trigger_disabled error
  ///
  /// In en, this message translates to:
  /// **'Running this agent is turned off.'**
  String get errorTriggerDisabled;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
