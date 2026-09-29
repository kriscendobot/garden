---
created: 2026-09-29
updated: 2026-09-29
author: builder
---

# Host-local Git repository locks

Fleet Git calls now enter `scripts/jobs/bin/git`, which delegates to the helpers
in `common.sh`. The existing fleet PATH setup installs this entrypoint alongside
`bin/gh`. Using an executable also covers `timeout git`, subprocesses, and commands
in sourced helpers. It preserves the original Git arguments and exit status.
The wrapper loads only the repository helpers, avoiding job-board initialization
on every Git call. `GARDEN_ROOT` and `GARDEN_STATE` are exported to children.

## Locks and transaction boundaries

A SHA-256 of the canonical absolute `git-common-dir` names a directory beneath
`$GARDEN_STATE/repo-locks/`. Linked worktrees and symlink aliases share a lock;
independent clones have independent locks. No lock or freshness record is committed
to the journal. Every flock wait defaults to 10 seconds, configurable with
`GARDEN_REPO_LOCK_WAIT`, and returns 124 on timeout.

Fetch and pure object/ref queries take a shared repository lock. Mutations take
an exclusive lock; unknown command shapes are conservatively exclusive. Fetches
also take an exclusive per-repository fetch mutex, because Git updates tracking
refs and `FETCH_HEAD` even though fetching is a read of the upstream branch.
Consequently only one fetch runs in a repository at a time, and no fetch overlaps
a writer. Pure readers can overlap one another and a fetch.

`garden_repo_lock DIR shared|exclusive` holds a lease until
`garden_repo_unlock DIR` or process exit. `garden_repo_run DIR MODE COMMAND...`
scopes a lease to a subshell. Inherited descriptors allow synchronous nested
helpers to borrow a parent's lock; the helper checks that the descriptor still
names the expected lock inode. Shared-to-exclusive upgrades fail explicitly.
Do not launch parallel mutating children inside a borrowed transaction.

The existing clone lock takes the exclusive repository lease before returning.
Thus `sync_clone` through `commit_and_push` includes the fresh fetch, reset,
mutation, commit, CAS push, and fresh verification in one transaction. This
covers claim-job, post-job, complete-job, set-* writers and the other journal
producers without separate lock implementations. Their cross-host push rejection
and retry rules are unchanged. Worker prompts also require the lease around garden development fetch/rebase/push
loops. The one-shot tada migration holds the same lease
across its fetch/reset/commit/push loop. Distinct per-worker clones still race at
the remote; the lock does not pretend different object stores are one repository.

The root guard holds an exclusive lease across raw lock-file cleanup, repairs,
and gc. The worktree keeper likewise covers gitfile repairs and filesystem
changes. Deploy takes the lease for the final tree check and atomic swap, after
candidate testing and fleet drain. The authorized sysop maintain operation already
delegates to the root guard, so it needs no second locking implementation.
A maintenance request that times out acquiring the lease reports `refused`, never
`applied`.

Holder records contain PID and acquisition time. On timeout the diagnostic names
dead and overdue holders (`GARDEN_REPO_LOCK_STALE`, default 120 seconds).
The helper **never deletes or replaces a flock inode to steal a lock**: inherited
children could still hold the old inode. Dead metadata can be discarded after
acquisition. Git operations on existing repositories are bounded by
`GARDEN_REPO_GIT_TIMEOUT` (120 seconds, plus a five-second kill grace); root gc
inherits its longer maintenance budget. Clone/init retain their existing caller
budgets. Fetch disables automatic maintenance; other Git operations disable
detached maintenance so a background gc cannot escape its lease.

## Freshness

Successful simple fetches of `origin/main2` and `origin/journal2` (including
configured branch names and named remotes) record completion time and tracking
OID. The key includes repository, remote name, remote URL and branch. The default
maximum age is five seconds (`GARDEN_FETCH_MAX_AGE`). A call can use
`GARDEN_FETCH_MAX_AGE_OVERRIDE=N`; `journal_fetch DIR N` exposes the same control.
Zero demands a new fetch, or accepts one that finished after the caller arrived.
Thus concurrent demand-fresh callers can share an in-flight fetch.

A waiter checks freshness only after acquiring the fetch mutex. It also checks
that the tracking OID and this worktree's `FETCH_HEAD` still equal the recorded
OID. A clock reversal, missing ref, changed remote, expired timestamp, or
incompatible fetch arguments causes a fetch. Options such as `--refetch`, filters,
custom refspecs, and arbitrary project branches are serialized but never cached.
A failed fetch invalidates its prior success record and returns failure.

Journal transactions and post-push verification demand zero age. The six watcher
`verify_fetch fresh` paths pass zero explicitly, as do the mention/deadmail
post-confirm readers and backfill post-write refresh. Leader refreshes
also demand zero age; the existing leader-cache TTL and fail-open fallback remain.
On a failed leader fetch the last-known answer is logged as stale and **does not
refresh the leader-cache timestamp**. This addresses the stale-leader failure in
`garden-state-clone-bloat-wedge` without changing the default leader policy.
Optional callers retain their existing skip/fallback behavior; mandatory fetches
still fail rather than treating an old ref as a successful refresh.

## Call-site survey

Before editing, every fetch/push occurrence under `scripts/jobs/` was surveyed,
including multiline `bounded_fetch` and `timeout` invocations. Migration uses the
single PATH entrypoint rather than rewriting each command's arguments:

| Family | Entry and policy |
| --- | --- |
| `common.sh`: `_journal_git_fetch`, `bounded_fetch`, `_push_journal`, `anchor_blob` | Wrapper; journal CAS paths demand fresh; arbitrary anchor refs are exclusive writes. |
| `watchman`, `upgrade-monitor`, `scheduler`, `handlers/mentor-claude` | Wrapper; simple main2 reads can reuse the freshness window. |
| `deploy-garden`, `resolve-wedge`, `root-repo-guard` | Wrapper; deploy demands fresh and locks its final swap; guard locks repairs and maintenance. |
| `journal-worktree-keeper`, `clone-keeper` | Wrapper; keeper holds root lease across repairs; clone keeper preserves `FETCH_HEAD` semantics. |
| `migrate-tada-shards` | Newly sources common.sh and holds an exclusive transaction. |
| `transcript-capture` | Wrapper inside existing timeouts; transcript branches/options are not cached. |
| `ensure-project-worktree`, `triager`, `handlers/ironhorse-fuzz-run-gh`, `gardening/{safe-push-pr-head,safe-rebase,rebase-pr-before-merge}` | Fleet children inherit the wrapper; project fetches are serialized without freshness reuse. Standalone project scripts outside fleet PATH retain ordinary Git. |
| Test fixtures and `ensure-pr`/worker prompt examples | Fixture setup and documentation are not upstream garden callers. |

Locks are cooperative: an absolute Git executable, an external shell without the
fleet PATH, or a process still running pre-deploy code can bypass them. Normal
fleet deploy/restart is required for full host coverage. There is no new daemon.

## Evidence

`bash scripts/jobs/test/repo-locks-test.sh` exercises real repositories and flock:
parallel fetch coalescing, demand-fresh coalescing, TTL expiry, failure invalidation,
shared readers, exclusive timeouts, worktree aliases, independent repositories,
inherited leases, hung-Git termination, stale-holder diagnostics, parallel journal
CAS writers across linked worktrees, and stale leader fallback. CI runs this suite. Disabling cache reuse
made its parallel-fetch assertion fail (12 actual fetches, expected one). Disabling
repository flock acquisition made the cross-worktree CAS test fail with overlapping
writers. Restoring both changes returned the suite to passing.

A live probe on `endolin-garden2-5bcdff64`, from this job's worktree against
`origin/main2`, made one demand-fresh request followed by 12 parallel requests with
a 30-second allowance. All 13 succeeded with **one actual fetch**: 92.3% fewer
fetches than one per request. This measures that workload, not fleet-wide traffic.

Compatibility checks passed: root guard 76, journal keeper 117, worktree relinking
25, cursor outage 61, stale-lock recovery 9, worker-worktree 6, and all 12
`tests/checks/run.sh` suites. The full job-system suite matched the unchanged
baseline at 394 passes and two existing scaler-log failures; the deploy suite
matched at 157 passes and five existing worker-kind/log failures. ShellCheck and
syntax checks passed for the new helpers and changed shell scripts.
