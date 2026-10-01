# Gauntlet fix round 1 — endojs/endo-but-for-bots#1340

The panel's must-fix items in the design doc are fixed and pushed as `07768c3d4`, and CI is green (28 of 28 checks, `ci-wait-merge` rc 0). The PR body could not be updated from this host, so that one item is handed to a successor job.

**What changed in `designs/agent-confined-application-makers.md`** (one follow-up commit on top of `f871ea673`, pushed with `safe-push-pr-head.sh`):
- **`canonical` and duplicate compartments (critic 1):** `canonical` is no longer the identity. For a mount it now uses the mount's confined physical path, so a package reached through two `node_modules` paths loads as one compartment. A snapshot has no links, so the identity is still correct there.
- **pnpm rationale (critic 2, skeptic 1):** I checked `packages/daemon/src/mount.js`. The mount follows links that stay inside its root and refuses ones that leave it. So pnpm's `.pnpm` store would not escape; workspace links (`workspace:`/`link:`) and the global virtual store do. The maintainer's hoisted-only rule stays, with this corrected reason in the text and in Design Decision 4.
- **Torn capture (skeptic 2):** the doc now says that capture from a mount being written to can be torn and is not detected, and points to a snapshot as the fix. It also shows what follows when files are missing.
- **Entry resolution (skeptic 3):** `exports["."]` is resolved through compartment-mapper, so a string or a conditions object both work (`import`/`default`), falling back to `main`. An explicit `entry` option bypasses it.
- **Naming and errors (ergonomist):**
  - The parameter is now `workerPetName`, matching `EndoHost`.
  - The layouts are renamed `node-modules-with-map` and `node-modules-scan`.
  - A tree that matches no layout now gets a defined rejection.
  - The doc notes that MCP requires `resultName` while the native methods keep it optional.
- **Headings (pedant):** the two Title Case headings are now sentence case.
- **Should-fix and comment items:**
  - Explained why `stageTree` is not reused (critic 3).
  - Expanded CAS and defined "endor" and "capture"; added a lead-in to the table; dropped the "lane" metaphor (novice).
  - The formula now records whether its tree is a snapshot or a mount, and the doc says a tree incarnation writes no new formula record (decomplector).
- **Consistency:** the test plan no longer contradicts itself (hoisted pnpm, a deduplication test, a conditions-export test, a test for a link out of the root), and Decision 1 no longer claims fixed bytes for trees.

**PR body (pre-pass and integrator must-fix):** I rewrote the body to follow the template's seven sections and describe the current state, with no open questions and the bundle/precompiled split. `gh pr edit` failed with 403 (`updatePullRequest`): this host's token cannot write endojs PRs. I posted successor job **`endojs-endo-but-for-bots-pr1340-body-refresh-20261001`**, pinned to `endolin-garden-ece02cb4`, with the full body embedded and the single task of applying it.

**Follow-ups:**
- If the successor hasn't run before panel-2, panel-2's template pre-pass will flag the body again.
- `post-job.sh` gave the successor the identity `#1336:comment:4098195295`, taken from a URL in its body. That matches the original design directive, so it may need watching for identity collisions.
- I could not drain my inbox: the journal clone timed out (rc 75), the host-slowness problem already in memory.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1340-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (1969769 cached reads)
- Output: 17836 tokens
- Cost: $1.4133858000000001
- Wall-clock: 1660s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
