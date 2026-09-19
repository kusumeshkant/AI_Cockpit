// Feature: connections · Layer: presentation
// Connect an agent (design: technical/design/ConnectAgent.dc.html).
//  1. Form: name, platform (segmented), callback URL → Create connection.
//     (The callback URL is required by the backend contract; the mockup shows
//     the post-creation state only.)
//  2. Created: credentials panel shown once (TR-8), a banner that waits for
//     the agent's first action (live via the feed stream),
//     "Send a test action".
// The secret lives only in this widget's state and is never re-fetched.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cockpit/core/config/feature_flags.dart';
import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_banner.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_chip.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_scaffold.dart';
import 'package:cockpit/core/widgets/app_text_field.dart';
import 'package:cockpit/core/widgets/app_top_bar.dart';
import 'package:cockpit/core/widgets/section_label.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/connections/presentation/widgets/credentials_panel.dart';
import 'package:cockpit/features/triggers/presentation/widgets/trigger_config_section.dart';

/// Connect-agent screen.
class ConnectAgentScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const ConnectAgentScreen({super.key});

  @override
  ConsumerState<ConnectAgentScreen> createState() => _ConnectAgentScreenState();
}

class _ConnectAgentScreenState extends ConsumerState<ConnectAgentScreen> {
  static const int _maxNameLength = 60;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _callbackUrl = TextEditingController();
  AgentPlatform _platform = AgentPlatform.n8n;
  AgentCredentials? _credentials;
  bool _showErrors = false;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _callbackUrl.dispose();
    super.dispose();
  }

  bool get _nameValid {
    final name = _name.text.trim();
    return name.isNotEmpty && name.length <= _maxNameLength;
  }

  bool get _urlValid {
    final uri = Uri.tryParse(_callbackUrl.text.trim());
    return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty;
  }

  void _close() {
    final router = GoRouter.maybeOf(context);
    if (router != null && router.canPop()) {
      router.pop();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _showMessage(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  Future<void> _create() async {
    if (!_nameValid || !_urlValid) {
      setState(() => _showErrors = true);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _busy = true);
    final result = await ref.read(connectionsControllerProvider.notifier).createAgent(
          name: _name.text.trim(),
          callbackUrl: _callbackUrl.text.trim(),
          platform: _platform,
        );
    if (!mounted) return;
    setState(() => _busy = false);
    result.fold(
      (failure) => _showMessage(context.failureMessage(failure)),
      (credentials) => setState(() => _credentials = credentials),
    );
  }

  Future<void> _sendTest() async {
    final credentials = _credentials!;
    setState(() => _busy = true);
    final failure = await ref
        .read(connectionsControllerProvider.notifier)
        .sendTestAction(credentials.agent.id);
    if (!mounted) return;
    setState(() => _busy = false);
    _showMessage(
      failure == null ? context.l10n.testActionSent : context.failureMessage(failure),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final credentials = _credentials;
    final created = credentials != null;
    final triggersOn = ref.watch(agentTriggersProvider);

    return AppScaffold(
      topBar: AppTopBar.back(title: l10n.connectAgentTitle, onBack: _close),
      bottomBar: AppBottomBar(
        child: AppButton(
          label: created ? l10n.sendTestAction : l10n.createConnection,
          isLoading: _busy,
          expand: true,
          onPressed: created ? _sendTest : _create,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          AppTextField(
            label: l10n.nameLabel,
            hint: l10n.agentNameHint,
            controller: _name,
            enabled: !created,
            textInputAction: TextInputAction.next,
            errorText: _showErrors && !_nameValid ? l10n.invalidAgentName : null,
            onChanged: (_) {
              if (_showErrors) setState(() {});
            },
          ),
          SizedBox(height: spacing.lg),
          SectionLabel(l10n.platformLabel, dense: true),
          SizedBox(height: spacing.sm - spacing.xxs / 2),
          IgnorePointer(
            ignoring: created,
            child: SegmentedChips<AgentPlatform>(
              selected: _platform,
              onChanged: (platform) => setState(() => _platform = platform),
              options: [
                for (final platform in AgentPlatform.values)
                  SegmentOption(
                    value: platform,
                    label: context.platformLabel(platform),
                  ),
              ],
            ),
          ),
          SizedBox(height: spacing.lg),
          if (!created)
            AppTextField(
              label: l10n.callbackUrl,
              hint: l10n.callbackUrlHint,
              controller: _callbackUrl,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              errorText:
                  _showErrors && !_urlValid ? l10n.invalidCallbackUrl : null,
              onChanged: (_) {
                if (_showErrors) setState(() {});
              },
              onSubmitted: (_) => _create(),
            )
          else ...[
            CredentialsPanel(credentials: credentials),
            // Agent Triggers (flag-gated): nothing added while the flag is off.
            if (triggersOn) ...[
              SizedBox(height: spacing.lg),
              TriggerConfigSection(agentId: credentials.agent.id),
            ],
            SizedBox(height: spacing.lg),
            _FirstActionBanner(
              agentId: credentials.agent.id,
              platform: context.platformLabel(_platform),
            ),
          ],
        ],
      ),
    );
  }
}

/// "Waiting for your first action" until the agent's first action reaches
/// the feed, then a confirmation.
class _FirstActionBanner extends ConsumerWidget {
  const _FirstActionBanner({required this.agentId, required this.platform});

  final String agentId;
  final String platform;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final received = ref.watch(agentHasActionsProvider(agentId));
    return AppBanner(
      icon: received ? AppIcons.check : AppIcons.progress,
      message: received
          ? context.l10n.firstActionReceived(platform)
          : context.l10n.waitingForTest(platform),
    );
  }
}
