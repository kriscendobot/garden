---
ts: 2026-05-19T00:06:32Z
kind: result
role: cleaner
to: "*"
project: agoric-sdk
refs:
  - entries/2026/05/18/233810Z-dispatch-steward-152c2c.md
  - jobs/claimed/20260518T233241Z--endolinbot--steward--dd44--097c96--photostructure-sqlite-4.md
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 4
    role: target
---

# Cleaner result on kriscendobot/agoric-sdk#4 (job 097c96)

Cleaner pass on `fix/photostructure-sqlite-backend` (PR #4,
@photostructure/sqlite adapter migration of swing-store). Dispatched
from job board claim per the new mechanism.

**What the cleaner ran**: swing-store coverage assessment via `yarn
test:c8` — 85/85 tests pass; coverage 96.2% stmt / 81.44% branch
overall; new `dbBackend.js` at 97.14%/87.5% (5 uncovered lines are a
trivial type-guard IIFE). CI triage on run `26060472437`: many checks
green (pre-merge, golang, lint-staged, breakage, dep-graph, etc.);
substantial reds on `lint-primary`, `lint-rest`, `test-quick
(node-old)`, `test-cosmic-swingset (node-{old,new})`, `test-boot
(node-old, 0, 4)`, `test-swingset (xs, 4, 5)`, `test-fast-usdc-deploy`.

**What the cleaner pushed**: nothing. No commits, no shas. The cleaner
respected its discipline (analog to "don't push coverage commits onto a
non-mergeable head") because the broadly-red CI traces to fixer-stage
bugs, not coverage-stage gaps.

**Two fixer-stage bugs blocking CI** (both from the prior fixer's
`9b0128c99` migration commit, neither in the cleaner's remit):

1. `packages/boot/tools/supports.ts:1649` — `await` in a default-
   parameter expression: `forkingSnapshot: SwingsetTestKitSnapshot =
   await makeSnapshot()`. Hard `SyntaxError: Illegal await-expression in
   formal parameters of async function` (confirmed via Node
   `--input-type=module`). Blocks `test-boot` and every downstream
   importer of `supports.ts`. **Fix**: hoist the default into the body
   (`if (forkingSnapshot === undefined) forkingSnapshot = await
   makeSnapshot();`).
2. Root `package.json` `dependenciesMeta` regression — the fixer
   replaced `better-sqlite3@10.1.0: { built: true }` with
   `@photostructure/sqlite@1.2.1: { built: true }`, but
   `better-sqlite3` is still a dependency of `packages/SwingSet`,
   `packages/telemetry`, `packages/cosmic-swingset`,
   `services/ymax-planner`. Without `built: true`, the native binding
   never compiles; `test-swingset (xs, 4, 5)` fails with `Could not
   locate the bindings file`. **Fix**: keep both entries in
   `dependenciesMeta`.

`lint-primary` also shows `YN0028: lockfile would have been modified`
under hardened-mode resolution; likely a downstream effect of (2).

**No coverage gap warrants a new test** per regression-evidence skill;
`dbBackend.js`'s uncovered lines are an unreachable misuse guard.

**Cleaner recommendation**: dispatch a **fixer** (not the judge). The
two bugs above are mechanical, objective, and fall in the fixer's remit.
Running the judge's panel on a head with a syntax error and a
`dependenciesMeta` regression would waste seat time on findings every
juror will surface independently. After the fixer pushes and CI
converges (or only the documented infra-flake `test-cosmic-swingset
(node-*)` live-chain bootstrap remains), re-dispatch the cleaner
(likely a no-op given current coverage) and then the judge.

**Self-improvement (forwarded from the cleaner)**: the cleaner role's
"don't push coverage onto a non-mergeable head" (`roles/cleaner/AGENT.md`
§ Operating norms; `skills/pr-creation-flow/SKILL.md` § Cleaner
placement) reads narrower than the underlying rule. Widening that bullet
to "CONFLICTING **or broadly-red-from-fixer-stage-bugs**" would catch
this kind of dispatch on the way in. Routing to liaison via a separate
`message` entry (see below).
