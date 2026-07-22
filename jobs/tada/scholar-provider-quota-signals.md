Research complete. No repository, fleet-allocation, or production-configuration changes were made.

| Provider/mode | Strong quota signal | Reset/recovery signal | Confidence |
|---|---|---|---|
| Claude Code, Pro/Max subscription | No documented machine-readable quota API. Treat a failed bounded `claude -p --output-format stream-json` plus a classified quota/usage-limit error as evidence; CLI exit code alone is not specific. `/status` is human-facing. Local `~/.claude/projects/**/*.jsonl` records token usage, not subscription capacity. | Displayed reset times are advisory. Anthropic documents shared Claude/Code limits and 5-hour limits, but no subscription polling endpoint. Probe after the shown time and require two successful bounded probes. | Heuristic |
| Claude API key | HTTP 429 plus `retry-after`; `anthropic-ratelimit-*-remaining` and `*-reset` headers. Admin Rate Limits API reads configured org/workspace limits, not live subscription balance. | Honor `retry-after`; token-bucket capacity replenishes continuously. | Documented |
| Codex, ChatGPT auth | `codex app-server` `account/rateLimits/read` and `account/rateLimits/updated`: `primary`/`secondary` `usedPercent`, window length, `resetsAt`, `rateLimitReachedType`. Rollout `token_count.rate_limits` is a useful fallback but can be null/stale and is host-local. | Poll app-server shortly before/after `resetsAt`; require lower utilization plus a successful bounded probe. | Documented public protocol, but app-server CLI is marked experimental/version-coupled |
| Codex, API key | HTTP 429/error classification and standard API response rate-limit headers when exposed by the client; API tier limits are documented. Codex CLI's ChatGPT rate-limit RPC does not represent API-key quota. | Honor `Retry-After`/reset headers, then bounded success probe. | Documented at API layer |

Evidence:

- Anthropic documents API 429 and `retry-after`, full replenishment headers, continuous token-bucket refill, and an Admin-only configured-limits API: [rate limits](https://platform.claude.com/docs/en/api/rate-limits), [Rate Limits API](https://platform.claude.com/docs/en/manage-claude/rate-limits-api).
- Claude Pro/Max usage is shared between Claude and Claude Code; API-key use is billed separately, and `/status` is the supported subscription monitor: [Claude Code plan usage](https://support.claude.com/en/articles/11145838-use-claude-code-with-your-pro-or-max-plan).
- Codex’s public app-server protocol documents `account/rateLimits/read`, update notifications, reset timestamps, reached-limit type, and reset credits: [app-server README](https://github.com/openai/codex/blob/main/codex-rs/app-server/README.md).
- Local reproducible observation on this host with Codex CLI 0.144.3: a read-only app-server request returned ChatGPT `planType: prolite`, `primary.usedPercent: 17`, `windowDurationMins: 10080`, `resetsAt: 1785261953`, and no reached-limit type. Existing rollout logs contained the same shape. This confirms integration feasibility, not a cross-version guarantee.
- Current garden behavior is weaker: the quota panel reads local Codex rollout logs, and the Claude meter estimates subscription use from session logs. The existing host-local fleet brake is a good outage brake but is not provider capacity ownership.

Recommendation: add a leader-owned, journal-backed `provider-capacity` controller; do not infer capacity from token totals alone.

- Poll live Codex app-server state every 5 minutes while healthy, 30-60 seconds around a reset, and immediately after a classified failure. Read Claude API headers only in API-key mode. For Claude subscription mode, poll no faster than the next scheduled probe because no authoritative endpoint exists.
- Use a bounded non-destructive probe only when state is suspect or recovery is due: one short, no-tools, one-turn request with a strict timeout and no project mutation. Serialize probes per `{provider, credential identity}` with a journal lease.
- Classify outcomes into `healthy`, `degraded`, `exhausted`, `unknown`, and `manual`. Only explicit 429/retry-after, Codex `rateLimitReachedType`, or repeated provider-specific usage-limit evidence enters `exhausted`; auth, policy, malformed output, network, and local crashes remain `unknown` or separate faults.
- State machine: `healthy -> degraded` at high watermark or one credible limit signal; `degraded -> exhausted` after two independent failures or an explicit reached state; `exhausted -> probing` at retry/reset deadline plus jitter; `probing -> recovering` only after two successful probes separated by a dwell interval and falling/low utilization; `recovering -> healthy` after a minimum 10-minute dwell without relapse. Any fresh hard-limit result returns to `exhausted`.
- Backoff is `max(provider retry-after/reset, exponential full-jitter)` with a cap, and a recovery ramp starts one worker at a time. Use separate high/low watermarks and minimum dwell times to prevent oscillation.
- The leader writes desired allocations and provider state to the journal. Hosts only reconcile their own `gardeners`/`clerics` counts through the existing scaler. Host-local logs, probes, and fleet-brake samples are observations; journal state is the cross-host decision record. Lease/fencing tokens prevent a former leader or two hosts from changing allocations.
- Never kill active jobs for a provider shift. Drain that worker kind, let busy claims finish or follow existing reaper semantics, then scale its future claim capacity. Keep the present Codex-only allocation as a manual baseline until the controller has observed a full recovery cycle.
- Extend the existing quota panel with freshness, source, credential-identity fingerprint, state, next-probe time, and last classified failure. Emit journal events for every transition, probe, allocation decision, override, and stale-observation condition. Add a manual `forced-provider-state` / allocation override with expiry and explicit clear.

Unknowns needing controlled live experiments:

- Exact Claude CLI subscription-limit stderr/stream-json/exit patterns, whether `/status` exposes parseable reset/capacity data, and whether one credential is shared across all hosts.
- Codex CLI 429/error JSON and whether app-server read/update remains available across deployed versions and API-key authentication.
- Whether Codex’s displayed `resetsAt` predicts usable capacity under concurrent sessions; validate with serialized harmless probes.
- Correct high/low thresholds and dwell/backoff values under real garden workload.

Follow-up: implement only after capturing sanitized failure fixtures for both CLIs, adding hermetic state-machine/scaler/leader-fencing tests, and obtaining maintainer approval for the controller’s journal schema and manual override surface.
