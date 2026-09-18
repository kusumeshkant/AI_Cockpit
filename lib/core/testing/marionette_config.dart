// DEBUG-ONLY. Marionette MCP configuration so an AI agent can see and tap
// Cockpit's custom widgets during exploratory UI testing. Referenced only from
// bootstrap inside `if (kDebugMode)`; kDebugMode is a compile-time constant,
// so release builds tree-shake this file and marionette_flutter away.
//
// Built-in Flutter widgets (Text, TextField, InkWell, buttons…) are already
// understood by marionette. This adds the app's own widgets by type and by
// their real text fields, so tools like `tap`, `enter_text` and
// `get_interactive_elements` can target them as "Approve", "Email", etc.
import 'package:flutter/widgets.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

import 'package:cockpit/core/widgets/action_card.dart';
import 'package:cockpit/core/widgets/app_banner.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/app_chip.dart';
import 'package:cockpit/core/widgets/app_text_field.dart';
import 'package:cockpit/core/widgets/app_top_bar.dart';
import 'package:cockpit/core/widgets/copyable_field.dart';
import 'package:cockpit/core/widgets/status_pill.dart';
import 'package:cockpit/features/actions/presentation/widgets/action_card.dart';
import 'package:cockpit/features/connections/presentation/widgets/agent_row.dart';

/// App widgets the agent can tap / type into.
const Set<Type> _interactiveTypes = {
  AppButton,
  AppTextField,
  AppChip,
  AppIconButton,
  AppCard,
  ActionCard,
  ActionItemCard,
  AgentRow,
  CopyableField,
};

/// Leaves: their inner InkWell / Text would only duplicate the element.
/// Cards and text fields are NOT stops, so their children (status pills,
/// the inner EditableText for `enter_text`) stay reachable.
const Set<Type> _stopTypes = {
  AppButton,
  AppChip,
  AppIconButton,
  StatusPill,
};

/// Text the agent sees for an app widget (also used for text matching).
String? _extractText(Element element) => switch (element.widget) {
      AppButton(:final label) => label,
      AppTextField(:final label) => label,
      AppChip(:final label) => label,
      AppIconButton(:final tooltip) => tooltip,
      ActionCard(:final title) => title,
      ActionItemCard(:final item) => item.title,
      AgentRow(:final agent) => agent.name,
      CopyableField(:final label) => label,
      StatusPill(:final label) => label,
      AppBanner(:final message) => message,
      _ => null,
    };

/// Marionette configuration for Cockpit (debug builds only).
MarionetteConfiguration buildMarionetteConfiguration() => MarionetteConfiguration(
      isInteractiveWidget: _interactiveTypes.contains,
      shouldStopTraversal: _stopTypes.contains,
      extractText: _extractText,
    );
