# Harden the producer push path: confirm the push landed; fix the shared-clone race

Wear the **mentor** role (`roles/mentor/AGENT.md` — reliability/self-improvement).
A producer (`post-job.sh`) has been observed printing "posted" while the job did
**not** land on `origin/journal2` — silent directive loss. Fix it in the **shared
primitive** so every producer is covered, not just `post-job.sh`.

## Root cause (confirm, then fix)

The push path lives in `scripts/jobs/common.sh`:
- `sync_clone()` does `git fetch` + **`git reset -q --hard origin/$JOURNAL_BRANCH`** +
  `git clean -qfd jobs`.
- `commit_and_push()` does `git commit` then `git push -q origin HEAD:$JOURNAL_BRANCH`
  and **returns 0 on push success** with no verification.

The producer clone is a **single shared directory** (`$GARDEN_STATE/producer/journal`)
used by **all** producers on the host (post-job, complete-job, schedule, bulletin,
inbox-send, …). Concurrent producers race on the same working tree, index, and HEAD:
one process's `sync_clone` `reset --hard`/`clean` can discard another's
just-written/just-committed job before it pushes, and the commit/push interleave —
so `git push` can return 0 having pushed a HEAD that no longer carries the job, or the
job file gets cleaned away. The symptom set this session (silent post loss, a
`refs/remotes/origin/journal2` fetch ref-lock, transient fetch failures) all point to
this shared-clone contention. Confirm this is the mechanism before fixing.

## The fix (in the shared primitive — covers every producer)

Two layers; implement both:

1. **Serialize access to the shared clone** so the sync→write→commit→push critical
   section is atomic per clone. Wrap it with **`flock`** on a per-clone lock file
   (e.g. `flock "$dir/.garden-producer.lock"` around the operation), **or** give each
   producer process its own clone/worktree so they never share HEAD. `flock` is the
   smaller change; justify your choice. This removes the race at the source.
2. **Verify-after-push (the maintainer's explicit ask: confirm the push, retry on
   silent loss).** After `git push` reports success in `commit_and_push`, **confirm
   the pushed commit is actually reachable from `origin/$JOURNAL_BRANCH`** (re-fetch
   and check the commit is an ancestor of / equals the remote tip, or that the
   specific path exists at the remote tip). If verification fails, **return failure**
   so the caller's retry loop re-syncs and re-posts rather than reporting success.
   Make `commit_and_push` (or a new `commit_and_push_verified`) the single place this
   lives, so post-job, complete-job, claim-job, schedule, bulletin, inbox-send, and
   every other caller inherit it.

3. Ensure callers treat the new "pushed-but-not-verified" outcome as a retry, not a
   success — `post-job.sh` already loops up to 50×; confirm the verify-failure path
   re-enters the loop and that the final `die`/give-up is loud (never a silent
   "posted").

## Why this matters beyond post-job

`inbox-send.sh` uses the same primitive, so the **dead-mail loss** (a message that
silently fails to land) and the **silent post loss** share this root cause — the
companion `audit-inbox-discipline-and-deadmail` job hardens delivery semantics, while
this job hardens the push itself. Note the relationship in your report so the two
fixes compose rather than overlap.

## Tests & verification

- **Concurrency test:** spawn N (≥8) concurrent `post-job.sh` calls with distinct
  basenames against a shared clone; assert **all N** land on `origin/$JOURNAL_BRANCH`
  (none silently lost). Without the fix this should be able to lose at least one.
- **Silent-loss test:** stub/inject a push that "succeeds" without advancing the
  remote and assert `commit_and_push` returns failure and the caller retries.
- `shellcheck`/`bash -n` clean on `common.sh` and any caller touched.

## Definition of done

`commit_and_push` (and the shared push path in `common.sh`) hardened with serialized
clone access and verify-after-push; callers retry on the new failure mode and never
print success on a lost push; concurrency + silent-loss tests added and green;
committed and pushed to `origin/main2` (bot identity). Report the SHA, the
serialization mechanism chosen, and the concurrency-test result (N posted / N landed).
If a write/push is blocked, report the diagnosis and ready-to-apply change rather than
claiming completion.

Posted by the liaison on behalf of the maintainer.

