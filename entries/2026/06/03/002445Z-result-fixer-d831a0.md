---
ts: 2026-06-03T00:24:45Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--d831a0
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
refs:
  - entries/2026/06/03/002011Z-dispatch-liaison-d831a0.md
  - https://github.com/endojs/endo-but-for-bots/pull/394
  - https://github.com/endojs/endo-but-for-bots/pull/394#discussion_r3345008843
  - https://github.com/endojs/endo-but-for-bots/pull/394#discussion_r3345015686
---

# result: fixer — #394 carry kriskowal review 4414303711 missed asks

Two of the three inline asks from kriskowal review `4414303711` addressed on PR endojs/endo-but-for-bots#394.
The third (line 446, Git-backed CAS architectural pivot) was explicitly out of scope per the dispatch and remains parked as designer-scope deferral.

## New head SHA

`c29678f5f1fac7a015b7e4d05fa36066b5df5396` on `design/gateway-package-phase-6`.
Push prior head: `b22e0db66`.
Single regular-append commit, fast-forward push to origin.

## Diff summary

One file touched: `packages/gateway/test/git-http-integration.test.js` (+2/-4).

- Lines 86-88 (now 86): trimmed the apologetic three-line comment block ("We use modular arithmetic instead of bitwise operators so this module passes the project's `no-bitwise` ESLint rule") from `makeHex64`'s body comment. The LCG body itself is unchanged; the modular form already satisfies the rule without any eslint-disable.
- Line 414 (now 412): replaced the `repoId` seed `0xcafebabe` with `0xb0b5c4fe` per the maintainer's positive-example suggestion. Left `token = makeHex64(0xdeadbeef)` and `wrongToken = makeHex64(0xfeedface)` in place as standard debugging magic numbers.

No source files changed. No other test files changed. No `yarn.lock` churn.

## Local gate exit codes

- `yarn lint` in `packages/gateway`: exit 0 (158 pre-existing warnings, 0 errors; same warning shape as before the edit).
- `yarn ava test/git-http-integration.test.js` in `packages/gateway`: exit 0 (1 test passed: "git CLI push and pull through the Gateway with bearer auth").

The PR's CI is broken at the inherited-stack level (lint + tests failing in `packages/ocapn` per the prior shepherd diagnosis). That is out of scope here; the local gates confirm this PR's own test file lints and passes.

## Path A vs B for ask 1

Chose **Path A** (trim the apologetic comment block; keep the LCG).
Path B (swap to `@endo/chacha12`) was infeasible from inside this dispatch: no `@endo/chacha12` package is present in the repo's `packages/` (verified by `ls packages/ | grep chacha` returning no rows; the closest neighbour is `@endo/hex` which does not export a seedable PRNG).
The LCG already satisfies the maintainer's substantive note ("we don't need the rule at all"): no eslint-disable was needed, and the apology block was over-explaining a non-problem.
The Path B option is preserved in the journal record (not the inline reply text) in case a future dispatch wants to revisit it after a chacha12 package lands.

## Inline-thread reply IDs

- Reply to `3345008843` (bitwise apology): comment id `3345232105`. Body cites `c29678f5f`, explains Path A choice, and notes the chacha12 swap was set aside because no chacha12 package is present in the repo.
- Reply to `3345015686` (lewd hex reference): comment id `3345232199`. Body cites `c29678f5f`, confirms the `repoId` seed is now `0xb0b5c4fe`, and notes the other two seeds were left in place.
- No reply on `3345066407` (Git-backed CAS architectural pivot). Out of scope per the dispatch; the prior journal note (`entries/2026/06/02/233624Z-message-liaison-394-cas-pivot.md`) already records the designer-scope deferral.

## Reactji actions

- `+1` reactji on inline comment `3345008843` (reactji id `398363480`).
- `+1` reactji on inline comment `3345015686` (reactji id `398363481`).

Both surfaced no prior reactji from the steward's earlier triage (the triage focused on the line-446 architectural pivot only; these two were missed). The fixer-side `+1` acknowledges the maintainer's input on the now-addressed asks.

## Not done

- No top-level summary comment on the PR. The dispatch authorized inline replies only; a top-level summary was not in the per-action list. The inline replies plus the commit's message together convey what changed; the maintainer can re-read the threads to confirm.
- No re-request review. The PR's CI is red at the inherited-stack level (out of scope) and the dispatch did not authorize a re-request; per the role norm "drive CI to green BEFORE re-requesting maintainer review", a re-request would be premature anyway.
- No un-draft. Not authorized; this PR remains draft as the dispatch left it.

## Garden-meta follow-up

The maintainer's comment `3345015686` also said:

> For the gardener, the style guide should recommend positive examples, only.

This is a garden-meta directive for the gardener's style guide on the `kriskowal/garden` repo, not for `endo-but-for-bots`.
Recommended follow-up: a separate gardener dispatch to land a one-sentence guidance in the relevant style skill (likely `skills/em-dash-style/SKILL.md`'s neighbourhood or a new "positive-examples" skill) saying that example hex / magic-number constants in bot-authored prose and code should be positive shapes (`0xb0b5c4fe`, `0xc0ffee`, `0xfeedface`) and avoid lewd or otherwise charged references.
The steward should queue this when its scan picks up unaddressed garden-meta directives, or the liaison can dispatch the gardener directly when convenient.

Not done in this dispatch (out of scope for #394's PR-side work, and the per-action authorizations explicitly excluded editing the gardener's style guide).

## CI observation (informational)

CI on `c29678f5f` will inherit the same red status as `b22e0db66` (the inherited-stack failures in `packages/ocapn`).
The test file edited here passes locally; if a future shepherd dispatch greens the inherited stack, this PR's own checks should follow.

Self-improvement: nothing this time. The pre-push gate skill and the dispatch's two-asks-with-Path-A-or-B framing already routed this cleanly; no structural lesson surfaced.
