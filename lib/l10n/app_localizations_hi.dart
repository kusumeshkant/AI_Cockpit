// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'कॉकपिट';

  @override
  String get navFeed => 'कार्य';

  @override
  String get navConnections => 'कनेक्शन';

  @override
  String get navAudit => 'ऑडिट लॉग';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get navConnectShort => 'कनेक्ट';

  @override
  String get navAuditShort => 'ऑडिट';

  @override
  String metaPair(String first, String second) {
    return '$first · $second';
  }

  @override
  String get feedTitle => 'लंबित';

  @override
  String needsReviewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count कार्य समीक्षा के लिए',
      one: '1 कार्य समीक्षा के लिए',
      zero: 'समीक्षा के लिए कुछ नहीं',
    );
    return '$_temp0';
  }

  @override
  String quotedPreview(String text) {
    return '“$text”';
  }

  @override
  String approvedAt(String time) {
    return '$time पर स्वीकृत';
  }

  @override
  String rejectedAt(String time) {
    return '$time पर अस्वीकृत';
  }

  @override
  String get justNow => 'अभी';

  @override
  String minutesAgo(int count) {
    return '$count मिनट पहले';
  }

  @override
  String hoursAgo(int count) {
    return '$count घंटे पहले';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन पहले',
      one: '1 दिन पहले',
    );
    return '$_temp0';
  }

  @override
  String get yesterday => 'कल';

  @override
  String get platformN8n => 'n8n';

  @override
  String get platformMake => 'Make';

  @override
  String get platformZapier => 'Zapier';

  @override
  String get platformCustom => 'कस्टम';

  @override
  String pendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लंबित कार्य',
      one: '1 लंबित कार्य',
      zero: 'कोई लंबित कार्य नहीं',
    );
    return '$_temp0';
  }

  @override
  String get emptyPendingTitle => 'सब ठीक है';

  @override
  String get emptyPendingMessage =>
      'जब कोई एजेंट कोई कार्य प्रस्तावित करेगा, वह यहाँ दिखेगा।';

  @override
  String get actionDetailTitle => 'कार्य की समीक्षा करें';

  @override
  String get approve => 'स्वीकृत करें';

  @override
  String get reject => 'अस्वीकार करें';

  @override
  String get edit => 'संपादित करें';

  @override
  String get approveWithEdits => 'बदलावों के साथ स्वीकृत करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get rejectReasonHint => 'कारण (वैकल्पिक)';

  @override
  String get alreadyDecided => 'इस कार्य पर पहले ही निर्णय लिया जा चुका है।';

  @override
  String get decisionRecorded => 'निर्णय दर्ज किया गया';

  @override
  String get whatItWantsToDo => 'यह क्या करना चाहता है';

  @override
  String get rejectSheetTitle => 'यह कार्य अस्वीकार करें?';

  @override
  String get emailTo => 'को';

  @override
  String get emailSubject => 'विषय';

  @override
  String get emailBody => 'संदेश';

  @override
  String get emailEditableHint => 'विषय और संदेश संपादित किए जा सकते हैं';

  @override
  String get fieldsEditableHint => 'कुछ फ़ील्ड संपादित की जा सकती हैं';

  @override
  String get payloadLabel => 'डेटा';

  @override
  String get diffBefore => 'पहले';

  @override
  String get diffAfter => 'बाद में';

  @override
  String get statusPending => 'लंबित';

  @override
  String get statusApproved => 'स्वीकृत';

  @override
  String get statusRejected => 'अस्वीकृत';

  @override
  String get statusExpired => 'समय समाप्त';

  @override
  String get connectionsTitle => 'कनेक्शन';

  @override
  String get connectAgent => 'एजेंट जोड़ें';

  @override
  String get connect => 'जोड़ें';

  @override
  String get statusLive => 'सक्रिय';

  @override
  String get statusPaused => 'रुका हुआ';

  @override
  String lastActionAgo(String ago) {
    return 'आख़िरी कार्य $ago';
  }

  @override
  String get noActionsYet => 'अभी तक कोई कार्य नहीं';

  @override
  String get pausedMeta => 'रुका हुआ';

  @override
  String get connectAgentTitle => 'एजेंट जोड़ें';

  @override
  String get nameLabel => 'नाम';

  @override
  String get agentNameHint => 'ईमेल एजेंट';

  @override
  String get platformLabel => 'प्लेटफ़ॉर्म';

  @override
  String get callbackUrlHint => 'https://your-workflow.example/webhook';

  @override
  String get createConnection => 'कनेक्शन बनाएँ';

  @override
  String get shownOnceWarning => 'सिर्फ़ एक बार दिखेगा — अभी कॉपी करें';

  @override
  String get signingSecret => 'साइनिंग सीक्रेट';

  @override
  String waitingForTest(String platform) {
    return '$platform से आपके पहले टेस्ट कार्य का इंतज़ार…';
  }

  @override
  String firstActionReceived(String platform) {
    return '$platform से पहला कार्य मिल गया — अपना कार्य फ़ीड देखें।';
  }

  @override
  String get testActionSent => 'टेस्ट कार्य भेजा गया — अपना कार्य फ़ीड देखें।';

  @override
  String get invalidAgentName => 'नाम दर्ज करें (1–60 अक्षर)।';

  @override
  String get invalidCallbackUrl => 'सही https:// URL दर्ज करें।';

  @override
  String get noAgentsTitle => 'कोई एजेंट जुड़ा नहीं है';

  @override
  String get noAgentsMessage =>
      'अपने n8n, Make, Zapier या कस्टम एजेंट को साइन किए गए वेबहुक से जोड़ें।';

  @override
  String get agentName => 'एजेंट का नाम';

  @override
  String get callbackUrl => 'कॉलबैक URL';

  @override
  String get inboundUrl => 'इनबाउंड URL';

  @override
  String get inboundSecret => 'इनबाउंड सीक्रेट';

  @override
  String get secretShownOnceWarning =>
      'यह सीक्रेट अभी कॉपी करें। आपकी सुरक्षा के लिए इसे दोबारा नहीं दिखाया जाएगा।';

  @override
  String get sendTestAction => 'एक टेस्ट कार्य भेजें';

  @override
  String get copy => 'कॉपी करें';

  @override
  String get copied => 'कॉपी हो गया';

  @override
  String get auditTitle => 'ऑडिट लॉग';

  @override
  String get noAuditEntries => 'अभी तक कोई निर्णय दर्ज नहीं हुआ।';

  @override
  String get filterAll => 'सभी';

  @override
  String get editedBeforeApprove => 'स्वीकृति से पहले संपादित';

  @override
  String noteQuoted(String reason) {
    return 'टिप्पणी: “$reason”';
  }

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get signOut => 'साइन आउट करें';

  @override
  String get email => 'ईमेल';

  @override
  String get sendMagicLink => 'मैजिक लिंक भेजें';

  @override
  String get brandTagline => 'AI एजेंटों का कंट्रोल पैनल';

  @override
  String get signInHeadline =>
      'अपने एजेंटों के काम मंज़ूर करें — अपने फ़ोन से।';

  @override
  String get signInBody =>
      'अपने ईमेल से साइन इन करें। हम आपको एक सुरक्षित मैजिक लिंक भेजेंगे — कोई पासवर्ड याद रखने की ज़रूरत नहीं।';

  @override
  String get emailHint => 'you@company.com';

  @override
  String get invalidEmail => 'सही ईमेल पता दर्ज करें।';

  @override
  String get termsNotice =>
      'आगे बढ़कर आप शर्तों और गोपनीयता नीति से सहमत होते हैं।';

  @override
  String get back => 'वापस';

  @override
  String otpSentTo(String email) {
    return 'हमने $email पर साइन-इन ईमेल भेजा है। उसमें दिया 6 अंकों का कोड दर्ज करें।';
  }

  @override
  String get otpCodeLabel => 'कोड';

  @override
  String get otpCodeHint => '123456';

  @override
  String get verifyCode => 'कोड सत्यापित करें';

  @override
  String get useDifferentEmail => 'दूसरा ईमेल इस्तेमाल करें';

  @override
  String get invalidOtp => 'ईमेल में दिया 6 अंकों का कोड दर्ज करें।';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get appearance => 'रूप-रंग';

  @override
  String get appearanceDescription => 'चुनें कि इस डिवाइस पर कॉकपिट कैसा दिखे।';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get language => 'भाषा';

  @override
  String get languageDescription => 'ऐप में इस्तेमाल होने वाली भाषा चुनें।';

  @override
  String get languageSystem => 'सिस्टम';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get themeLabel => 'थीम';

  @override
  String get appLanguage => 'ऐप की भाषा';

  @override
  String get sectionAccount => 'खाता';

  @override
  String get planSolo => 'सोलो प्लान';

  @override
  String get planPro => 'प्रो प्लान';

  @override
  String get planConsultant => 'कंसल्टेंट प्लान';

  @override
  String workspaceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count वर्कस्पेस',
      one: '1 वर्कस्पेस',
    );
    return '$_temp0';
  }

  @override
  String get about => 'जानकारी';

  @override
  String versionLabel(String version) {
    return 'संस्करण $version';
  }

  @override
  String get loading => 'लोड हो रहा है';

  @override
  String get retry => 'फिर से कोशिश करें';

  @override
  String get errorGeneric => 'कुछ गलत हो गया। कृपया फिर से कोशिश करें।';

  @override
  String get errorNetwork => 'आप ऑफ़लाइन लगते हैं। अपना कनेक्शन जाँचें।';

  @override
  String get errorServer => 'सर्वर अनुरोध पूरा नहीं कर सका।';

  @override
  String get errorAuth =>
      'आपका सेशन समाप्त हो गया है। कृपया फिर से साइन इन करें।';

  @override
  String get errorExpired =>
      'इस कार्य का समय समाप्त हो गया है, अब इस पर निर्णय नहीं लिया जा सकता।';

  @override
  String get notificationChannelName => 'समीक्षा के लिए कार्य';

  @override
  String get notificationChannelDescription =>
      'जब कोई एजेंट ऐसा कार्य प्रस्तावित करे जिस पर आपका निर्णय चाहिए, तब सूचना।';

  @override
  String get errorRateLimited =>
      'बहुत सारे अनुरोध। कृपया थोड़ी देर रुककर फिर कोशिश करें।';

  @override
  String get errorValidation =>
      'कुछ जानकारी सही नहीं है। कृपया जाँचकर फिर से कोशिश करें।';

  @override
  String get comingSoon => 'जल्द आ रहा है';
}
