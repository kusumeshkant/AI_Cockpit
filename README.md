# Cockpit — Flutter app

The iOS + Android client: review, edit and approve what AI agents propose, in one tap.

Part of the Cockpit monorepo. See the [repository index](../../README.md), the engineering contract in [`CLAUDE.md`](../../CLAUDE.md), and the [technical blueprint](../../technical/04-technical-blueprint.md).

## Stack

Flutter 3.x / Dart 3 · Riverpod · go_router · get_it + injectable · freezed · dartz · dio · Supabase · FCM · Sentry · PostHog. Clean Architecture, feature-first (`lib/core`, `lib/features/<feature>/{presentation,domain,data}`).

## Run

All commands run from this folder (`product/frontend/`):

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs --force-jit
flutter gen-l10n
flutter run --flavor dev
```

Checks before every push:

```bash
flutter analyze
flutter test
```

### Against the local backend (live mode)

Without `SUPABASE_URL` / `SUPABASE_ANON_KEY` the app runs on in-memory **demo** data. To use the local Supabase stack instead:

1. Start the backend (see [product/backend/README.md](../backend/README.md)):
   ```bash
   cd product/backend
   supabase start && supabase db reset
   supabase functions serve --no-verify-jwt --env-file supabase/functions/.env
   ```
2. Create `env/dev.json` from `env/dev.example.json` (git-ignored). Put the `ANON_KEY` from `supabase status` in it:
   ```json
   { "FLAVOR": "dev", "SUPABASE_URL": "http://10.0.2.2:54321", "SUPABASE_ANON_KEY": "<ANON_KEY>" }
   ```
   `10.0.2.2` is the Android emulator's alias for the host. On a physical phone, use the laptop's LAN IP and add it to `android/app/src/dev/res/xml/network_security_config.xml`, since dev builds allow cleartext HTTP only to listed hosts.
3. Run:
   ```bash
   flutter run --flavor dev --dart-define-from-file=env/dev.json
   ```

**Signing in locally:**
- Enter an email and tap *Send magic link*. Supabase sends a sign-in email with a 6-digit code.
- Local email is caught by Mailpit/Inbucket at <http://127.0.0.1:54324>, not a real inbox.
- Open the message and type the **code** into the app. The magic link itself points at `127.0.0.1`, which the emulator can't open.
- Local Auth allows only 2 sign-in emails per hour (`auth.rate_limit.email_sent` in `config.toml`).

**What's live:**
- **Auth:** Supabase email OTP.
- **Feed:** REST, Realtime on `action`, plus a 30 s poll fallback.
- **Decisions:** `actions-decision` with an `Idempotency-Key`. The app says *Decision recorded*: delivery to the agent happens (and is retried) in the background.
- **Connections:** REST list, plus `agents-create`, which shows the one-time secret. *Send a test action* calls `agents-test-action`. The "waiting for your first action" banner turns into a confirmation when the new agent's first action reaches the feed.
- **Audit:** REST `decision_made` events.
- **Push:** FCM, when Firebase is configured (below). Without it the app behaves the same, with the feed updated through Realtime and polling.
- **Rate limits:** a 429 from the backend shows a "too many requests" message (`RateLimitedFailure`).

### Push notifications (optional)

Push is off until a Firebase config is present. Nothing else changes.

1. In the Firebase console, create a project and add **two Android apps**: `app.cockpit.cockpit` and `app.cockpit.cockpit.dev` (the dev flavor's id). Download `google-services.json` (it lists both) to `android/app/`. The file is git-ignored. The Gradle `google-services` plugin is applied only when this file exists.
2. Project settings → Service accounts → *Generate new private key*. Put it on one line in `product/backend/supabase/functions/.env` as `FCM_SERVICE_ACCOUNT_JSON=…`, then restart `supabase functions serve`.
3. Use a **real phone** (or an emulator image *with* Google Play). `Pixel_8_NoPlay` can't receive FCM. On a phone, set `SUPABASE_URL` in `env/dev.json` to the laptop's LAN IP (`http://192.168.x.x:54321`) and add that IP to `android/app/src/dev/res/xml/network_security_config.xml`.
4. Run the app and sign in. It asks for notification permission and registers its token (`rpc/register_fcm_token`). New actions then arrive as notifications: in the tray when the app is in the background or closed, and as a heads-up while it's open. Tapping one opens the action. Signing out removes the token first.

Without the file, `Firebase.initializeApp()` fails quietly at startup and push stays off. Pass `--dart-define=FIREBASE_ENABLED=false` to skip the attempt. Details: ADR-008 in [technical/07-architecture-decisions.md](../../technical/07-architecture-decisions.md).

Notes:

- Android flavors `dev` and `prod` are defined in `android/app/build.gradle.kts`. iOS schemes for the flavors don't exist yet; see [Setup & stack](../../technical/06-setup-and-stack.md).
- Supabase / Sentry are skipped at startup until their config is supplied via `--dart-define`; Firebase is skipped when `google-services.json` is absent (see `lib/core/config/app_config.dart`).
- `--force-jit` is required for `build_runner`: some transitive dependencies use build hooks that the AOT build-script compile does not support.
- `android/gradle.properties` sets `kotlin.incremental=false` to avoid Kotlin cache failures on Windows when the project and the pub cache are on different drives.

## Golden tests

`test/goldens/` holds pixel goldens: the Agent Triggers UI, and flag-off regression screens whose images were rendered from `main` before that feature, so any unintended change shows up. They are checked on the dev machine and **skipped on CI** (`CI=true`), because CI's Linux runner with an unpinned Flutter rasterizes slightly differently.

```bash
flutter test test/goldens                    # compare
flutter test --update-goldens test/goldens   # re-render after an intended UI change
```

## Layout

```text
lib/            app code (core + features)
test/           unit and widget tests, mirroring lib/features
android/ ios/   platform projects
l10n.yaml       gen-l10n config (ARB files in lib/l10n)
build.yaml      json_serializable options
```
