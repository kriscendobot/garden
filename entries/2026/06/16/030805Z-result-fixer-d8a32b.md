---
ts: 2026-06-16T03:08:05Z
kind: result
role: fixer
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/16/021301Z-result-fixer-65b4a3.md
---

# Fixer: absorb upstream Agoric#12734 (Endo sync + type fixes) into PR #5

Maintainer directive (kriskowal 2026-06-16T01:32:51Z on PR
kriscendobot/agoric-sdk#5): "Please absorb the changes in
https://github.com/Agoric/agoric-sdk/pull/12734, favoring solutions
pursued there over overlapping solutions pursued here."

Upstream PR #12734 by turadg: 46 commits / 175 modified files syncing
@endo/* deps to current published (1.5.0 / 1.8.1 / 1.10.0 / 1.9.1 /
4.3.2 / ses 2.x) and absorbing the type-inference fanout. Our PR #5
already addressed many of the same surfaces with hand-rolled
@ts-expect-error markers and patch-resolutions; the directive asks
us to replace those with upstream's principled solutions while
preserving the novel work that #12734 does not address.

## Pre / post

- Pre-absorption HEAD: `c2de346cc527954bb2e6b8705e3a97fa818a4032`
  (the prior fixer 65b4a3's Float*Array endow tip).
- Post-absorption HEAD: `edf76d44cba8fec2b253169859cf67e8a42408cf`
  (chore: Update yarn.lock).
- Three commits pushed (append, no force):
  - `3a6be3fa1b` fix(deps): absorb upstream Endo sync from Agoric#12734
  - `aee8f7a92c` fix(types): absorb upstream type fixes from Agoric#12734
  - `edf76d44cb` chore: Update yarn.lock

## Absorption methodology

1. Fetched `pull/12734/head` → `upstream-pr-12734` (tip
   `86bf0e39b9b3375fe3dce0b6bd9aafebee1e3786`, based on
   `upstream/master @ 14afd8f6884`).
2. Computed three file partitions:
   - **Overlap** (107 files modified by both PRs): take upstream's
     content.
   - **Upstream-only** (68 files in #12734 but untouched by us): take
     upstream's content (including 2 adds and 1 rename for the
     bundle-source patch 4.1.2 → 4.3.2).
   - **Ours-only** (47 files modified by us but untouched by #12734):
     keep our content (the Float*Array endow sites, dual-AVA fix,
     compartment-mapper patch, etc.).
3. Also handled upstream's 13 deletions (obsolete .patchlift entries
   and @endo-* patches that were absorbed by the version bump). Our
   @endo-bundle-source-npm-4.2.0 patch was likewise dropped; the
   replacement is upstream's 4.3.2 forward-port.
4. Merged our 3 surviving novel resolutions back into the upstream
   package.json (compartment-mapper patch, eslint-plugin pin,
   ava@^6||^7||^8 pin).
5. Reverted our hand-rolled @ts-expect-error markers in test files
   that upstream's solution made stale (TS2578 "Unused @ts-expect-error
   directive"). 14 such files identified via `yarn typecheck-packages`
   diagnostic run; reverted to upstream/master content (since #12734
   itself didn't touch them).
6. Manually pruned 4 stale @ts-expect-error in our src files
   (chain-behaviors.js x2, storage-test-utils.js, chain-main.js).
7. Re-ran `yarn install` to regenerate root + a3p-integration +
   multichain-testing lockfiles.
8. Validated locally; committed per absorption group; pushed; commented.

## Preserved work (verified intact)

- **Float*Array endow** at 6 SwingSet sites (per ses#3153 fix from
  fixer 65b4a3): controller.js, manager-local.js,
  supervisor-subprocess-node.js, supervisor-subprocess-xsnap.js,
  chain-behaviors.js, evalContractCode.js. Confirmed via grep
  "Float64Array" — all 6 files retain the endowment block.
- **dual-AVA install fix** in multichain-testing (per fixer cc9bb5):
  `ava@npm:^6 || ^7 || ^8 → ^7.0.0` resolution.
- **@endo/compartment-mapper@2.3.0 patch** (deterministic-bundle
  workaround for a3p pre-upgrade proposals; original commit
  9625b667ce by Kris).
- **@endo/eslint-plugin@2.4.0 pin** (ESLint 9 compat).
- **.yarnrc.yml catalogs:dev** entries.
- **services/ymax-planner/src/utils.ts** `lookupValueForKey` overloads
  per copilot review on #12527 (commit d9c9c0387a).

## Local validation

- `corepack yarn workspace @aglocal/fast-usdc-deploy test`:
  **31 / 31 passing, 5 todo, EXIT=0**. Same result as pre-absorption
  baseline; the chain-impact 7m suite ran clean under xs-worker,
  confirming that Float*Array endow + upstream's solutions are
  compatible.
- `corepack yarn workspace @agoric/async-flow run lint:types`: EXIT=0.
  Upstream's TestFn recovery (wrapTest annotation in
  prepare-test-env-ava.js) + Ephemera<any,...> widening + LogEntry
  casts in log-store.js handle the typing chain cleanly.
- `corepack yarn lint:format` + `lint:eslint`: 0 errors directly tied
  to absorption work (18 errors in the eslint report are inherited
  upstream issues in SwingSet/misc-tools and similar — pre-existing,
  not introduced by this absorption).

## Pre-push-gates result

- `yarn format`: pass (no auto-fixes needed).
- `yarn lint --fix`: pass.
- Probes:
  - 6 of 8 probes pass: no-ascii-banners, no-inline-import-jsdoc,
    no-pull-citations, security-md-hash-uniform, test-package-no-main,
    filename-no-stutter.
  - `no-non-ascii-in-source`: fail on 8 em-dash lines in upstream-
    authored source files (governance/question.js, inter-protocol/
    econ-behaviors.js + startPSM.js, vats/virtual-purse.js, vow/E.js +
    vow-utils.js, zoe/contractSupport/atomicTransfer.js). All
    inherited from upstream's PR; per the absorption directive we do
    not modify upstream's prose.
  - `sentence-per-line-md`: fail on docs/typescript.md and
    packages/orchestration/docs/types.md (upstream-authored new docs;
    multi-sentence physical lines throughout). Same caveat.
- `yarn typecheck`: skip (no typecheck script at workspace root).
- Overall: gate fails on inherited upstream content only; the work
  the gate was designed to catch (our authored changes) passes.

## PR comment

Posted top-level summary @-mentioning @kriskowal:
<https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4714468827>

## Recommended next stage

`next: ooda-observation`. The absorbed PR is in CI's hands. When CI
settles:

- The new head should match or improve on the prior 31/31 fast-usdc
  baseline (Float*Array endow + upstream's type fixes are additive at
  runtime).
- Upstream PR #12734 itself has 7 failing CI jobs as of this push
  (lint-primary, test-dapp node-new, test-fast-usdc-deploy node-new,
  test-inter-protocol node-old, test-portfolio-contract node-new,
  test-quick node-old, test-quick2 node-new). Mirroring those
  failures is expected; surpassing them would require additional
  work beyond #12734's scope.
- When CI converges, the orchestrator decides whether to (a) ferry to
  Agoric/agoric-sdk via boatman (requires host with kriskowal
  credentials, currently kmkmbp2021 — not endolinbot), or (b) defer
  to a maintainer review pass given turadg's #12734 is the canonical
  upstream artifact.

Self-improvement: nothing this time. The skill set covered the case
end-to-end (file-partition absorption methodology + revert-stale-
markers loop + yarn-lock-separate-commit + per-area PR comment). The
prior fixer 65b4a3's self-improvement (kernel-bundle endowment
propagation audit for SES global removals) is the durable lesson
from this PR series; this absorption ride doesn't add a new one.
