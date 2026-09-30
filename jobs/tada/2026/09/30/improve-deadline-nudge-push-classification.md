Fixed: `deadline-nudge.sh` now retries a failed push only when it is a race or unclassified; a definite rejection is dropped straight away with one repair alert. The deadline-nudge test suite passes 54/54, and the change is pushed to `main2` as `7553b66c572`.

**The problem.** `deadline_nudge_tick` treated every failed push as a lost race. So a rejection that can never succeed — bad credentials, an upstream that's gone, or a server-side hook or policy refusing the push — was re-synced and retried until the attempts ran out. Every timer tick then logged a fresh "push stage exhausted" warning, which is what produced the repeats at 04:31:31, 04:33:00 and 04:34:29.

**The fix** (`scripts/jobs/deadline-nudge.sh`):
- **Retry decision:** after a failed push, the tick checks the class that `commit_and_push` already records in `GARDEN_COMMIT_PUSH_CLASS`.
  - `cas` (a lost race) and unclassified failures still re-sync and retry as before, so the ambiguous case (like a push that reports success but never lands) behaves the same.
  - `definite-fail` and `server-reject` go to a new `push_rejected` helper instead, and are not retried.
- **What `push_rejected` does:**
  - Logs one clear line naming the class, saying it is not a lost race, and giving the push error text.
  - Resets the private clone to the remote tip and removes any inbox files it wrote. The next tick then recomputes every warning that is still due.
  - Calls `alert_maintainer_edge` once, keyed on `deadline-nudge-push-rejected:$GARDEN` with the class as the fingerprint. It alerts when the rejection starts or changes class and stays silent while the same one persists.
  - The tick returns 0, so there's no per-tick "failed locally" warning.
- **Recovery:** the next successful push calls `alert_maintainer_edge_clear`, which sends a single recovery notice.

**Tests** (`scripts/jobs/test/deadline-nudge-test.sh`, plus a new stub `deadline-nudge-reject-push-stub.sh` that counts how often it's called and returns a GitHub rule-violation "remote rejected" error). With 3 push attempts allowed, the tests check that:
- **First rejection:** the push runs once; the output says neither "lost a race" nor "exhausted"; the alert fingerprint is `server-reject`; nothing lands on the board; and the clone is back at the remote tip with a clean working tree.
- **Repeated rejection:** a second tick with the same error pushes once more but raises no second alert.
- **Recovery:** a tick with a normal push delivers the warning and clears the alert.

The existing `/bin/false` test, which fails with no error text, still retries, runs out of attempts and reports it, as before.

shellcheck reports nothing new against the previous version of `deadline-nudge.sh`, and the new stub is clean.

**Follow-up:** hosts pick this up at the next rolling deploy. The job's notes don't say which rejection class caused the 04:31–04:34 warnings. If it was an unclassified failure, it will still retry and report exhaustion, and a sample of the push error text would be needed to tighten the classifiers in `common.sh`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadline-nudge-push-classification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1097180 cached reads)
- Output: 9083 tokens
- Cost: $1.007448
- Wall-clock: 711s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
