---
ts: 2026-06-10T15:15:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--d6af77
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4666955938
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4666577263
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/043918Z-result-shepherd-39f4a0.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/041600Z-result-fixer-c39b42.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/033100Z-result-builder-1f1de6.md
---

# dispatch: fixer — investigate and address all PR #5 CI failures (kriskowal: until green or impasse)

Maintainer directive on PR #5 (kriskowal at 2026-06-10T05:46:30Z,
issue comment `4666955938`):

> @kriscendobot Please investigate and address the remaining CI
> failures and continue monitoring CI results until all tests are
> passing. Stop only if you reach an impasse and must escalate.

The 👀 reactji is on the directive comment
(`reactions/368218609`).

This is an **iterate-until-green** dispatch with maintainer
authorization to push as many fix commits as needed. Escalation
back to the liaison is only required at a genuine impasse (e.g.,
a fundamental design conflict, an upstream blocker, a question
where the maintainer's strategic input is essential).

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, base
  `master-daf7a86`, head `mirror/12527-endo-sync-refresh` at
  `cc64691f782122000d3f1405b253cb1df1178363` (`cc64691f78`).
- **CI**: 13 FAILURE / 31 SUCCESS / 0 pending. Failures:
  - `test-dapp (node-new)` — MAINTAINERS-documented
    environment-acknowledge (until a companion
    `agoric/documentation` PR lands). Already documented in the
    PR body. **Do not chase this one** unless evidence shows the
    failure is specifically this PR's.
  - `dependency-graph`, `lint-rest`, `test-quick (xs)`,
    `test-quick2 (node-old)`, `test-fast-usdc-deploy (node-old)`,
    `test-governance (node-new)`, `test-portfolio-contract (node-new)`,
    `test-solo (node-old)`, `test-inter-protocol (node-old)`,
    `test-swingset (node-new, 0, 5)`, `test-zoe-unit (node-new)`,
    `test-zoe-swingset (node-new)` — these are the 12 failures
    to investigate and address.
- **Prior shepherd diagnosis** (39f4a0):
  - Dominant signature: `AssertionError: assert(refs.runnerChain)`
    falsy across SwingSet-bootstrapped tests.
  - Secondary: `YAMLException: ... [object Undefined]` from
    supertap.
  - **NOT present on upstream PR #12527** (the shepherd
    verified). So the regression is **rebase-delta-intrinsic**,
    not Endo-bump-intrinsic.
- **Prior fixer (c39b42) deferral notes**:
  - The full `yarn up ses '@endo/*' -R; yarn dedupe` walk surfaces
    40+ TS errors across `client-utils`, `ERTP`, `async-flow`,
    `governance`, `internal`, `network`, `orchestration`, `vats`,
    `zone`.
  - The `.yarnrc.yml` catalog block is needed for that walk
    (the missing `dev` catalog entry).
  - Patch decisions: `pass-style@1.8.0` absorbs the patch
    (delete); `bundle-source@4.3.1` has rewritten cache.js +
    dropped esbuild dep (keep pinned at 4.2.0); `compartment-mapper@2.2.0`
    still emits `__createdBy` (small rebase for new `link-pattern`
    instance).

## Task — iterate-until-green

The shepherd identified the regressions as rebase-delta-
intrinsic; the prior fixer deferred the broader bump. The
maintainer's directive now authorizes any reasonable scope
expansion. Your task is **diagnose, fix, push, watch CI,
repeat**, until either:

- **All non-acknowledge checks green** → terminate with
  success summary.
- **You hit a genuine impasse** that needs the maintainer's
  strategic input (e.g., a regression with no obvious in-this-
  PR fix; a question of whether to split into a follow-up PR
  vs land here) → escalate with a specific question, not a
  vague "stuck" framing.

In your `project/` worktree on `mirror/12527-endo-sync-refresh`
at `cc64691f78`:

### Phase 1 — Investigate the runnerChain assertion

1. Pull the failed test logs for a representative SwingSet-
   bootstrapped failure (e.g., `test-swingset (node-new, 0, 5)`):
   ```sh
   gh run view <run-id> --log-failed --repo kriscendobot/agoric-sdk
   ```
   Pre-count errors per the memory rule (`grep -c error`).
2. Find the source of `refs.runnerChain` — likely a SwingSet
   bootstrap helper that sets up cross-vat references. Grep
   for `runnerChain` in `packages/SwingSet/` and adjacent.
3. Compare the failing-test setup against an equivalent
   passing-test setup. Likely the `runnerChain` is set during
   bootstrap and the mirror's rebase delta dropped something
   that establishes it.
4. **Verify against upstream**: this exact test on
   `Agoric/agoric-sdk#12527` is green. So either:
   - A commit on Agoric master since the mirror's frozen base
     (`master-daf7a86`) introduced this; the mirror needs to
     pull it in, OR
   - A commit landed on the mirror but not upstream is
     breaking it, OR
   - The Endo cherry-pick affected something
     SwingSet-bootstrap depends on.

### Phase 2 — Address per failure class

Group the 12 failures by root-cause class (likely 2-3 classes,
not 12 distinct issues per shepherd's analysis). For each class:

1. Implement the smallest fix that resolves the class.
2. Commit with conventional-commit scope.
3. Push: `git push bot HEAD:mirror/12527-endo-sync-refresh`
   (append push only; do NOT amend prior commits; do NOT
   force-push).
4. Watch CI for that failure class clearing. Per
   `garden/skills/pr-ci-watch/SKILL.md`.

### Phase 3 — Iterate

If new failures surface after a push (or remain after a fix
attempt), repeat Phase 2.

If the full `yarn up ses '@endo/*' -R` walk becomes the cleanest
path (rather than surgical fixes), pursue it: the maintainer's
directive authorizes the scope expansion. The prior fixer
documented the 40+ TS error path; address them iteratively per
package.

### Phase 4 — Escalate only at impasse

If you hit a question the maintainer needs to decide (e.g.,
"this would require a follow-up PR; should we split or merge
incrementally"), post a top-level comment on PR #5 with a
specific question + the evidence behind it, then terminate
the dispatch with `next: liaison` + the question framing.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `mirror/12527-endo-sync-refresh` via `git
  push bot HEAD:mirror/12527-endo-sync-refresh` (append push only).
- **Multiple push cycles** as the iteration requires.
- **Add `dev` catalog entry** to `.yarnrc.yml` if the broader
  walk path is chosen.
- **Update patches** per the prior fixer's documented decisions
  (`pass-style` delete, `bundle-source` keep at 4.2.0,
  `compartment-mapper` rebase for `link-pattern`).
- **Cherry-pick commits** from upstream Agoric/agoric-sdk master
  if needed to close the rebase delta.
- **Post per-iteration update comments** on PR #5 only when
  substantive (each push doesn't need a comment; one mid-cycle
  comment if iteration is getting long).
- **Post a top-level success summary** on PR #5 once all
  non-acknowledge checks are green.
- **Reply on the directive comment** (`4666955938`) at
  termination naming the outcome.
- **Escalate `next: liaison`** at impasse with a specific
  question.

## Out of scope (until impasse)

- Do NOT amend builder, shepherd, or prior-fixer commits.
- Do NOT force-push.
- Do NOT rebase onto a moving base unless cherry-picking a
  specific upstream-Agoric-master commit is the right fix
  (which is different from a full rebase).
- Do NOT mark the PR ready; the maintainer un-drafts.
- Do NOT re-request review.
- Do NOT chase `test-dapp (node-new)` unless evidence shows it
  is this PR's regression specifically.

## Deliverable

A `result` entry under `journal/entries/2026/06/10/` naming:

- Pre/post branch tip SHAs.
- Per-commit substance summary (with SHA, scope, motivation,
  per-failure-class addressed).
- The diagnosis of `runnerChain` (root cause).
- Per-CI-iteration log: push N → which failures cleared / which
  remained / which new ones surfaced.
- Final CI state.
- Per-class resolution: substance vs upstream-master-catchup vs
  Endo-version-bump-walk.
- The PR comment URL (success summary OR impasse question).
- The directive-reply comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: none` if green and review-
  ready; `next: liaison` with a specific question if at impasse;
  `next: shepherd` if CI needs continued watching after your
  last push (rare; you should usually drive to terminal state
  yourself per this dispatch).

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
