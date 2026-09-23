Done. Pushed to main2 as `0a9123fbd`.

## Completion report

**What I did.** In `scripts/jobs/ci-watcher.sh` at the rollup-read call (line ~201), stopped discarding the rollup handler's stderr.

**What changed.**
- The read was `"$GARDEN_CI_ROLLUP" "$repo" "$pr" >/dev/null 2>&1` — stderr merged to `/dev/null`, throwing away the diagnostic `handlers/ci-rollup-gh.sh` deliberately writes on an unreadable state.
- Now captures stderr to a temp file (`2>"$rerr"`), cleans it up on every branch, and on the unreadable `*)` branch pulls the first stderr line into the WARN:
  `WARN: #$pr rollup unreadable (rc=$rrc): <first stderr line> — skipping (never guess a state)` (falls back to `<no stderr>` if empty).
- Added a comment tying the fix back to the same silent-failure discipline the handler header cites (2026-06-24 jq outage).

**Verification.** `bash -n` passes; the change is a mechanical stderr-capture with no control-flow change (exit-code verdict semantics untouched, `unreadable` counter and downstream systemic-outage detection unchanged).

**Follow-ups.** None required. Note that the per-PR WARN lines now carry the actual cause, which also makes the existing systemic-outage collapse (line ~258) actionable — the outage's root cause is visible on the individual lines feeding it. Left the systemic message itself unchanged since the job scoped only the per-PR branch.
