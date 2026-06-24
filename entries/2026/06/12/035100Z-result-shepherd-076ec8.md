---
ts: 2026-06-12T03:51:00Z
kind: result
role: shepherd
host: endolinbot
project: agoric-sdk
repo: kriscendobot/agoric-sdk
dispatch_root: /home/kris/dispatches/shepherd--076ec8
short_id: 076ec8
to: liaison
refs:
  - entries/2026/06/12/034300Z-dispatch-shepherd-076ec8.md
  - entries/2026/06/11/201726Z-result-weaver-0207d5.md
  - entries/2026/06/10/181800Z-result-fixer-d6af77.md
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: mirror
    state: DRAFT
next: liaison
---

# result: shepherd PR kriscendobot/agoric-sdk#5 (076ec8)

## TL;DR

Corroborated the 14 FAILUREs on `c81b03e62`. The 11 substantive ones share one root cause: the cherry-pick of `Agoric/agoric-sdk#12527` downgrades `ava ^7.0.0 → ^6.4.1` in 28 workspaces while root and 22 other workspaces remain at `ava ^7.0.0`, producing two physical `ava` installs that supertap, TypeScript, and AVA's worker-state singleton all stumble on. The maintainer's premise ("this change should not affect the pinned `ava` version") is contradicted by the diff. Escalating `next: liaison` with corroboration comment for the decision on how to proceed; per dispatch brief did NOT re-add the ava-restore commit.

## Phase 1 corroboration

### Failure inventory (14 FAILURE, head `c81b03e622`, run `27374692648`)

11 same-root-cause failures (mixed-ava-major cascade):

- `lint-rest`, `lint-primary` (tsc TS2345 / TS2322 with two distinct ava `AssertAssertion` paths).
- `test-zoe-unit (node-new)`, `test-zoe-swingset (node-new)`, `test-inter-protocol (node-new)`, `test-governance (node-new)`, `test-solo (node-new)` (YAMLException in root-hoisted `supertap` called from workspace-local `ava@6` TapReporter).
- `test-quick (xs)`, `test-quick2 (node-old)`, `test-fast-usdc-deploy (node-old)`, `test-portfolio-contract (node-old)` (`AssertionError [ERR_ASSERTION]: The expression evaluated to a falsy value` — the prior fixer's `runnerChain` signature; worker's `state.cjs` and test's `state.cjs` resolve to different physical files).

2 downstream:

- `dependency-graph` (post-build `git status` rejects misshapen `.d.ts` output produced by `lint-primary`'s ava-type-confused tsc).
- `test-swingset (node-new, 0, 5)` cancelled / failed within ~50s of start; same shape suspected but the truncated log isn't enough to confirm independently (cluster of test-swingset shards were cancelled by sibling test-quick failure short-circuit).

1 pre-existing:

- `test-dapp (node-new)` — documented expected-fail per `MAINTAINERS.md` § Syncing Endo dependency versions. Independent of this issue.

### Match against prior fixer's diagnosis

The prior fixer at `journal/entries/2026/06/10/181800Z-result-fixer-d6af77.md` named the cascade as `refs.runnerChain` falsy at `ava/lib/worker/main.cjs:8` because the worker's `state.cjs` and the test file's transitively-resolved `ava` `state.cjs` resolve to different physical files. **The current failure logs match this signature exactly.** Direct quotes:

- `test-quick (xs)` and the other `*-old` shards: `AssertionError [ERR_ASSERTION] [ERR_ASSERTION]: The expression evaluated to a falsy value`.
- `test-zoe-unit (node-new)` (and the other `*-new` shards): the supertap YAMLException chain originates after AVA's worker fires `refs.runnerChain` falsy and TapReporter tries to serialize a crash-state payload of an unexpected shape.
- `lint-rest`/`lint-primary`: TypeScript's TS2345/TS2322 with two distinct `ava` resolution paths in the error message (`node_modules/ava/types/...` vs `packages/<X>/node_modules/ava/types/...`).

The same root cause spans the unit-test failures (per-workspace AVA workers) and the lint failures (TypeScript's path-based type-identity).

### Ava resolution check

On `c81b03e62`:

- 22 workspaces declare `"ava": "^7.0.0"` (including root `package.json`, and `packages/{boot, agoric-cli, async-flow, cache, client-utils, cosmic-proto, cosmic-swingset, create-dapp, fast-usdc-contract, fast-usdc, import-manager, pegasus, pola-io, portfolio-api, portfolio-deploy, swingset-liveslots, SwingSet, swingset-runner, swing-store, vm-config, access-token}`).
- 28 workspaces declare `"ava": "^6.4.1"` (`packages/{base-zone, builders, casting, deploy-script-support, ERTP, fast-usdc-deploy, governance, internal, inter-protocol, kmarshal, network, notifier, orchestration, portfolio-contract, smart-wallet, solo, spawner, store, swingset-xsnap-supervisor, telemetry, time, vat-data, vats, vow, xsnap-lockdown, xsnap, zoe, zone}`).
- `yarn.lock` holds both `ava@npm:6.4.1` and `ava@npm:^7.0.0` simultaneously.

Per `git diff origin/master-57c6564..c81b03e62 -- 'packages/*/package.json'`, all 28 workspace `^7.0.0 → ^6.4.1` edits trace to commit `218350dda7 chore(deps): update Endo packages and fix type regressions` (3 months old, part of the original `Agoric/agoric-sdk#12527` Endo sync; upstream's `ava 6 → 7` commit `51cb8ec4e0` landed after this PR's author commit, so the cherry-pick carries the pre-bump ava 6 state).

### @endo/ses-ava range fact-check

- The published `@endo/ses-ava@1.4.0` (pinned in this PR via the Endo sync bump from `^1.3.2` to `^1.4.0`) declares `"ava": "^5.3.0 || ^6.1.2"` as a regular **dependency** (not `peerDependency`) in its npm-published manifest.
- The current endo `master` source widens it to `"ava": "^6 || ^7 || ^8"`, but that version is not yet published.
- Because the relationship is `dependency` not `peerDependency`, `ses-ava` would just install its own ava transitively rather than constrain the workspace's choice. The workspace-level mixed-major declaration is what produces the failures, not the `ses-ava` range.

### Hypothesis

The maintainer's premise on the directive comment ("This change should not affect the pinned `ava` version. `ses-ava` allows a wide range of versions") is contradicted by two facts:

1. The cherry-pick **does** change the pinned ava version — 28 workspace `package.json` files have `^7.0.0 → ^6.4.1` deltas in commit `218350dda7`, independent of the `@endo/ses-ava` bump.
2. The published `@endo/ses-ava@1.4.0`'s ava range (`^5.3.0 || ^6.1.2`) does not include ava 7, and is a regular `dependency` not a `peerDependency` (so the range is not directly relevant to the workspace's ava choice anyway).

The CI cascade is therefore the genuine consequence of the mixed-major workspace state. The prior fixer's `runnerChain` diagnosis is correct; the prior fixer's restore commit was the minimum-viable fix.

## Phase 2 actions

Per dispatch brief: "If maintainer-routing escalation (the ses-ava range claim doesn't hold): post a corroboration comment on PR #5 with the evidence and escalate `next: liaison`." That is what I did.

- **Posted corroboration comment** on PR #5: https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4687196485 . Includes per-failure log evidence, ava resolution facts, the commit-attribution trace to `218350dda7`, the `@endo/ses-ava` range fact-check, and three candidate paths (A. re-add restore commit; B. drop just the ava edits from `218350dda7` via interactive rebase; C. publish a wider-range `@endo/ses-ava 1.5.0` upstream first).
- **No commits pushed.** The dispatch brief explicitly forbids re-adding the ava-restore commit autonomously; the corroboration is the deliverable for the maintainer-routing case.
- **No CI re-runs issued.** All 14 FAILUREs are real (not flakes) per the per-job log evidence; re-runs would not converge on green.

## Per-check terminal state

Head `c81b03e62`, run `27374692648`. Same SHA as the dispatch handoff; no shepherd push.

- 28 SUCCESS, 14 FAILURE, 27 CANCELLED (workflow short-circuit cascade from sibling test failures), 14 SKIPPED (Integration tests workflow's conditional skips, etc.).
- FAILURE summary identical to dispatch brief; no change.

## Re-runs issued

None. The failures are not flakes.

## Comment URLs

- Corroboration: https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4687196485
- Directive reply: not posted separately — the corroboration comment is the substantive reply to the directive's `corroborate` ask. The 👀 reactji on the directive (`reactions/369054885`) is already in place from the orchestrator's dispatch handoff.

## Recommended next stage

**`next: liaison`**.

The maintainer's premise (`ses-ava` allows a wide range; this change shouldn't affect pinned ava) is contradicted by the cherry-pick's actual file edits and the published `@endo/ses-ava@1.4.0`'s narrower-than-ava-7 range. The shepherd's `Hard escalation points` rule covers this: "Public-API rewrites or behavior changes that need a design decision" is the closest match, where the decision here is *which of three candidate paths* (re-add restore commit; surgical drop from `218350dda7`; widen `ses-ava` upstream and re-pin) the maintainer prefers. The decision is not in shepherd scope.

The liaison should surface the corroboration comment URL to `kriskowal` and ask which path to pursue. If the answer is path A or B, the next role is `fixer` or `weaver` (commit surgery on a pre-existing branch is fixer or weaver territory depending on whether net-diff stays invariant). If the answer is path C, the next role is `boatman` (upstream `@endo/ses-ava` release) followed by a `weaver` re-pin here.

If the maintainer prefers to accept the red CI state as evidence of the cherry-pick's substance (the framing from the prior weaver's `next: ferry-from-credentialed-host` ) and proceed straight to boatman re-ferry, that is also a valid path — the corroboration documents what would need to happen upstream when CI converges there.

Self-improvement: nothing this time. The dispatch brief's "corroborate-then-act" shape worked exactly as designed: pulled the failed logs, matched against the prior diagnosis, fact-checked the maintainer's premise against the published `@endo/ses-ava@1.4.0` manifest and the cherry-pick's actual diff, then produced a single corroboration comment that names the conflict and three paths. The `@endo/ses-ava` fact-check is the only piece that required reading off-tree (`npm view @endo/ses-ava@1.4.0`); future shepherds doing peer-range corroboration should remember to check both the published version (the constraint that's actually in force) and the unpublished master source (which may explain the maintainer's mental model).
