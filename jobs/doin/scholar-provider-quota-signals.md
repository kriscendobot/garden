---
role: scholar
---

Research reliable and practical ways for the garden to sense provider quota and rate-limit state for both Anthropic Claude CLI and OpenAI Codex CLI.

Investigate, with primary-source and reproducible evidence where available:

1. How to detect that Claude/Anthropic quota is depleted, including CLI exit status, stderr/stdout patterns, structured output, headers, local state, documented APIs, and any distinction between subscription quota and API quota.
2. How to determine or estimate when Claude quota resets. Treat any displayed reset time as potentially unreliable: identify what can be polled, how often, and how to confirm that capacity has actually returned.
3. How to detect Codex rate limiting or quota exhaustion, including CLI exit status, structured events, rollout/session logs, rate-limit metadata, error codes, headers, and documented APIs.
4. How to tell when Codex capacity has drained enough that paused work should resume, including retry-after signals, rolling-window utilization, successful bounded probes, and backoff behavior.
5. Which signals are documented/stable versus observed/heuristic, and how their behavior differs for ChatGPT-authenticated CLIs versus API-key usage.

If direct mechanisms are sparse or unreliable, evaluate an indirect automatic control loop for the garden. Propose a deterministic state machine that uses bounded non-destructive probes, error classification, hysteresis, exponential backoff/jitter, minimum dwell times, and positive recovery confirmation to steer per-host allocations between `gardeners` (Anthropic) and `clerics` (Codex) without oscillation or duplicate cross-host action. Address leader ownership, journal-backed versus host-local state, active-job safety, scaler integration, observability, false positives, and a manual override. Relate the proposal to the existing quota panel, provider-aware foreman, worker scaler, and current temporary Codex-only allocation.

Deliver a concise evidence matrix, recommended polling/probe strategy, unknowns requiring live experiments, and an implementation-oriented design recommendation. This is research and design only: do not change fleet allocation or production configuration.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 29
  worker_kind: cleric
  claimed_at: 2026-07-22T15:08:59Z
