The mention source now stops on the first gh-api cooldown or primary-quota refusal instead of swallowing it, and the watcher records `cooldown` and skips quietly. The fix is pushed to `main2` as `c2a52467650`.

**What changed**
- **`scripts/jobs/handlers/mention-source-gh.sh`**:
  - It exits with a new status, `GARDEN_MENTION_SOURCE_COOLDOWN_RC` (73), in two cases: when a host-shared cooldown is already live at startup, and when a request fails and the cooldown check then shows one is active.
  - All API calls go through a helper, `src_api`/`src_get`, that passes that exit back up to the top level. The notifications list is now fetched before the per-row loop rather than piped into it, so that stop isn't lost inside a pipeline subshell.
  - Other failures behave as before: a failed per-row lookup (a deleted comment's 404, say) is skipped, a failed search is tolerated, and a failed notifications call is still fatal.
- **`scripts/jobs/mention-watcher.sh`**: if a cooldown is already live, it skips the tick without running the source, sets the heartbeat to `cooldown` and exits 0. A source that exits 73 is handled the same way, with no repeat of the source's error output and no "mention source failed" error.
- **`scripts/jobs/test/mention-watcher-test.sh`**: new case QC runs the real handler against a stub `gh` that counts calls.
  - **QC1** (cooldown already live when the tick starts): no `gh` requests, heartbeat `cooldown`, no warning lines, clean exit.
  - **QC2** (quota hit on the first per-row lookup): exactly 2 requests, zero `NOT ISSUED` lines, heartbeat `cooldown`, not reported as a source failure.

**Verification**: the full suite passes (50 passed, 0 failed). Run against the old handler it gets 49 passed, 1 failed, so the new test catches the original bug.

**Follow-ups**: none needed. The fix reaches each host on its next deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mention-source-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (911085 cached reads)
- Output: 13379 tokens
- Cost: $1.036869
- Wall-clock: 171s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
