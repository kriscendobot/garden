In `scripts/jobs/handlers/issue-source-gh.sh`, the two enumeration calls (line ~76 `repos/$repo/issues?...` and line ~100 `repos/$repo/issues/comments?...`) pipe `gh_api_retry ... 2>/dev/null | jq ... || die "... enumeration failed (rc=$?)"`. The `2>/dev/null` is intended only to suppress expected-empty 404/idle noise on the SUCCESS path, but it also discards `gh_api_retry`'s WARN line (common.sh:1796 — `log "WARN: gh api $label failed (definitive|after N attempts): $stderr"`), which is the ONLY place the underlying gh error text (auth/401/403, secondary rate-limit, TLS/timeout, etc.) appears. Result: a genuine enumeration failure surfaces to the watcher — and to self-heal — as an opaque `rc=1` with no root cause, exactly the 3-line blob observed here (`FATAL: issues enumeration for kriskowal/garden failed (rc=1)` and nothing else). This reproduces the class of "silent-empty" outage the handler's own comment (lines 60–63) says it was designed to avoid.

Fix (scoped, no behavior change on the success path): redirect gh_api_retry's stderr to a temp file instead of `/dev/null` for both enumeration calls, and on the `die` path append the last few lines of that captured stderr to the die message so the real gh failure reason reaches the watcher's `sed 's/^/  source: /' "$ERRF"` relay. Keep suppressing the noise on success (only surface the captured stderr when the pipeline is nonzero). Prefer capturing gh_api_retry's own stderr (which already contains the classified WARN + gh stderr) rather than re-running gh. Verify `set -euo pipefail` / `pipefail` interaction still reports the correct rc, and that a clean tick emits no new noise. This is a diagnosability fix only; it does not change the cursor-hold / fail-the-tick semantics, which are correct.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  claimed_at: 2026-07-16T23:25:41Z
