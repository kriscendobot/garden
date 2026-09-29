The investigation is complete. All work this job specifies was already landed by a prior commit before this job was promoted from the plan queue. Nothing remains to do, and the working tree is clean (no commit needed).

## Completion report

**Outcome: already resolved — no changes required.**

The job asked me to apply the triager.sh cursor-read fail-open fix to the unguarded `cursor-get.sh` pipelines in `issue-inbox-watcher.sh`, `comment-watcher.sh`, and `mention-watcher.sh`. On inspection, **all three watchers already carry the fix**:

- **comment-watcher.sh** (`:457`) and **mention-watcher.sh** (`:105`) — fixed in commit `df83fca2355` (2026-09-19), titled *"fix(jobs): fail open on nonzero cursor-get.sh rc in issue-inbox/comment/mention watchers"*.
- **issue-inbox-watcher.sh** (`:507`) — same fix, later refined by `1d7a9fc94a4` (2026-09-22) to use a larger `CURSOR_STAGE_TIMEOUT` aligned with the cursor-IO lock wait.

Each site now uses exactly the prescribed shape: `if cursor_out="$(...cursor-get.sh...)"; then rc=0; else rc=$?; fi`, then on nonzero rc it WARN-logs (or skips quietly on the `GARDEN_OFFLINE_RC=75` outage latch) and `exit 0` — replacing the bare `... | sed | head` pipeline that would have tripped `set -euo pipefail`. This matches (and slightly improves on) the triager.sh reference fix cited in the job body.

**Why the job saw a stale state:** the job was originally posted 2026-09-27 and sat parked on the plan queue (promoted 2026-09-27, then 2026-09-29) with the pre-`df83fca` line numbers (`:423`, `:83`, `:386`) baked into its body. The self-healing fix had actually already landed 2026-09-19, so the promoted job describes a defect that no longer exists on `main2`.

**Audit sweep:** I confirmed no bare vulnerable `cursor-get.sh | sed | head` pipeline remains in any production watcher under `scripts/jobs/`. The only remaining unguarded-looking call, `receipt-watcher.sh:197`, is already fail-open via `|| true`. All other matches are in `scripts/jobs/test/` fixtures, which are test harnesses, not production units running under the systemd `set -e` spine.

No commit was made (the tree is clean and correct); pushing an empty/no-op commit would be noise. No follow-ups needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-issue-inbox-cursor-get-pipefail.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (2 unmetered)
- Input: 12 tokens (249045 cached reads)
- Output: 4403 tokens
- Cost: $0.6661475 (2 engagement(s) unpriced)
- Wall-clock: 117s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
