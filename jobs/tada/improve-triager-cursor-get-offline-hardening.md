Pushed to main2. Job complete.

## Completion report

**Job:** Harden `scripts/jobs/triager.sh`'s two journal-cursor reads against journal-connectivity outages.

**What was wrong:** The `activity/<slug>` (line ~463) and `failcount/<slug>` (line ~477) reads were bare command substitutions under `set -euo pipefail`. `cursor-get.sh` calls `sync_clone`, which on a journal outage does `exit "$GARDEN_OFFLINE_RC"` (75, EX_TEMPFAIL) — an `exit`, not a `return` — terminating the process with a non-zero status that tripped triager.sh's `set -e` and hard-failed the whole systemd unit. This fired live during the 2026-09-18 04:50–05:16Z journal-fetch outage: `garden-triager@kriscendobot-{list,endo-but-for-bots,finbot}` all logged `Failed with result 'exit-code'` while `ci-watcher.sh` cleanly skipped.

**What changed:** Both call sites now capture the rc using the `if out=$(...); then rc=0; else rc=$?; fi` pattern already used for the repo-fetch classification in this file. On `is_environmental_rc "$rc"` they log a `WARN` and `exit 0` (clean skip, retried next tick); any non-environmental rc escalates via `die`. `is_environmental_rc` is available (common.sh is sourced at line 34). `bash -n` passes.

**Committed & pushed** to `main2` (single commit, rebase-CAS push succeeded on first try). No follow-ups; the journal-read path now meets the same fail-open standard as the repo-fetch path and `approval-reconciler.sh`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-triager-cursor-get-offline-hardening.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (415861 cached reads)
- Output: 3544 tokens
- Cost: $0.7143184999999999
- Wall-clock: 54s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
