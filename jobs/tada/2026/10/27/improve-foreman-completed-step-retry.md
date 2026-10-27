**Completion report: improve-foreman-completed-step-retry**

When the foreman proposes a job base that is already completed, it now asks its handler once more for a different step instead of sending the maintainer a note. The fix is pushed to `main2` as `c0b632f5670`.

**What changed**
- **`scripts/jobs/foreman.sh`**
  - **Completed bases in the digest:** the handler digest now has a `completed_job_bases:` block. It lists only the base names (no prose) of the most recent completed jobs, newest first. The cap is `GARDEN_FOREMAN_DIGEST_COMPLETED`, default 200; there are about 15k entries in `tada/`, so the full list is too long.
  - **One re-prompt:** the handler call and block parse moved into a `run_handler` function inside a loop that allows at most two attempts. When `post-job.sh` returns rc=79 on the first attempt, the foreman logs a `completed-collision` decision and adds `rejected_completed_base: <base>` to the digest. It then calls the handler one more time.
  - **Checking the replacement:** it goes through the usual checks (empty base, anti-flap, arc admission/headroom). If it proposes the rejected base again, it counts as invalid.
  - **Logging:** a successful replacement is posted, updates `LAST_STEP`, and is logged as `pumped … replaced=<base>`.
  - **When the maintainer hears about it:** a maintainer note (`note_once "collision:<base>"`) goes out only if the replacement is absent or invalid. A transient handler outage during the re-prompt counts as absent.
  - **Anti-flap unchanged:** the anti-flap guard works as before. If the replacement trips anti-flap, that sends its own note and the collision note is skipped, because two `note_once` keys in one tick would defeat its single-key dedupe.
  - The header gained a step 7 describing this.
- **`scripts/jobs/handlers/foreman-claude.sh`:** the prompt now explains `completed_job_bases` and `rejected_completed_base`.
- **`scripts/jobs/test/foreman-stub.sh`:** a new `GARDEN_FOREMAN_STUB_RETRY_BASE` option (`none` returns no block) and `GARDEN_FOREMAN_STUB_RETRY_DIGEST`.
- **`scripts/jobs/test/foreman-completed-collision-test.sh`:** the existing scenario now covers "replacement is the same base: one note". New scenarios cover:
  - a valid replacement is posted with no note;
  - both digests carry the new fields;
  - an absent replacement makes exactly two handler calls and sends one note.

**Tests**
- All 8 `foreman*-test.sh` suites pass (14/14 in the collision suite), and `shellcheck -S warning` is clean.
- The suites that call the foreman (accountant-arc-apportionment, awaiting-maintainer-gate, ironhorse-press-budget) pass.
- `live-budget-admission-test.sh` has 4 failures, all budget-level leveling checks. The same 4 fail on unmodified `origin/main2`, so this change didn't cause them.

**Follow-ups**
- The `live-budget-admission-test.sh` failures on `main2` need their own fix.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-foreman-completed-step-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1472776 cached reads)
- Output: 16810 tokens
- Cost: $1.2687232000000002
- Wall-clock: 788s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
