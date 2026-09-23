---
ts: 2026-06-16T00:12:58Z
kind: result
role: fixer
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/15/230109Z-result-fixer-cb7a05.md
---

# Fixer: PR #5 Class A redux — diagnose post-cb7a05 still-failing imports.test.ts

Prior fixer cb7a05 applied SES-2-compatible endo resolutions to
`multichain-testing/package.json` and regenerated its yarn.lock; the
lockfile correctly collapsed to a single SES 2.2.0 entry. But Class A
(multichain-testing imports.test.ts `null == true`) persisted on CI head
`e435b5cdca` (run 27582269050). This dispatch diagnosed the real
underlying cause and fixed it.

## Diagnosis

Reproduced locally by copying the dispatch root's `project/` into
`/home/kris/fixer-cc9bb5-tmp/agoric-sdk/` (per cb7a05's portal-path
note; could not use `/tmp/...` because of an EXDEV boundary on the
hardlink-from-yarn-berry cache, the host's overlayfs vs ext4 split),
then `yarn install` at root, `yarn build`, `yarn install` in
multichain-testing, `yarn ava test/imports.test.ts`. Test failed
identically: `AssertionError [ERR_ASSERTION]: null == true`.

The empty stack trace was the giveaway. By switching the test's static
import to a dynamic `await import('@endo/ses-ava/prepare-endo.js')`,
got the real stack: assertion thrown from `ava-8.0.1/lib/worker/main.js:7`
which is `assert.ok(refs.runnerChain)`. The CLI launching the test
process is ava 6.3.0 (multichain-testing's `ava: ^6.2.0` pinned dep);
`@endo/ses-ava@1.4.2` declares peerDep `ava: ^6 || ^7 || ^8` and yarn
resolved that to **8.0.1** (the highest in range). Inside the test
process, `prepare-endo.js` loaded ava-8.0.1's worker `main.js` which
expected ava-8 worker state, but the launcher was ava-6, so
`refs.runnerChain` was null and `assert.ok(null)` threw `null == true`.

The split was already present on `bf7b2d9604` (two commits before
cb7a05). 51cb8ec4e0 (turadg, "chore(deps): bump ava to ^7.0.0 across
workspaces") was the agoric-sdk-wide ava bump that *missed*
`multichain-testing/package.json` because multichain-testing is a
standalone yarn project, not a workspace member. So
multichain-testing's ava floor stayed at ^6.2.0 while ses-ava's peer
range opened to ^8.

cb7a05's SES-pin work is good and stays; it was a real second problem.
The AVA-split is the one that produced the `null == true`.

## Fix

Two changes to `multichain-testing/package.json`:

1. Bump `"ava": "^6.2.0"` → `"ava": "^7.0.0"` to match every other
   workspace.
2. Add resolution `"ava@npm:^6 || ^7 || ^8": "npm:^7.0.0"` so
   transitive `@endo/ses-ava` resolves to the same major.

Without the resolution, yarn still picks 8.0.1 for the deeper range
even after the direct-dep bump. With the resolution, lockfile shows a
single `ava@npm:7.0.0` entry.

## Verification

Local repro head:
`yarn ava test/imports.test.ts` passes (was failing before the change).
`yarn lint` shows the same five jsdoc warnings as CI (0 errors).
Pre-push gate probes: all pass.

## Commits

- pre: e435b5cdca334c4d2370383932254f33fbc2c371
- post: 46b5491dec84beecaa7b6c9d10c93eaca06ed9c4

- 882f5257a8 `fix(deps): bump multichain-testing ava to ^7.0.0; pin via resolution`
- 46b5491dec `chore: Update yarn.lock`

Push: append-only to `mirror/12527-endo-sync-refresh`.

## Maintainer notification

- Top-level diagnosis-and-fix comment:
  <https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4713601163>

## Recommended next stage

`next: fixer` — verify on the next CI cycle that `46b5491dec` resolves
Class A. If yes, proceed to Class B (test-cosmic-swingset SIGHUP); the
cb7a05 SES-pin + this ava-pin may have transitively resolved B because
cosmic-swingset's test infrastructure shares the same ava + ses-ava
graph. Classes D (test-dapp expected fail) and E (fast-usdc-deploy SES
1.x bundle deserialization) remain maintainer decisions per prior
directives.

Self-improvement: an `AssertionError ... null == true` originating
inside an ava worker bootstrap with an empty stack trace is a strong
signal of dual-ava-installs in the lockfile. The dynamic-import probe
(`await import(...)` inside a test file) surfaces a real stack where
the static-import form swallows it. Future fixers diagnosing this
shape should grep `yarn.lock` for two `^ava@npm:` entries before
chasing SES theories. Adding this to the fixer's quick-checks would
let the next caller skip the SES-rabbit-hole I would have started
down if cb7a05 had not already burned that path.
