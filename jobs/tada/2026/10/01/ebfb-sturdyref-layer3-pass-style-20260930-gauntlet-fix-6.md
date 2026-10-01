---
orchestration-failed: true
---
orchestration-failed (CI RED, `ci-wait-merge.sh` rc 3)

# Gauntlet fix round 6: endojs/endo-but-for-bots PR #1392

I applied the round-6 fixes and pushed them, but CI came back red. 32 of 33 checks passed. The one failure, `test (22.x, macos-15)`, is in `@endo/daemon`: `daemon-teardown › an orphaned daemon shuts itself down instead of lingering` failed its "daemon recorded its pid before its launcher exited" check (`packages/daemon/test/daemon-teardown.test.js:196`). This PR doesn't touch `@endo/daemon`; the test only ran because `@endo/daemon` is in the CI affected set. It looks like a macOS timing flake, but I couldn't rerun it to confirm: `gh run rerun` got a 403 on this host's bot token.

The PR body edit and the summary comment are not done either; that token also can't write to endojs PRs. I posted a separate job to do them (details below).

## What I changed
Pushed `63137a13c..b39ee2bde` to `build/sturdyref-pass-style-recognition` with `safe-push-pr-head.sh`:

- **saboteur (must-fix):** `5488aed36` stops unbounded recursion when the `SturdyRef` brand check calls back into `passStyleOf`. A module-level flag in `packages/pass-style/src/sturdyref.js` makes the inner, reentrant check reject its candidate. The new `test/sturdyref-reentrant-global.test.js` checks the brand check runs once, and it fails when the guard is disabled.
- **corner-prober (must-fix), also raised by assessor:** `29b36108f` removes the `case 'sturdyRef'` branch from `dot-membrane.js`, because it could never run: the encoder refuses a SturdyRef before the membrane sees it. If that ever changes, the membrane's `default` branch still throws. The membrane test now matches only the encoder's `cannot be marshalled` message, and the unused `q` import is gone.
- **corner-prober and spec-keeper (should-fix):** `985375b00` adds a `'sturdyRef'` case to both `spaces-util` renderers (`value-render.js`, `value-vnodes.js`). A value containing a SturdyRef no longer reaches the "unreachable" error.
- **pruner:** `b39ee2bde` shortens the `SturdyRefObject` comment in `types.d.ts`, removes a repeated line from the marshal changeset, and cuts the pass-style changeset's compartment sentence down to what a consumer needs.
- **engine-realist:** no change. The PR body already says XS tests are deferred under Testing Considerations.

## Local checks
- The `ses-ava` suites pass for pass-style and marshal.
- `lint:types` is clean for both.
- eslint (0 errors; one unused-disable warning at line 1 of `dot-membrane.js`, which was already there) and prettier are clean on the touched files.
- The full pass-style run under ses-ava hit an ava cache `ENOENT` race locally. Re-running the affected sturdyref files on their own passed.

## Still open
- **PR body and summary comment (integrator must-fix):** `gh pr edit` failed with a 403. I posted `ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-6-pr-write`, pinned to `endolin-garden-ece02cb4` (identity `endojs/endo-but-for-bots#1392:gauntlet-fix-6:pr-write`). Its body includes the new PR description and the round-6 summary comment. The description reconciles the PR with #695's changes-requested review: `'sturdyRef'` is its own pass style, not a remotable; recognition never enlivens; and the confinement and GC/revocation concerns belong to the later enliven and locator layers. It also names the devDependency-cycle cleanup and the reentrancy guard. If panel-7 runs before that job finishes, integrator will flag the body again.
- **CI:** the failed macOS job needs a rerun from an identity that has Actions write access.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (4403561 cached reads)
- Output: 20952 tokens
- Cost: $2.1372242000000004
- Wall-clock: 4507s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
