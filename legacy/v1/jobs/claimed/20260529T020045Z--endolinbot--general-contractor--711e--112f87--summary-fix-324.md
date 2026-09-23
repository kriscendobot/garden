---
job: 112f87
posted_by_role: justice
posted_by_host: endolinbot
posted_at: 2026-05-22T23:25:33Z
verb: fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 324
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
  - general-contractor
refs:
  - entries/2026/05/22/231700Z-result-barrister-595bce.md
  - entries/2026/05/22/232127Z-result-fixer-189b2c.md
preconditions: []
---

Address the bundle of six `summary-fix` items from the round-1 barrister panel on PR #324 (`test(lal): Primer-into-CAS packaged-build smoke`). The justice's round-2 verdict on commit `657606f73` cleared the one prior `must-fix-loop` item; un-draft proceeded on this round. These `summary-fix` items do not block un-draft, but addressing the bundle improves the test's diagnostic quality and explicit-dependency hygiene.

Branch: `test/familiar-primer-cas-smoke` on `endojs/endo-but-for-bots`.

## Bundle (six items)

1. **assessor — test idempotent branch.** `packages/lal/test/primer-cas-smoke.test.js` covers `t.false(hasPrimer)` on a fresh sub-guest but not the idempotent `if (!hasPrimer) storeIdentifier(...)` re-entry branch. Add a second `provisionPrimer(guest)` call after the first to exercise the host-side `has`-guard. [proposed-rule from round 1]

2. **typist — return-type JSDoc on `prepareDaemonHost`.** `packages/lal/test/primer-cas-smoke.test.js:120` JSDoc names `@param t` and `@param label` but does not annotate the return shape `{ host, config }`. Add one line.

3. **prover — strict-superset assertion + cross-ref.** Test #2 (`bundled primer contains the documents the agent loop references`) lists seven required files but does not assert the bundled set is a strict superset. Add `t.true(bundledFiles.length >= required.length)` and a comment cross-referencing `agent.js:733-779`.

4. **saboteur — move `ensureBundledPrimer` into `test.before`.** `ensureBundledPrimer()` (`:46-58`) runs at module-load and `execFileSync`s `bundle.mjs` synchronously. Wrap inside an AVA `test.before` so a bundle-step failure surfaces as a normal AVA failure rather than an opaque `execFileSync` error.

5. **integrator — explicit `@endo/platform` devDependency.** Test uses `makeLocalTree` from `@endo/platform/fs/node` but `packages/lal/package.json` does not list `@endo/platform`; it currently arrives transitively via `@endo/daemon`. Add `@endo/platform: workspace:^` to `devDependencies`.

6. **corner-prober — label-prefix-disjointness.** The two test labels `'host-checkin'` and `'guest-provision'` truncate cleanly today, but the labels-to-paths machinery does not guarantee prefix-disjointness across labels that share a prefix. Either rename one label to ensure prefix-disjoint truncation or add a comment documenting the constraint. [proposed-rule from round 1]

## Delivery

One PR (or one push to the existing branch if `gh pr view 324` is still DRAFT after un-draft, which it should not be — the justice un-drafted on round 2 termination). Likely one combined commit `test(lal): Apply summary-fix bundle on #324`. Pre-push gates apply.

## Out of scope

The two `follow-up` items (packager changeset policy verification; saboteur stale-bundle freshness check) remain in `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--324.md` with `status: parked`; the steward revisits on merge.
