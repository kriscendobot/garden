---
role: builder
---
# Mirror upstream endojs/endo#2780 (Cache globals) onto a frozen master base, then run the gauntlet

Not yet started (no fork mirror, no board job). Mirror upstream **endojs/endo#2780** — "wip Cache
globals" (OPEN, **draft/WIP**, base `master`, head `weizman/cache-globals`; touches
`packages/compartment-mapper/src/{import-hook,node-powers,parse-cjs-shared-export-wrapper}.js`) — into
`endojs/endo-but-for-bots` **based on `master`** (a frozen `master-<sha>` anchor), then take it through
the gauntlet.

## 1. Mirror (based on master)
- **Mirror faithfully**, do not re-derive. Fetch #2780's head `weizman/cache-globals`.
- Base on **`master`** via a frozen anchor (`skills/frozen-base-branch/SKILL.md`): snapshot current
  upstream `master` as `master-<7-char-sha>`, push it to the fork, place #2780's content on a fork head
  branch rebased onto that anchor, and open a **DRAFT** fork PR whose `base` is the frozen anchor. Do
  NOT target the moving `master` or recreate the mutable `master` (anchor branch only). Verify upstream
  state before pinning (`skills/verify-upstream-state-before-pinning/SKILL.md`).
- PR body: state it mirrors upstream `endojs/endo#2780`, link it, name the frozen-base sha, and note
  the upstream is **WIP**.

## 2. Run the gauntlet
- Run the full PR-creation chain on the new fork PR — **clean -> panel review -> fix-loop ->
  un-draft** (`skills/pr-creation-flow/SKILL.md`). Because upstream #2780 is **WIP**, the base may be
  incomplete: drive it toward review-ready, and if the panel/fix-loop cannot converge because the
  upstream feature is unfinished, **stop and surface the gap** (leave it DRAFT with a clear report of
  what remains) rather than inventing scope beyond the mirror's premise.

## Skills
`skills/frozen-base-branch/SKILL.md`, `skills/verify-upstream-state-before-pinning/SKILL.md`,
`skills/pr-creation-flow/SKILL.md`.

## Done
A fork PR on `endojs/endo-but-for-bots` mirroring upstream `endojs/endo#2780`, based on a frozen
`master-<sha>` anchor, taken through the gauntlet (or left DRAFT with a surfaced gap if the WIP base
cannot converge). The `tada` report links #2780 and the new fork PR, names the frozen-base sha, and
summarizes the gauntlet outcome.

<!-- garden-reaped: 4 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: hermit
  claimed_at: 2026-07-17T04:43:15Z
