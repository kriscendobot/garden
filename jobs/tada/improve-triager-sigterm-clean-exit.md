Pushed to `main2` as `202ad5063a`.

## Completion report

**Job:** `improve-triager-sigterm-clean-exit` — make `scripts/jobs/triager.sh` handle TERM/INT before fetch classification and exit with the corresponding clean signal status, so a systemd stop no longer surfaces as a spurious fetch-failure warning.

**Root cause:** A systemd stop (KillMode default SIGTERM) kills the steady-state `git fetch`, leaving `rc=143` (128+SIGTERM); Ctrl-C leaves `rc=130`. `triager.sh` had no signal trap (unlike its siblings `ci-watcher.sh` / `comment-watcher.sh`, which already `trap … exit 143/130`), and 143/130 matched none of the fetch retry/classification cases, so it fell through to case (c) — "unclassified fetch failure" — logging a `WARN` and paging the maintainer for an expected interrupted tick.

**Changes (`scripts/jobs/triager.sh`):**
1. Added `trap 'exit 143' TERM` / `trap 'exit 130' INT` early (before the fetch), matching the sibling watchers, for a signal delivered to bash itself.
2. Added an explicit `rc==143 || rc==130` guard immediately after the fetch loop and **before** the classification block — the literal "handle before classification" ask — for the observed case where the signal reached only the fetch child (bash unsignalled, so no trap fired). It logs a benign "interrupted by signal N; clean shutdown, not a fetch failure" and exits with the signal status. No handler run, no cursor advance, no maintainer alert.

**Tests (`scripts/jobs/test/triager-test.sh`):** Added case **N**, driving both rc=143 and rc=130 via the existing `mk_fetch_shim` harness, asserting clean signal-status exit, the clean-shutdown log, no fetch-failure WARN, no transient misclassification, no maintainer alert, handler never invoked, cursor unadvanced. Full suite: **133 passed, 0 failed** (14 new). `bash -n` clean.

**Follow-ups:** None. The fix is localized and consistent with the established sibling-watcher trap convention.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-triager-sigterm-clean-exit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1141263 cached reads)
- Output: 13656 tokens
- Cost: $1.8069605
- Wall-clock: 213s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
