Inbox empty. Work complete.

## Completion report

**Job:** `improve-gardener-signal-kill-classifies-transient-regardless-of-capture`

**Problem fixed:** The gardener handler-failure classifier only treated signal-kill exit codes (143 SIGTERM / 137 SIGKILL/OOM / 130 SIGINT) as transient on the *empty-`$capture`* branch. A gardener killed mid-job that had already flushed partial output (progress lines, or the folded tail of `$report`) skipped that branch and was falsely escalated to the gardener inbox as a `kind:error` real failure — exactly what hit `garden-deliberate-deploy-no-shared-tree-development` on 2026-06-27 (rc=143, escalated).

**What changed** (committed as `1d4f13620` on `origin/main2`):
- **`scripts/jobs/common.sh`** — added `is_external_kill_rc()` (`143|130|137`, deliberately **not** the offline rc, which stays gated on its own existing paths).
- **`scripts/jobs/gardener.sh`** — the classification block now consults `is_external_kill_rc "$rc"` **first**, before the `[ ! -s "$capture" ]` empty/non-empty split, setting `transient=1` so capture content is irrelevant for signal codes; only non-signal rcs fall through to the existing `is_transient_empty_failure` (empty-capture) and `is_transient_claude_signature` tests. The transient-branch journal note is preserved (still records `rc` and `reap_count`, so a job that signal-dies the same way every cycle stays greppable); I widened its wording from "empty/transient-signature" to "signal-kill/empty/transient-signature" for accuracy.
- **`scripts/jobs/test/signal-kill-classifier-test.sh`** (new) — SUBTEST 1 drives `is_external_kill_rc` directly (143/130/137 are kills; offline rc, 127/126/1/0 are not), mirroring the existing empty-output-classifier coverage; SUBTEST 2 is an integration test running the real `gardener.sh` against a throwaway board with a stub that exits rc=143 *after* writing non-empty output, asserting: non-empty-capture path exercised, transient verdict logged, **no inbox-escalation file**, no `kind:error` journal entry, and the job left in `doin` for the TTL requeue.
- **`scripts/jobs/test/signal-kill-handler-stub.sh`** (new) — the partial-output-then-signal-kill stub handler.

**Verification:** From the deployed location (`/home/kris`), the new test passes 13/13 and the existing `empty-output-classifier-test.sh` still passes 14/14. I also confirmed the fix is correctly scoped: a deterministic rc=1 with non-empty output **still** escalates (inbox file created). Both scripts pass `bash -n`. Built and committed via an isolated worktree off `origin/main2` per garden convention.

**Notes / follow-ups:**
- The integration test must be run from the deployed repo, not a `/tmp` worktree — `/tmp` is mounted `noexec` here, so the test's direct `gardener.sh`/stub invocations fail there. This matches how the existing `run-test.sh` is run and is not a defect in the change.
- There is no central test-all manifest to register the new test in; tests are run individually by name (consistent with the rest of `scripts/jobs/test/`).
- The pre-existing `OPEN` failed-job-lane question (doin vs a dedicated `jobs/failed/` lane) noted in `gardener.sh` is untouched — out of scope for this change.
