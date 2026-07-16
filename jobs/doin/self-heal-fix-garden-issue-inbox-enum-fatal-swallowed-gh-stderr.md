In `scripts/jobs/handlers/issue-source-gh.sh`, the two enumeration pipelines (section 1 "NEW ISSUES" at ~line 76, and section 2 "NEW ISSUE COMMENTS" at ~line 100) pipe `gh_api_retry … 2>/dev/null`, which discards not only expected-empty/idle noise but also `gh_api_retry`'s final failure WARN (common.sh:1826/1832) that carries the real gh error (HTTP 401/403/404/rate-limit). When the pipe fails, the `|| die "…(rc=$?)…"` at lines 82 and 122 reports only the bare rc, so the failed tick surfaces NO cause. Live signature (garden-issue-inbox, exit 1): `[issue-source] FATAL: issues enumeration for kriskowal/garden failed (rc=1)` with the underlying HTTP status invisible — a ~4s fast fail indicating a definitive (non-transient) gh error that will recur blind.

Fix: capture `gh_api_retry`'s stderr to a temp file instead of `/dev/null` (e.g. `errf="$(mktemp)"`; `2>"$errf"`), keep the success path quiet, and on the `die` branch append the tail of that capture to the FATAL message so the recurring failure names auth vs 403 rate-limit vs network. Apply to both enumeration blocks (and the `issue_meta` join at line 93). Do not alter the fail-the-tick/hold-the-cursor semantics — this only makes the existing FATAL diagnosable. After merge, the next occurrence's tail will let a responder pinpoint whether the bot's gh token needs refresh (the likely root cause given the fast definitive fail while journal git reads succeeded).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 12
  worker_kind: gardener
  claimed_at: 2026-07-16T22:24:42Z
