Empty inbox. Work is complete.

## Completion report

**Job:** `improve-issue-inbox-tick-bounds` — bound every blocking stage of an issue-inbox tick so it can never be SIGKILLed at the unit's 900s `TimeoutStartSec`, emit a diagnostic before that deadline, and retain the cursor so the maintainer interaction is safely retried.

**Root cause.** The source fetch was already bounded, but the *other* blocking stages weren't umbrella-bounded. A **degraded** (not cleanly-offline) journal makes each stage — the config/maintainer/cursor journal reads, the post/message pushes, the verify re-fetch, the cursor advance — burn its full bounded retry budget, and several such stages in one tick **sum** past 900s. systemd then SIGKILLs the tick mid-flight, with no diagnostic, dropping the in-flight interaction.

**What I changed** (`scripts/jobs/issue-inbox-watcher.sh`):
1. **Overall tick budget** (`GARDEN_ISSUE_TICK_BUDGET_SECS`, default 480s, well under 900) checked at every stage boundary — right after the source fetch and at the top of each loop iteration. Crossing it emits a diagnostic (WARN + a throttled/coalescing `alert_maintainer` signal keyed `issue-inbox-tick-deadline-$GARDEN`) and exits/breaks **cleanly** (exit 0 pre-batch, `break` mid-batch so the confirmed prefix still banks), **retaining the cursor** for unprocessed/unconfirmed items.
2. **Per-stage `timeout`** (`GARDEN_ISSUE_STAGE_TIMEOUT_SECS`, default 90s) on every blocking external call the watcher makes — cursor get/set, the reactji, the post/message pushes, the maintainer surface — via a `STAGE_TIMEOUT` argv prefix that preserves the `GARDEN_MSG_ID`/`GARDEN_SENDER` env seams and is empty when `timeout` is absent (mirroring the existing source-fetch guard). A bound that fires just makes the dispatch look "lost" → existing POST/DELIVERY-LOST retry path (idempotent), never corrupts.

**Also:** documented the `budget < TimeoutStartSec` invariant in `garden-issue-inbox.service`; added `scripts/jobs/test/issue-inbox-tick-bounds-test.sh` (3 cases / 13 assertions).

**Verification.** All three suites green: `issue-inbox-watcher-test` (43), `issue-inbox-journal-linkage-test` (17), new `issue-inbox-tick-bounds-test` (13). `bash -n` clean; shellcheck shows only two pre-existing infos on untouched lines. Committed and pushed to `main2` (`7070fc7e9c`).

**Follow-ups.** None required. The durable root cause remains the host-side `garden2` bind-mount for the linkage class (already tracked separately); the unbounded `_push_journal` in `common.sh` is now covered at the issue-inbox boundary, but other watchers' pushes still rely on `GIT_HTTP_LOW_SPEED` — worth considering the same per-stage discipline if they exhibit the same 900s symptom.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-issue-inbox-tick-bounds.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (5074787 cached reads)
- Output: 45950 tokens
- Cost: $5.0806745
- Wall-clock: 668s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
