---
created: 2026-08-13
author: designer
---

# Date-sharded `jobs/tada/`: make recently-completed work easy to find

| Created | 2026-08-13 |
| Author  | designer |
| Status  | Design (not yet implemented) |

## The problem (kriskowal, 2026-08-13)

`jobs/tada/` is the garden's permanent record of completed work — a tada report
outlives the board and is never reaped. It is **one flat directory of 4,521
entries and growing.** Every consumer that wants "this week's completions" —
the bulletin dashboard, `follow-up.sh`, a human `ls` — must list and sort the
whole thing. The maintainer's goal is narrow and concrete: **recently completed
work should be easy to find.**

Target shape:

```
jobs/tada/<yyyy>/<mm>/<dd>/<base>.md
```

e.g. `jobs/tada/2026/08/13/garden-tada-shard-01-design.md`. This design confirms
that shape (the goal is the constraint, not the exact path — see § Path shape),
and — more importantly — settles the five hazards that make the change dangerous
on a *running* leader+follower fleet, and specifies the refactor that keeps the
layout in **one** place instead of the ~27 it lives in today.

The single highest-risk decision is **basename lookup** (§ 1): `post-job.sh` is
idempotent by basename, and it consults `tada/` by a direct-path probe. Sharding
breaks that probe. Get it wrong and either a completed base silently **re-mints**
(a duplicate job — noisy, self-healing) or a fresh directive is silently
**dropped** (the endo-but-for-bots #671 "Shepherd." shape — invisible, and the
work never happens). The design makes every lookup **fail toward re-minting.**

## Path shape

`jobs/tada/<yyyy>/<mm>/<dd>/<base>.md`, confirmed. Rationale over the
alternatives:

- **Day granularity, three levels.** A `<yyyy>/<mm>` split alone still grows a
  month directory to ~1,300 entries at the current rate; day directories cap a
  leaf at the fleet's daily throughput (tens to low hundreds) and make "this
  week" a read of ≤7 leaf directories.
- **Zero-padded, lexically sortable.** `2026/08/13` sorts identically as text
  and as a date, so `find … | sort` and a tree walk both yield chronological
  order for free — which is exactly what the bulletin's "recent completions"
  panel wants.
- **Base stays the leaf stem.** `<base>.md` is unchanged as the final component,
  so every "read this base's report" call site changes only its *directory*
  computation, never its parsing of the file.

One reserved sibling bucket, `jobs/tada/undated/<base>.md`, holds any entry
whose completion date cannot be recovered (§ 2). It is a plain leaf under the
same root, so the recursive lookup (§ 1) covers it with no special case.

## 1. Basename lookup — the load-bearing decision

Today the truth of "has base *X* completed?" is a single `test -e
jobs/tada/X.md` (or a `git cat-file -e <ref>:jobs/tada/X.md` against a
snapshot). Under sharding the path is no longer computable from the base alone —
it depends on *X*'s completion date, which the asker does not know.

**Decision: exhaustive recursive scan, no separate index.** The lookup helper
enumerates `jobs/tada/**/<base>.md` (working-tree find, or `git ls-tree -r`
against a ref) and returns the first hit, or non-zero if none. We deliberately
**reject** two tempting alternatives:

- **A maintained index** (`jobs/tada-index/<base> → path`). An index is a second
  source of truth that can drift from the tree — and a drift where the index
  says "absent" while the file exists is *exactly* the #671 drop shape, plus it
  adds a second CAS write to every completion. The filesystem is already the
  index; a `find` over a sharded tree of a few thousand files is sub-10ms. Keep
  truth in one place.
- **A date-bounded search** ("only scan the last N days"). This reintroduces the
  drop: a base older than the window reads as absent. It is a performance
  optimization for a problem we do not have (the scan is already cheap), bought
  at the price of the one failure mode we must avoid.

**How it fails, and why toward re-minting.** The scan reads the live tree (or a
named commit). Its only failure is *not finding* an entry that exists — which
would require a `find`/`ls-tree` that silently skips a subtree. We avoid that by
using an unbounded recursive enumeration (no `-maxdepth`, no date window), so a
present entry is always found. If the scan nonetheless returns "absent" for a
present base, the caller's behavior is:

- `post-job.sh` **no-identity** dedup (`post-job.sh:204`): absent ⇒ the job is
  re-posted ⇒ a **duplicate** completed-base job runs. Noisy, wasteful, but
  self-healing and visible — never a dropped directive.
- `post-job.sh` **with-identity** path is unaffected: it dedups on the
  `jobs/index/<hash>` directive map via `job_in_lifecycle`, so a fresh directive
  that merely re-derives an old base is *already* not swallowed by a stale tada
  entry (this is the #671 fix, and it stays intact — see § 3, `job_in_lifecycle`).

There is no code path where an absent-read causes a **drop**. That is the
invariant the helper is built to guarantee: `tada_find` may only ever err on the
side of "not found → re-mint."

## 2. Which date, and where it comes from

**The date is completion time, chosen once at write and frozen into the path.**
No reader ever recomputes it, so a given entry resolves to exactly one path on
every read, on every host, forever. Concretely:

- **New completions** (the common case). The writer — `complete-job.sh`, and the
  auto-retire writers in `ci-watcher.sh`, `orchestrate.sh`, `gauntlet.sh` — picks
  the shard from `date -u +%Y/%m/%d` **at write time**. The file is created at
  that path and committed in the same push, so the path is fixed the instant the
  entry exists. This is not "date at read time": it is date at *write* time,
  encoded permanently in the path. Write time and the completing commit's
  committer time differ by milliseconds; either is a correct completion instant.

- **Existing entries, at migration** (§ 5). The completion date is recovered
  deterministically from git history — the entry's **add commit**:

  ```sh
  git log --diff-filter=A --format='%cd' --date=format:'%Y/%m/%d' \
      -- jobs/tada/<base>.md | tail -1
  ```

  `--diff-filter=A` + `tail -1` selects the *first* commit that added the path
  (a base that drained and re-completed keeps its original add). This reads only
  committed history, so it is identical on every host and every re-run.

- **Unrecoverable date.** If the add commit cannot be found (history rewrite, a
  file that somehow never had an add commit), the entry goes to
  `jobs/tada/undated/<base>.md` rather than being guessed or skipped. It stays
  findable (the recursive lookup covers `undated/`), just not date-placed. In
  practice this bucket should be empty; it exists so migration can never lose an
  entry it cannot date.

## 3. The refactor — one place, not twenty-seven

Today ~27 scripts spell `jobs/tada` themselves (enumerate with `grep -rln -E
'JOBS_TADA|jobs/tada' scripts/`). Sharding must not become a 27-file sweep on
every future change. Centralize **all** tada path construction and lookup into
`common.sh` helpers; every consumer calls a helper and never constructs a tada
path inline again.

### New `common.sh` helpers

```sh
# Write path for a NEW completion, dated now (leader/worker completion writers).
tada_write_path() { printf '%s/%s/%s.md\n' "$JOBS_TADA" "$(date -u +%Y/%m/%d)" "$1"; }

# Path a base's report would take for a GIVEN date (migration + tests).
tada_path_for()   { printf '%s/%s/%s.md\n' "$JOBS_TADA" "$2" "$1"; }   # <base> <yyyy/mm/dd>

# Find an existing entry in the WORKING TREE. Prints rel path, or returns 1.
# Flat-tolerant during rollout (§ 4): checks the legacy flat path first, then
# the sharded tree. Unbounded recursion — never a maxdepth/date window.
tada_find()  { … flat jobs/tada/<base>.md, else find jobs/tada -name <base>.md … }

# Boolean wrapper (replaces every `[ -e "$DIR/$JOBS_TADA/$base.md" ]`).
tada_exists() { tada_find "$1" "$2" >/dev/null; }

# Find an existing entry against a COMMITTED ref/snapshot (readers that must be
# atomic w.r.t. a working-tree reset — orchestrate.sh, the watchers). Prints the
# rel path in that tree, or returns 1.
tada_find_tree() { … git -C <dir> ls-tree -r --name-only <ref> -- jobs/tada | match <base>.md … }

# Recent-window lister for dashboards (bulletin, cost): all entries whose shard
# date is within <days>, newest first, WITHOUT walking the whole tree when the
# window is small (iterate day shards descending, stop past the horizon).
tada_recent() { … }
```

`tada_find`/`tada_find_tree` return the **actual** path so callers that then
`git rm` or `git show` the entry (gauntlet child-retire, usage-meter fallback
read) operate on the real location, not a reconstructed guess.

### Consumer disposition

From `grep -rln -E 'JOBS_TADA|jobs/tada' scripts/` (non-test). **Dangerous** =
a subtle break drops or double-runs work; **noisy** = a break is visible
(a wrong count, a missing dashboard row).

| Consumer | Current use | Change | Risk |
|---|---|---|---|
| `post-job.sh:204` | `[ -e tada/$base.md ]` idempotency (no-identity) | `tada_exists` | **DANGEROUS** — must fail toward re-mint (§ 1) |
| `common.sh` `job_in_lifecycle`, `journal_identity_owner_live` | exact tada probe in the plan/todo/doin/tada loop | tada arm via `tada_find`/`tada_find_tree`; other arms unchanged | **DANGEROUS** — underpins with-identity dedup (#671 fix) |
| `orchestrate.sh:121,398,401` | `ls-tree <snap> -- tada/$c.md` child-state; write child summary | tada arm of the snapshot probe via `tada_find_tree "$snapshot"`; write via `tada_write_path` | **DANGEROUS** — a missed tada reads `gone` → halts a serial campaign |
| `gauntlet.sh:99,161,164,368,480` | stage-done check, write, retire, parse | `tada_exists`/`tada_write_path`/`tada_find` | **DANGEROUS** — child-completion detection |
| `follow-up.sh:108,156` | recursive `find tada` scan; `base=${rel#tada/}` | already recursive; fix base extraction to strip the shard (`basename … .md`); seen-marker migration (§ 5) | **DANGEROUS** — re-notify storm on migration |
| `unblock.sh:147` | `[ -f tada/$artifact.md ]` + `tada_failed` | `tada_find` then `tada_failed <path>` | **DANGEROUS** — blocked-dependency gate |
| `complete-job.sh:136-155` | write `tada/$base.md` | `tada_write_path` | writer — safe once readers tolerant (§ 4) |
| `ci-watcher.sh:211-223` | auto-retire write | `tada_write_path` | writer |
| `promote-plan.sh:84`, `post-plan.sh:235`, `post-gauntlet.sh:146`, `post-orchestration.sh:172,178`, `scheduler.sh:363`, `pages-watcher.sh`, `dependabot-watcher.sh`, `annotate-plan.sh`, `approval-reconciler.sh`, `library-source-drift-scan.sh` | exact-path existence in a lifecycle guard | `tada_exists` | noisy at worst (a duplicate/skipped guard) |
| `mention-watcher.sh:165`, `comment-watcher.sh:504` | `cat-file -e origin/journal2:tada/$base.md` already-completed check | `tada_find_tree "$dir" origin/$JOURNAL_BRANCH` | noisy (a re-triage) |
| `bulletin.sh:197,238` | `list_jobs tada` count; `find -maxdepth 1` recent | `tada_recent`; count via recursive find | noisy (dashboard) |
| `cost.sh:67` | `find -maxdepth 1` count | recursive find | noisy (denominator) |
| `reputation.sh:506-509`, `usage-meter.sh:356` | git-log pathspec / fallback read of `tada/$base.md` | `tada_find` for the path | noisy (fail-open metrics) |
| `cnf-backlog-triple.py:72` | `EDGE_EXTRA_DIRS = ["jobs/tada"]` | recurse the subtree (Python `os.walk`) | noisy |

The **five flagged-dangerous** consumers named in the job spec —
`post-job.sh` idempotency, `orchestrate.sh` child-completion,
`follow-up.sh` report scanning, `unblock.sh`, `gauntlet.sh` — all route through
`tada_find`/`tada_find_tree`/`tada_exists`, so the drop-vs-re-mint invariant is
enforced in *one* helper and audited once, not five times.

Two subtleties inside the dangerous set:

- **`orchestrate.sh` atomicity is preserved.** `child_board_view_once` reads
  four candidate paths from one immutable snapshot so a hard reset cannot be
  observed mid-checkout. Keep that: probe todo/doin/plan by exact path against
  `$snapshot` *and* resolve the tada arm with `tada_find_tree "$dir" "$snapshot"`
  — same commit, so the read stays atomic. The `count != 1 → retry` guard is
  unchanged.
- **`follow-up.sh` already recurses** (`find … -type f`), so it tolerates shards
  today — but line 156 derives `base` as `${rel#jobs/tada/}`, which under
  sharding yields `2026/08/13/base`. Fix to `base="$(basename "$f" .md)"`. And
  its seen-marker is keyed by rel-path (§ 5) — the migration re-keys every path.

## 4. Rolling-deploy safety — readers tolerate both, then writers switch

The fleet is leader + followers, each advanced independently by
`deploy-garden.sh`. During any rollout window, old-code hosts write **flat**
paths while new-code hosts would write **sharded**. A reader on either code
version must never miss an entry written by the other. The transition ordering,
confirmed:

**Stage A — readers tolerate both, writers stay flat.** Ship `tada_find` /
`tada_find_tree` / `tada_exists` (flat-first, then sharded) and convert every
reader call site to them. Writers still emit flat paths. Deploy to **every
host.** No tree changes shape yet, so this is a pure no-op refactor — safe to
roll out at any pace, and it makes the whole fleet tolerant *before* a single
sharded path exists. Crucially the **leader** (which alone runs `orchestrate.sh`
/ `gauntlet.sh`) is tolerant before stage B.

- *Old-code host during stage A:* only exists if a host lags the stage-A deploy.
  It reads and writes flat, exactly as today. Since nothing sharded exists yet,
  it misses nothing.

**Stage B — writers switch to sharded.** Flip the completion writers
(`complete-job.sh`, `ci-watcher.sh`, `orchestrate.sh`, `gauntlet.sh`) to
`tada_write_path`. Deploy to every host. New completions land sharded; the
still-present flat backlog is read via the flat-first arm of the helpers.

- *Old-code (stage-A) host during stage B:* writes a **flat** path for its
  completions. Stage-B readers find it (flat arm). Its own readers use the exact
  flat probe — so it cannot see a *sharded* entry another host wrote. The only
  sharded-writing readers that matter are the **leader-only** orchestrate/
  gauntlet; because the leader is on stage A (tolerant) by the § 4 ordering and
  is the *only* host that reads child-completion, no old follower ever needs to
  read a sharded entry. Follower readers (watchers are leader-only too;
  post-job/unblock/promote run on followers but only ever dedup *their own*
  base, which they also completed under the same code) are safe.
- **This is why the ordering is A-before-B, not the reverse:** a writer-first
  rollout would let a new follower write a sharded child completion that the
  not-yet-tolerant leader reads as `gone` and halts a serial campaign on.

**Stage C — migrate the flat backlog (§ 5).** One CAS push moves all remaining
flat entries into shards. Requires stage B fully rolled out (no host still
writing flat), so the backlog is a closed set.

**Stage D — drop the flat fallback.** Remove the flat-first arm from the
helpers, and fix the last two count/recent call sites (`bulletin`, `cost`) to
recurse. Deploy at leisure. Purely cosmetic once the tree has no flat entries;
a lagging host is harmless because there is nothing flat left to miss.

## 5. Migration atomicity

**One commit, one CAS push, all entries.** The migration enumerates every
`jobs/tada/<base>.md` at the flat level, computes each one's shard from its add
commit (§ 2), `git mv`s each into `jobs/tada/<yyyy>/<mm>/<dd>/`, and commits the
whole set as a single commit pushed under the standard rebase-CAS loop (the same
loop `complete-job.sh` uses). Because the move is one commit, any reader
resolving *any* ref sees the tree either fully flat or fully sharded — never a
half-migrated mix. 4,521 renames in one tree object is trivial for git.

**Interaction with concurrent claims and completions.**

- A **claim** touches `jobs/todo → jobs/doin`; a **completion** *adds* a new
  sharded `jobs/tada/<today>/…` path. Neither touches the flat entries the
  migration is moving, so on the git index they do not conflict — a concurrent
  completion just lands next to the migration in the rebase-CAS. If the
  migration loses the race, it re-syncs and re-runs (idempotent: an
  already-sharded entry is skipped), exactly like `complete-job.sh`'s retry loop.
- A base cannot be simultaneously *in doin* (running) and *in flat tada* (the
  migration's input set), so there is no case where migration moves the very
  report a running job is about to overwrite.

**No fleet drain required.** The migration is a retrying, idempotent CAS, and by
stage C every host writes sharded — so no new flat entry appears mid-migration
(and if a straggler did, the migration's idempotent re-run sweeps it). Run it as
a one-shot job that repeats until zero flat entries remain, then records
completion. A drain would only be needed if the migration were *not* atomic; it
is, so the fleet keeps working through it.

**One host-local side effect to repair: `follow-up.sh`'s seen-marker.** It lives
in `$GARDEN_STATE` (host-local, not the journal) and is keyed by tada **rel
path**. Migration changes every rel path, so an unpatched `follow-up.sh` would
treat all 4,521 migrated reports as *new* and could emit a follow-up storm. Two
mitigations, both cheap: (a) `follow-up.sh` keys the seen-marker on **base**
(`basename`) rather than rel path — stable across the move; and/or (b) the stage
that lands the migration also rewrites each host's seen-marker paths flat→sharded
(a deterministic `sed` the sysop can run per host). Recommend **(a)** as the
durable fix — it removes the coupling entirely — with (b) as belt-and-suspenders
for the migration window. This is called out because it is the one place the
migration reaches *outside* the journal.

## Implementation stages (ordering)

Land on `main2` in this order; each stage is a deploy checkpoint.

1. **Helpers + reader tolerance (deploy to all hosts).** Add `tada_write_path`,
   `tada_path_for`, `tada_find`, `tada_find_tree`, `tada_exists`, `tada_recent`
   to `common.sh` (flat-first, sharded-tolerant). Convert every **reader** call
   site (the dangerous five + the noisy guards + watchers) to helpers. Fix
   `follow-up.sh` base extraction and re-key its seen-marker on base. Writers
   unchanged (still flat). Ship with tests: a `tada_find` that returns the flat
   path, the sharded path, and `undated/`; a `post-job` idempotency test proving
   absent→re-mint; an `orchestrate` child-view test proving a sharded tada child
   reads `tada`, not `gone`. **No tree change** — pure no-op refactor.
2. **Writers switch (deploy to all hosts).** Flip `complete-job.sh`,
   `ci-watcher.sh`, `orchestrate.sh`, `gauntlet.sh` to `tada_write_path`. New
   completions shard; backlog still flat and read via fallback.
3. **Migrate (one CAS job).** Run the migration script: date each flat entry by
   its add commit, `git mv` all into shards (unrecoverable → `undated/`), one
   commit, CAS push, repeat-until-empty. No drain.
4. **Drop the fallback (deploy at leisure).** Remove the flat arm from the
   helpers; recurse the last `bulletin`/`cost` counters; remove the seen-marker
   belt-and-suspenders. Cosmetic cleanup.

## Consumers that need changing

Authoritative list (regenerate with `grep -rln -E 'JOBS_TADA|jobs/tada'
scripts/`): `common.sh` (helpers + `job_in_lifecycle` /
`journal_identity_owner_live`), `post-job.sh`, `complete-job.sh`,
`orchestrate.sh`, `gauntlet.sh`, `post-gauntlet.sh`, `post-orchestration.sh`,
`follow-up.sh`, `unblock.sh`, `promote-plan.sh`, `post-plan.sh`, `annotate-plan.sh`,
`scheduler.sh`, `ci-watcher.sh`, `pages-watcher.sh`, `dependabot-watcher.sh`,
`comment-watcher.sh`, `mention-watcher.sh`, `approval-reconciler.sh`,
`library-source-drift-scan.sh`, `bulletin.sh`, `cost.sh`, `reputation.sh`,
`usage-meter.sh`, `cnf-backlog-triple.py`, plus the `test/` suite. The
**dangerous** subset — `post-job.sh` idempotency, `orchestrate.sh`
child-completion detection, `follow-up.sh` report scanning, `unblock.sh`,
`gauntlet.sh` — is where a subtle break drops or double-runs work, and is the
reason the drop-vs-re-mint invariant lives in one audited helper.
