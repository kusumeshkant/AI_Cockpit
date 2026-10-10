// Feature: auth · Layer: domain
// Sign-in code rules shared by the sign-in screen and its tests. They mirror
// the backend's Supabase Auth settings and must change together with them.

/// Digits in the emailed sign-in code.
///
/// Must match Supabase Auth `otp_length`: product/backend/supabase/config.toml
/// (`[auth.email] otp_length = 6`) locally, and the cloud project's
/// Authentication → Email settings.
const int otpLength = 6;

/// How long an emailed code stays valid.
///
/// Must match Supabase Auth `otp_expiry` (3600 s): config.toml
/// `[auth.email] otp_expiry = 3600` locally, and the cloud project's setting.
const Duration otpValidity = Duration(seconds: 3600);

/// Minimum wait before another code can be requested for the same email.
///
/// Supabase Auth refuses emails sent more often than `email.max_frequency`
/// (cloud default 60 s; the local config.toml uses 1 s), and caps emails per
/// hour (`[auth.rate_limit] email_sent`). The app always waits 60 s so local
/// and cloud behave alike; a 429 from Auth is shown as "too many codes".
const Duration otpResendCooldown = Duration(seconds: 60);
