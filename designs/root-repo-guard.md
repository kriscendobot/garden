---
created: 2026-07-21
updated: 2026-08-28
author: gardener
---

# Root-repo guard: harden the deployed root against job git-escapes

| Created | 2026-07-21 |
| Author  | gardener |
| Status  | Implemented |

## The incident (2026-07-17 / 2026-07-21)

The deployed root checkout (`$GARDEN_ROOT`) and the `journal/` worktree **share one
repo** (`$GARDEN_ROOT/.git`). Twice, a job ran a git command with that shared repo as
its enclosing repository and corrupted it:

1. **Native-git test-fixture escape (2026-07-17).** A test created a dir under the
   root but never `git init`-ed it, so its `checkout -b feature` / `commit` ops
   **ascended** to the root repo. HEAD moved off the deployed detached commit
   (`374deede65`) onto a fixture `feature` branch, and the v1 `main` branch was moved
   too. **The fleet ran the fixture working tree for four days.**
2. **Project-work escape (2026-07-21).** A worker treated the root as its project
   checkout: `git remote set-url origin ssh://…/endojs/endo-but-for-bots.git`, a
   fetch that **pruned the true origin refs** (`origin/journal2`, `origin/main2`),
   and `git branch xs2rust-endor …` — all in the root repo. Journal sync broke
   **host-wide** (the journal worktree froze; `inbox-read`/`message-user` FATALed),
   and the journal-remote cache was poisoned. The fleet survived only because each
   per-gardener state clone pins its **own** correct origin.

Both incidents share a class: **a git command whose repo resolution ascends past, or
is aimed straight at, the shared root repo.** And both went undetected for days —
nothing asserted the root's invariants.

## The fix — three coordinated layers

Defense in depth, cheapest-first, each independently useful:

1. **Prevent the ascent (env).** The worker spine (`gardener.sh`, shared by every
   worker kind — gardener/cleric/hermit) exports
   `GIT_CEILING_DIRECTORIES=$GARDEN_ROOT`. Git's upward repo discovery stops at the
   root, so an **un-inited dir under the root FATALs** with "not a git repository"
   instead of latching onto `$GARDEN_ROOT/.git` (incident 1's mechanism). Legitimate
   work is unaffected: a per-job worktree, a project checkout, and the worker's own
   state clone each carry their own `.git` found without any ascent, and an explicit
   `git -C <dir>` is exempt (the ceiling never excludes a named/current dir). This
   does **not** stop a command aimed *straight at* the root (incident 2) — that is
   what layers 2 and 3 catch.

2. **Forbid it (prompt).** The worktree-discipline paragraph appended to every job
   prompt (`handlers/worker-common.sh` `worker_worktree_note`, byte-identical across
   backends) now states plainly: **never run git in `$GARDEN_ROOT`**; a stray
   `remote set-url`/`fetch`/`checkout`/`commit` there corrupts journal sync for the
   whole host; run git only inside your per-job worktree or a project checkout from
   `ensure-project-worktree.sh`; if a tool needs a scratch repo, create and
   `git init` it **outside** the root. This directly hardens the xs2rust-endor press
   family and every other job.

3. **Repair drift that still slips through (timer).** `root-repo-guard.sh`, wired to
   `garden-root-repo-guard.timer` (~30m, `:22/:52`), runs on **every host** (each
   host's root can be corrupted independently — not leader-gated). It asserts and
   losslessly repairs:

   - **Origin URL** must match `GARDEN_PRODUCTION_JOURNAL_REMOTE_RE`
     (`is_production_journal_remote`). A wrong origin breaks journal sync host-wide,
     so it is repaired eagerly — from a source the escape **cannot poison**: the
     origin of any per-instance journal clone under `$GARDEN_STATE`
     (`_journal_remote_from_state_clones`), **re-validated against the RE before it
     is written** so a repair can only ever set the canonical URL.
   - **HEAD** must be **detached at a `main2` ancestor** — never on a local branch
     (the `feature` escape), never at a commit unreachable from `origin/main2` (a
     fixture commit). Repair re-detaches HEAD onto the recorded deploy point
     (`deployed_sha` — so it **respects deliberate-deploy** and does not advance the
     deploy) when that is a `main2` ancestor, else onto the `origin/main2` tip. The
     prior HEAD is preserved as a `root-guard-backup/<ts>` branch ref first
     (lossless). Deferred while the fleet is **draining** (a deploy owns the tree)
     and when `origin/main2` is unresolvable (never reset toward an unknown target).

   - **Object store** must be **healthy and maintainable** — added 2026-07-28; see
     § Invariant C below for the failure mode and the repair ladder.

   - **Host filesystem inode headroom** must stay at or above
     `GARDEN_ROOT_GUARD_MIN_FREE_INODE_PERCENT` (default 5%). This is checked with
     `df -Pi` against the filesystem backing the bind-mounted root and classified
     independently from byte capacity. Below the threshold, the guard raises one
     coalesced maintainer notice; recovery closes that alert episode. It never
     deletes automatically because `df` cannot prove that a worktree is abandoned.

   Plus a **stalled-deploy watch**: when `deployed_sha` lags `origin/main2` past
   `GARDEN_DEPLOY_STALL_DAYS` (default 3), it alerts **once per breakage window**
   (the incident also noted deploys silently stalled since 07-17), cleared
   automatically on catch-up.

   Quiet on the healthy path (one line); every repair and alert is logged and paged
   (throttled per key). Always returns 0 — a transient hiccup never marks the tick
   Failed. The guard deploys to every instance via the standard unit-derived
   enable-set (a non-template `*.timer` with `WantedBy=timers.target` is
   auto-enabled), so no host list needs editing.

## Invariant C — the object store is healthy and maintainable (2026-07-28)

Invariants A and B assert what the root repo *points at*. Nothing asserted anything
about the store those pointers read from, and **no script anywhere in `scripts/` ever
ran `git gc`, `git repack`, or `git prune`** — the responsibility was owned by nobody,
on the assumption that git's own automatic cleanup covers it.

It does not, and the way it stops covering it is silent and **self-reinforcing**:

> A failed `gc` writes `.git/gc.log`, and while that file exists git refuses to run
> automatic cleanup at all — *"Automatic cleanup will not be performed until the file
> is removed."* Nothing in git ever removes it. One transient failure therefore
> disables maintenance **permanently**, and the resulting growth makes the next manual
> `gc` slower and likelier to fail.

### What that produced on the first host audited (endolin-garden2, 2026-07-28)

| Symptom | Measured |
| --- | --- |
| `git gc` | fails: `fatal: unable to read 9ad05cc3…` → `fatal: failed to run repack` |
| stale `gc.log` | present in the common git dir **and 5 worktree admin dirs** (Jul 27) |
| packs | **1301** (a gc'd repo sits at 1–2) |
| objects | 511,993 in-pack + 10,459 loose, 136 prune-packable |
| **orphaned temp packs** | **139 `tmp_*` files, 15.4 GB** — against a real store of ~320 MB |
| missing objects | 22, all reachable only from `journal2` (`origin/main2` and `main2` scan clean) |

The garbage figure is the headline: git's own `count-objects -v` reports it as
`size-garbage`, calls it "garbage found" on every invocation — and has **no code path
that ever deletes it**. The 48× disk overshoot was produced entirely by the failure
loop, not by the repo.

The mechanism is broader than failed repacks, and worth naming precisely because it
sets the sweep's age gate. **Every** pack write lands in `objects/pack/tmp_*` first and
is renamed into place only on success — a repack's output *and* every incoming fetch's
`index-pack`. So a repack that dies on a missing object strands one, and so does a
fetch that `bounded_fetch`'s `timeout` kills mid-transfer. On the audited host these
were being stranded at **~10 GB/day** (dozens per hour, 70–250 MB each), because with
1301 packs every fetch was slow enough to hit the timeout — the loop feeding itself
again. The sweep's age gate is therefore both the safety margin for a live writer and
the ceiling on steady-state garbage, which is why it is **6h** (~50× the longest pack
write the fleet can produce, all of which are `timeout`-bounded) rather than a day.

Fleet impact beyond disk and slowness: `journal/` is a **worktree of this same repo**,
so every journal sync paid the 1301-pack index scan, and every git call in the root —
a plain `git fetch` included — printed the gc.log banner on **stderr**, which is
exactly the unexpected-stderr noise the gardener's output classifiers read.

### The repair ladder

Same bounded/lossless discipline as A and B, cheapest first, each step conditional on
the previous one failing:

1. **Sweep the garbage** (`objects/pack/tmp_*` older than
   `GARDEN_ROOT_GUARD_TMP_AGE_HOURS`, default 6h). Unconditional, every tick, one
   `find` — pure reclamation of files git has already classified as garbage. The age
   gate is what keeps a **live** pack writer's temp file safe.
2. **Run a bounded `git gc`** when a `gc.log` is present or the pack/loose counts pass
   their ceilings (`GARDEN_ROOT_GUARD_MAX_PACKS` 50, `..._MAX_LOOSE` 10000 — git's own
   auto-gc thresholds). The gc.log(s) are removed **only once gc actually succeeds**,
   so the guard can never merely hide the signal it was written to act on; both the
   common copy and each `worktrees/*/gc.log` are cleared, since any one of them
   independently disables auto-gc for commands run from that worktree.
   `gc.worktreePruneExpire=never` is pinned: deregistering a worktree is
   `journal-worktree-keeper`'s job under its own active-writer gating, never a side
   effect of maintenance (a blanket worktree prune is the hazard that keeper
   documents — under a garden-root relocation the back-pointers are stale, so a prune
   deletes **live** entries).
3. **Recover non-destructively** — `git fetch origin --refetch` from the canonical
   remote (only when invariant A certified origin this tick). `--refetch` re-downloads
   the full history without negotiation, which is the point: a plain fetch cannot heal
   this, because git believes it already has those refs. It only ever **adds**
   objects — no prune, no ref moved. Then gc is retried once.
4. **Alert, do not amputate.** If gc still fails, alert **once per breakage window**
   (`objstore-alerted`, cleared on recovery — the stalled-deploy watch's shape) with
   the missing-object count, a sample, and a by-hand reconciliation recipe. The guard
   never repairs destructively on its own: the refs that reach a missing object are
   real history, so dropping them is a human decision, and any ref that must move gets
   a `root-guard-backup/<ts>` first (invariant B's discipline).

Deferred entirely while the fleet is **draining** (a deploy owns the tree), and backed
off to one attempt per `GARDEN_ROOT_GUARD_MAINT_INTERVAL_HOURS` (default 6) so a store
that cannot be repaired does not burn a multi-minute gc on every ~30m tick. The
per-step budgets (`..._GC_TIMEOUT` / `..._REFETCH_TIMEOUT` / `..._MISSING_SCAN_TIMEOUT`,
420/420/180s) sum under the unit's `TimeoutStartSec`, raised to 1800 to fit them.

### Where the damage came from — and what invariant C deliberately does not touch

The audit traced two separate contributors, only one of which is the guard's to fix:

- **The 07-21 project-work escape left permanent foreign refs.** The root repo carries
  **1,948 tags, 1,739 of them `@endo/*`** (plus the `SES-v*` series) — the endo
  monorepo's tags, fetched in when a job pointed the root's origin at
  `endojs/endo-but-for-bots`. Invariant A repaired the origin URL; nothing reverted the
  **fetch**. Those tags keep hundreds of MB of foreign objects permanently reachable,
  so gc can never drop them, and they are 1,948 of the repo's ~1,991 refs. Deleting
  1,739 refs is destructive by definition, so it stays a **human-gated one-time
  cleanup**, not something a timer does. The `--refetch` recovery is safe alongside
  them precisely because it is additive.
- **Per-job worktrees are being left behind.** The root repo had **102 registered
  worktrees** (101 `gardener-wt-*` plus `journal`), the oldest from Jul 10, all with
  live working directories (0 prunable) totalling 23 GB of `scratch/`. Every one is a
  gc root, and five carried their own stale `gc.log`. That is a **teardown leak, not a
  registration leak** — `git worktree prune` would remove none of them — so it is
  outside this guard and wants its own job against the gardener/reaper teardown path.

## Why not fold it into an existing keeper

The `journal-worktree-keeper` reconciles the *worktree* half of the shared repo; the
guard reconciles the *root checkout* half. They are separable invariants with
different repair machinery (the keeper's active-writer/backup gating vs. the guard's
detach-to-deploy-point), and a dedicated, independently-testable timer reads more
legibly than overloading the keeper. Cadence is offset (`:22/:52`) so it audits
after clone-keeper (`:00/:30`) and the journal keeper (`:15/:45`) have refreshed the
refs it compares against.

## Coverage

`scripts/jobs/test/root-repo-guard-test.sh` — hermetic (throwaway origin/root/state
clones; `GARDEN_PRODUCTION_JOURNAL_REMOTE_RE` overridden to match the fixture;
alerts captured via `GARDEN_ALERT_CMD`): healthy no-op, origin-drift repair,
HEAD-onto-a-branch repair with a lossless backup ref, non-ancestor-HEAD repair,
draining-defer, and the stalled-deploy alert (fires once past threshold, dedupes,
clears on catch-up).

Invariant C adds: aged `tmp_pack` garbage swept while a **fresh** one is left alone;
`gc.log` cleared after a gc that succeeds (common **and** per-worktree copies) but
**kept** while gc still fails; a healthy store as a quiet no-op; the unrepairable-store
alert firing once per window and clearing on recovery; the draining defer; the
back-off; and the real end-to-end recovery — a root whose packs are gone, where gc
fails, `--refetch` restores the objects from origin, and the retried gc then succeeds
with no ref dropped.

Invariant D adds deterministic `df` fixtures covering a low-headroom alert, recovery
notice, and malformed-output classification without a false alert.

## Invariant D — host filesystem inode headroom (2026-08-28)

The trigger host reached 244,091,381 of 244,121,600 inodes used (30,219 free,
effectively 0.01%) while byte use was only 79%. Git then failed to lock `.git/config`
with `ENOSPC`. This is not a comment-watcher defect: every service writing on that
filesystem can fail until inodes are reclaimed.

The container can see the host filesystem statistic through the bind-mounted garden
root, but cannot inventory the host's entire `/dev/nvme0n1p2`. A bounded audit of the
visible garden found about 1.34 million unique directory entries under `scratch/` and
996 thousand under legacy `worktrees/`; this is material but does not explain the
filesystem-wide 217–244 million used inodes by itself. The filesystem had already
recovered to 27,084,523 free inodes (11.09%) during the audit, which also demonstrates
why this must be a recurring guard rather than a one-shot diagnosis.

The seven named legacy `endojs-endo-but-for-bots` worktrees all have corresponding
completed records in `jobs/tada/`. Their `node_modules` trees account for about
172,320 unique inodes as one hardlink-aware batch. The reviewed cleanup proposal is:

1. Reconfirm the matching `jobs/tada/` record and absence from `jobs/doin/` immediately
   before each removal. Treat a missing or ambiguous mapping as a stop, not permission.
2. Remove at most these seven worktrees in one batch, through the owning bare repo's
   `git worktree remove` mechanism (never a recursive unlink first):
   `gardener-fixer-442`, `port-pr57`, `pr472-shepherd`, `pr513-gauntlet`,
   `shepherd-461`, `pr438-fixer`, and `pr96-finish`.
3. Run `git worktree prune --dry-run`, then `df -i` and a registration audit. Stop
   after this batch and review the measured recovery before selecting more targets.

This bounds both the deletion set and the evidence needed to authorize it. It does
not claim those seven explain the host-wide exhaustion, and the timer deliberately
does not execute the cleanup.
