## Completion report: improve-sandbox-writable-job-state

Sandboxed jobs now get their own writable `GARDEN_STATE` directory, so agents no longer need the manual workaround. Pushed to `main2` as **f2788117645**. It only reaches workers after the next deploy.

**What changed in `scripts/secrets/run-sandboxed.sh`**
- **Per-job state:** each job gets a fresh `$GARDEN_STATE/sandbox-state/sbx-state.*` directory. Only that directory is writable, and it is exported as `GARDEN_STATE`. The host's real state (worker clones, markers, secret-broker) stays read-only, and so do other jobs' state directories.
- **Inherited paths unset:** `GARDEN_WORKER_CLONE`, `GARDEN_PRODUCER_CLONE`, `GARDEN_INBOX_CLONE`, `GARDEN_JOURNAL_CLONE_BASE` and `JOURNAL_REMOTE_CACHE` are cleared. They pointed into the read-only host state, or at the worker's own journal clone. Now they are rebuilt under the job's own directory.
- **One shared exception, `repo-locks`:** the job's `repo-locks` links back to the host's `$GARDEN_STATE/repo-locks`, which is made writable. Without this, the required `garden_repo_lock` push loop would stop serializing same-host pushes to the shared repo.
- **Cleanup:** leftover state directories older than 2 days are deleted when the next job starts. If any step fails, the sandbox launches as it did before this change instead of refusing to start.

**Tests**
- New test `scripts/jobs/test/run-sandboxed-state-test.sh`: 4/4 pass. It checks that job state is writable while host state stays read-only, the inherited clone paths are gone, `repo-locks` is shared with the host, each run gets its own directory, and one job cannot write another's.
- Existing tests still pass: `run-sandboxed-tmpdir-test.sh` (1/1) and `secret-management-test.sh` (15/15). Shellcheck only reports a note about `lib.sh` that was there before.

**Docs and memory**
- `context/operations/oros-secrets-handoff.md` now describes the per-job `TMPDIR` and `GARDEN_STATE` binds.
- I updated the host-endolin-ece02cb4 memory note: the problem is marked fixed, with a hint to check for deploy lag if the error shows up again.

**What happened during this job:** my own push hit the bug. The lock file under `repo-locks` was read-only in this sandbox, so the first push attempt failed and sent nothing. I pushed again with `GARDEN_STATE=$TMPDIR/state`. That push therefore wasn't serialized against other jobs on this host, but the rebase-and-push retry loop still guards against racing pushes.

**Follow-ups**
- Once deployed, a monk job should confirm that `inbox-read.sh` and `message-user.sh` work inside the sandbox without the workaround.
- Each job now makes a fresh journal clone the first time it reads its inbox or sends a message. That costs some time per job, but jobs no longer share a clone with the worker running them.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-sandbox-writable-job-state.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1129936 cached reads)
- Output: 10553 tokens
- Cost: $1.0186632
- Wall-clock: 119s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
