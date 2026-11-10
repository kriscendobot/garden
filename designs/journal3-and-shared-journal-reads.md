# journal3, a separate tada branch, and shared journal reads

| Status | Draft for maintainer review |
| Date   | 2026-11-10 |

## Problem

On 2026-11-09 `.garden-state/sandbox-state` held 131 GB across 259 per-job
`GARDEN_STATE` directories. Each held a full journal clone: a 335 MiB pack plus a
0.4 GiB working tree. The directories came from the per-job state that gave
sandboxed jobs a writable `GARDEN_STATE` (`f2788117645`). A second, smaller leak
(`journal-worktree-keeper` backups, ~470 GB) had the same shape: a copy of the same
tree on every tick.

Both are fixed in place (`e522b2762e0`, `0a1742f8211`): borrowed objects, cleanup on
exit, a 6 h sweep, bounded backups. They treat the symptom. The cause is that
`journal2` is one ever-growing branch every reader must carry whole.

`journal2` today (pack 605 MiB at the root, 2026-11-10):

| Path | Size | Files |
|---|---|---|
| `jobs/tada` | 73 MB | 17,030 |
| `reputation` | 60 MB | 14,854 |
| `entries` | 60 MB | 12,969 |
| `library` | 55 MB | 9,366 |
| `usage` | 50 MB | 12,246 |
| `inbox` | 33 MB | 7,599 |
| `msgs` | 14 MB | 3,399 |
| `jobs/todo` | 1 MB | 53 |

Almost all of it is append-only history that a live reader (the board, the inbox)
does not need.

## Proposal

1. **`journal3`, a fresh orphan branch.** Seed it with the live working set only:
   `jobs/{todo,doin,plan,orch,gauntlet}`, `inbox`, `msgs`, config and marker files,
   `maintainers`, `trusted-senders`, `leader`, and the schedule and orchestration
   records. Leave history behind. `journal2` is frozen read-only and kept as the
   archive.
2. **Dedicated append-only branches** for data that is written once and read rarely:
   - `journal3-tada`: completion reports (`jobs/tada`).
   - `journal3-ledger`: `usage`, `entries`, `reputation`.
   Writers push there directly with the same CAS. Readers that need history fetch
   the branch on demand, blobless and single-branch.
3. **Shared reads for sandboxed jobs.** A job gets the host's journal clone
   read-only (bind mount) and writes only through a small trusted helper outside the
   sandbox (inbox reads, messages, reports). No per-job clone exists at all.
4. **Cutover** through the existing `JOURNAL_BRANCH` variable (default `journal2`,
   `common.sh`). 280 scripts name `journal2` literally, so the first step is a
   mechanical sweep to `${JOURNAL_BRANCH}` with a lint that forbids new literals.
   Then a drained cutover: drain the fleet, copy the live set, flip the default
   and the `config` marker, deploy, lift.

## Risks

- **Cutover race.** A drained fleet makes the copy a single-writer operation. A
  job in flight at the cutover must finish or be requeued first.
- **History readers.** `reputation` replays adds and deletes, and creation-time
  lookups walk `git log`. They need the ledger branch or a one-time import of their
  state.
- **Orphaned references.** Reports and issue comments link `journal2` paths.
  Keep `journal2` readable indefinitely and have link builders fall back to it.
- **Alternates.** The borrowed-object clones depend on the root repo keeping their
  objects. Once `journal3` replaces `journal2`, objects reachable only from a
  deleted ref could be pruned. Keep the `journal2` ref in the root.
- **Helper trust surface.** The write helper widens what a sandboxed job can ask
  the host to do. It should accept only a closed set of verbs (as the sysop does)
  and take no paths.

## Test plan

Dry-run the cutover on a scratch remote with the real branch. Replay a day of
bus traffic against `journal3`. Run the board, inbox, reaper and gauntlet test
suites with `JOURNAL_BRANCH=journal3`. Lint for stray `journal2` literals.
Measure a cold per-job clone and the host clone before and after.

## Open questions

1. **Split or not.** Do we move only `jobs/tada` (the largest and simplest), or also
   the ledger directories (`usage`, `entries`, `reputation`)?
2. **History import.** Start `journal3` with no history (clean orphan), or import a
   bounded window (say 90 days) of `tada` and `usage` so dashboards keep working?
3. **Write helper vs. shared writable clone.** Is a trusted helper worth its extra
   trust surface, or should sandboxed jobs keep a per-job clone that is shallow,
   blobless and sparse?
4. **Cutover timing.** Do it now, while the minion.town press and waitlist work are
   in flight, or after they land?
5. **`journal2` retention.** Keep it as a read-only branch forever, archive it to a
   separate repo, or delete it after N months?
