Calibrated the active Anthropic subscription pool and landed the session-quota design.

- `endolin-garden-ece02cb4`: selected the fresh contiguous 40%-56% cluster. Regression slope was 1,354,521 meter tokens per dashboard percentage point, intercept 8,516,853, and projected 100%-spent intercept 143,968,916 tokens. Rounded down to a provisional 143,000,000-token cap.
- Rejected the earlier clusters: the 17%-28% cluster projects 1.118B after a discontinuous workload/boost change; the canonical-anchor 30%-37% cluster projects 252.6M but predates another anchor transition. The 21:57Z 5% reading was excluded because the dashboard reset while the meter continued accumulating.
- Updated `journal/config/budget-pools` with `143000000`, `manual-regression-fresh-contiguous-cluster`, and calibration timestamp `2026-09-04T22:10:57Z`. This restores leveling provenance.
- `endolin-garden2-5bcdff64`: no numeric cap was fabricated. Its log has no usable paired checkpoint, and the host currently uses a temporary API key. Its existing `unmetered` row retains `temporary-api-key` provenance.
- Added `designs/session-budget-pace.md`, committed and pushed as `6e75e6f3d6`. It represents the five-hour constraint with optional session-cap/window/provenance columns and gates admission and leveling by `min(weekly_remaining_pace, session_remaining_pace)`.
- Follow-up: implement the session telemetry/actuation slice after clean same-session, same-meter-anchor checkpoint pairs exist. Reassess the provisional weekly cap after the 2026-09-05T03:00Z reset and before the temporary 50% boost expires.
- Verification: `git diff --check` passed, referenced design files exist, both journal rows contain provenance, and `origin/main2` resolves to `6e75e6f3d6`.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/budget-calibration-20260904.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 236s

<!-- garden-usage-end -->
