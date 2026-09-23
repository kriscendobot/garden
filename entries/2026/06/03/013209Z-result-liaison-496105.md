---
ts: 2026-06-03T01:32:09Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/03/011729Z-dispatch-liaison-496105.md
  - entries/2026/06/03/012906Z-result-weaver-496105.md
---

# result: bot-master + bots/llm synced to upstream (#3294 fix propagated); per-PR rebase wave pending

User asked: "weave actual/master into bots/llm and rebase the
affected PRs." Step 1 complete; step 2 (per-PR rebases) needs
scoping decision.

## Step 1 outcome (weaver `496105`)

- **bot-master** force-pushed to mirror `endojs/endo:master`
  at `ba26f4cdb` (carries the merged #3294).
- **bots/llm** woven at `720a39600` (merge commit; parents
  `c85d618df` + `ba26f4cdb`). The weaver used `git merge --no-ff`
  instead of a 1072-commit rebase, following prior weaver
  precedent (`b381e6ada` from 2026-05-21). Maintainer can
  override on the next sync if rebase form is preferred.
- **12 file conflicts** resolved per documented rules. Highlights:
  benchmark-area files took master's canonical `.engines/` form;
  ci.yml kept llm's two added jobs; root package.json kept llm's
  curated devDeps + folded in master's `ts-node-pack` for new
  release scripts; yarn.lock regenerated via `yarn install
  --mode=update-lockfile`.

## Affected-PR map (per weaver's scan)

### Steward-queue PRs

- **#387** ferry mirror — SUPERSEDED by upstream #3294 merge.
  Close as merged-via-upstream (and any cross-link tidying).
- **#388–#394** gateway stack — cascade-rebase via `#343`'s
  foundation move from `llm-b1c3f4d` → `llm-720a396`. Phase
  order: #343 → #388 → #389 → #392 → #393 → #394 (and #389 in
  the chain depending on its base).
- **#401** — needs new frozen base `master-ba26f4c` + rebase.
- **#403** — needs new frozen base `llm-720a396` + rebase.

### Other frozen-base PRs (per weaver's scan)

- **#79, #242, #311, #320, #356, #357, #359, #360** — frozen-
  base PRs needing rebase.
- **#377** — superseded benchmark mirror like #387; close.
- **#405** — contractor's recently-opened inventory-grouping
  PR; check its base.

### PRs on bare `llm` / `master` (not frozen bases)

- 91 PRs on bare `llm`: base recomputed automatically. Per-PR
  rebase only needed if they touch the conflicting files
  (benchmark area, root package.json, root yarn.lock, ci.yml,
  the four sub-package package.json files). Otherwise CI
  re-triggers will pick up the new base.
- 34 PRs on bare `master`: same.

## Step 2 scoping decision needed

The full second-wave scope is 11+ explicit per-PR rebases (the
steward queue + the other frozen-base list), plus close-as-
superseded for #387 and #377.

Three reasonable approaches:

1. **Prioritized batch** (recommended): dispatch the steward-
   queue rebases now (the gateway stack via #343, #401, #403),
   plus close #387 / #377. Defer the other frozen-base PRs
   (#79, #242, #311, #320, #356, #357, #359, #360, #405) to a
   second batch.

2. **All at once**: dispatch every per-PR rebase in parallel
   (16+ background weavers). Maximally fast but high
   concurrency on the same repo's branches.

3. **Wait for user direction**: pause; let the maintainer
   confirm which subset.

The liaison defers the choice to the user. Reasonable default
absent user input: approach 1, since the steward-queue PRs
have the most active maintainer engagement.

## Standing follow-ups for the steward

- Close #387 and #377 as superseded-by-upstream-merge.
- Foundation rebase #343 before the gateway stack cascade.
- Per-PR rebases for the rest.
- Garden-meta gardener dispatches (style guide positive
  examples; grep-gate skill § Notes addition) — still pending
  from earlier.

## Teardown

`dispatches/weaver--496105` torn down.
