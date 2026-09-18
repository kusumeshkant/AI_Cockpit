import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/presentation/controllers/action_detail_controller.dart';
import 'package:cockpit/features/actions/presentation/renderers/generic_renderer.dart';
import 'package:cockpit/features/actions/presentation/screens/action_detail_screen.dart';

import '../../helpers/action_fixtures.dart';
import '../../helpers/pump_app.dart';

class _Decision {
  _Decision(this.type, this.editedPayload, this.reason);
  final DecisionType type;
  final Map<String, dynamic>? editedPayload;
  final String? reason;
}

class _FakeDetailController extends ActionDetailController {
  _FakeDetailController(this.item, this.decisions) : super(item.id);

  final ActionItem item;
  final List<_Decision> decisions;

  @override
  Future<ActionItem> build() async => item;

  @override
  Future<Failure?> decide(
    DecisionType type, {
    Map<String, dynamic>? editedPayload,
    String? reason,
  }) async {
    decisions.add(_Decision(type, editedPayload, reason));
    return null;
  }
}

void main() {
  group('ActionDetailScreen', () {
    late List<_Decision> decisions;

    setUp(() => decisions = []);

    Future<void> pumpDetail(
      WidgetTester tester,
      ActionItem item, {
      Size size = phoneSize,
      ThemeMode themeMode = ThemeMode.light,
      Locale locale = const Locale('en'),
    }) =>
        pumpApp(
          tester,
          ActionDetailScreen(actionId: item.id),
          size: size,
          themeMode: themeMode,
          locale: locale,
          overrides: [
            actionDetailControllerProvider(item.id)
                .overrideWith(() => _FakeDetailController(item, decisions)),
          ],
        );

    testWidgets('renders header, summary, email and decision bar',
        (tester) async {
      await pumpDetail(tester, pendingEmail);

      expect(find.text('Review action'), findsOneWidget);
      expect(find.text('n8n · Email agent'), findsOneWidget);
      expect(find.text('PENDING'), findsOneWidget);
      expect(find.text('WHAT IT WANTS TO DO'), findsOneWidget);
      expect(find.text('priya.k@example.com'), findsOneWidget);
      expect(find.text('Subject & body are editable'), findsOneWidget);
      expect(find.text('Reject'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Approve'), findsOneWidget);
    });

    testWidgets('approve submits an approved decision', (tester) async {
      await pumpDetail(tester, pendingEmail);

      await tester.tap(find.text('Approve'));
      await tester.pumpAndSettle();

      expect(decisions.single.type, DecisionType.approved);
      expect(find.text('Decision recorded'), findsOneWidget);
    });

    testWidgets('edit then approve sends only changed fields', (tester) async {
      await pumpDetail(tester, pendingEmail);

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      expect(find.text('Approve with edits'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'New subject');
      await tester.tap(find.text('Approve with edits'));
      await tester.pumpAndSettle();

      expect(decisions.single.type, DecisionType.approvedWithEdits);
      expect(decisions.single.editedPayload, {'subject': 'New subject'});
    });

    testWidgets('reject asks for a reason', (tester) async {
      await pumpDetail(tester, pendingEmail);

      await tester.tap(find.text('Reject'));
      await tester.pumpAndSettle();
      expect(find.text('Reject this action?'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'too risky');
      await tester.tap(find.text('Reject').last);
      await tester.pumpAndSettle();

      expect(decisions.single.type, DecisionType.rejected);
      expect(decisions.single.reason, 'too risky');
    });

    testWidgets('unknown action types use the generic renderer (TR-5)',
        (tester) async {
      await pumpDetail(tester, approvedLeads);

      expect(find.byType(GenericRenderer), findsOneWidget);
      expect(find.text('Approve'), findsNothing);
    });

    for (final (label, themeMode, locale, editLabel) in [
      ('light en', ThemeMode.light, const Locale('en'), 'Edit'),
      ('dark hi', ThemeMode.dark, const Locale('hi'), 'संपादित करें'),
    ]) {
      testWidgets('lays out at 320px, incl. edit mode ($label)', (tester) async {
        await pumpDetail(
          tester,
          pendingEmail,
          size: narrowPhoneSize,
          themeMode: themeMode,
          locale: locale,
        );
        expect(tester.takeException(), isNull);

        await tester.tap(find.text(editLabel));
        await tester.pumpAndSettle();
        expect(find.byType(TextField), findsNWidgets(2));
        expect(tester.takeException(), isNull);
      });
    }
  });
}
