# build: implement plan-in-journal — Phase 0 (schema, validator, reconciler, one-time import)

Map: **build** → garden-infra implementation of an approved design.

## Origin

Maintainer kriskowal approved design `plan-in-journal` on
[kriskowal/garden#4 review](https://github.com/kriskowal/garden/pull/4#pullrequestreview-4573611899):
"Looks good to me. We do not need to merge this PR, but post a job to implement
the plan. This may require pausing the garden while the journal gets
reorganized. Please do." PR #4 stays **open and unmerged** (it is a reviewable
design-only PR; the design itself is the spec, not the thing to merge). This job
is the kickoff of implementation.

## The design (read first)

Full spec on branch `design/plan-in-journal`:
`git show origin/design/plan-in-journal:designs/plan-in-journal.md`. It moves the
roadmap/plan (milestones, design index, statuses, estimates, dependency edges,
target dates) **and** each design's narrative out of `endojs/endo-but-for-bots:llm`
`designs/README.md` and **into garden `journal2` state** under a new
`journal/plan/` tree, re-architects it to span multiple repositories, and
replaces the hand-enforced README-sync discipline with reconciliation folded into
the existing **bulletin** + **journalist** loops. `agoric-sdk` is excluded
unconditionally (validator rejects it). The design's "Open questions" are all
resolved — it is settled and ready to build.

## Scope of THIS job — Phase 0 only

Per the design's Migration path, land Phase 0 and stop. Do **not** attempt the
whole 5-phase migration in one job. Phase 0 deliverables:

1. **`journal/plan/` schema** on `journal2`:
   - `journal/plan/repositories.md` — repository-slug → repository-URL mapping
     (URLs, not GitHub `owner/name`, so non-GitHub forges stay representable).
     Seed with `garden`, `endo`, `endo-but-for-bots`. Never `agoric-sdk`.
   - `journal/plan/designs/<repository-slug>/<design-slug>.md` — one record per
     design: frontmatter (`slug`, `repository`, `status`, `size`, `milestone`,
     `depends_on`, `pr`, `target`, `created`, `updated`) + the design **narrative**
     in the body. This file is the source of truth.
   - `journal/plan/milestones/<id>.md` — milestone definition (exit criteria,
     target date, members).
   - `journal/plan/velocity.md` — velocity inputs + S/M/L/XL day-mapping.
   - `journal/plan/README.md` — GENERATED aggregate roadmap view (table + Mermaid
     dep graph + estimate rollups). Header must mark it generated / do-not-edit.
2. **Plan validator** (a pre-push gate; reuse `skills/pre-push-gates`):
   validates each record's frontmatter against the schema, rejects missing/unknown
   fields and unknown status enum values, enforces **slug uniqueness across all
   records**, and **rejects any record whose `repository` resolves to agoric-sdk**.
   Status enum carried verbatim from v1: Not Started, Proposed, In Progress, Draft,
   Complete (Implemented), Active, Reference, Deprecated, Superseded.
3. **Reconciler step folded into the bulletin loop** (`scripts/jobs/bulletin.sh`):
   regenerate `journal/plan/README.md` from the records on every pass when the plan
   changed — durable cursor, change-gated CAS push, multi-host idempotent, exactly
   like the rest of that loop. **No new standalone `garden-roadmap-renderer`
   service** (the design forbids it). Aggregate over the union of records: milestone
   totals, completion %, estimate rollups, and a cross-repository critical path that
   follows `depends_on` across repo boundaries. A dependency cycle / dangling edge
   surfaces as a maintainer note, not a silent bad graph.
4. **One-time shadow import.** Read the current
   `endojs/endo-but-for-bots:llm` `designs/README.md` table (status enum, six
   milestones M0–M6, the Mermaid graph, the S/M/L/XL estimate table) into per-design
   records, and pull each design's narrative from its fork `designs/` file into the
   record body. Diff the generated `journal/plan/README.md` against the live endo
   table for fidelity. Plan stays a **shadow** (endo file remains the live source)
   until the generated view renders faithfully — that fidelity bar is the Phase 0
   exit criterion. Do NOT flip the source of truth (that is Phase 1).

## ⚠ Garden-pause precondition for the import (maintainer pre-authorized)

The one-time import bulk-writes ~104 records into `journal2`, which the gardener
fleet (~100 workers) and the journal-mutating daemons (bulletin, journalist,
foreman, triagers, watchman) race on continuously. A bulk import interleaved with
that traffic will lose pushes repeatedly and can interleave a half-written tree.
The maintainer explicitly anticipated this ("This may require pausing the garden
while the journal gets reorganized. Please do.") — that **"Please do" pre-authorizes
the pause**. So, for the import step only:

1. Quiesce the fleet + journal daemons (e.g. `set-gardeners.sh 0 <host>` and
   stop/pause the journal-writing units; confirm the approach against
   `scripts/jobs/install-units.sh` and the gardener-scaler before acting).
2. Perform the import as one atomic, fast-forward push to `origin/journal2`.
3. Resume (restore the prior gardener count; restart the units).

If the operationally-correct pause turns out to be broader or more disruptive than
stopping the fleet + journal units (e.g. it would drop in-flight claims you can't
cleanly requeue via `reaper.sh`), **stop and message the maintainer via the
liaison before proceeding** rather than improvising a destructive reorg.

## Process norms

- Garden infra work: scripts land on `main2`, plan state lands on `journal2`. **No
  PR against the garden's own repo** (CLAUDE.md § Conventions); push directly.
- Build script changes in an **isolated worktree off `origin/main2`** — the shared
  `/home/kris` tree is concurrently mutated; `git worktree add` off the clean base,
  re-apply any shared-file hunks, commit explicit pathspecs, push `HEAD:main2`.
  Never `git reset --hard` (it deletes already-added new files).
- Run the available evaluation / `bash -n` / shellcheck gates before pushing.

## Definition of done (this job)

`journal/plan/` schema + validator + bulletin reconciler step are landed; the
one-time import has run under a paused garden; the generated
`journal/plan/README.md` diffs faithfully against the live endo table (shadow
fidelity proven); the endo file is still the live source (no Phase-1 flip).
**Then post follow-up jobs** for Phase 1 (flip source of truth; endo README → a
generated, non-authoritative, indefinitely-kept redirect), Phase 2 (cut over
bulletin → journalist → foreman → design-poller, one commit each, in that risk
order), Phase 3 (cross-repo activation: garden + endo records, spanning
milestones, critical path, confirm agoric-sdk exclusion), and Phase 4 (retire the
endo `designs/CLAUDE.md` manual-sync discipline). Reference this design and PR #4
in each follow-up.


---
claim:
  host: endolinbot
  gardener: 57
  claimed_at: 2026-06-25T20:35:41Z
