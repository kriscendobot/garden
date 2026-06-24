---
ts: 2026-05-22T22:31:22Z
kind: result
role: cleaner
worktree: dispatches/cleaner--12a8b9/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/22/221400Z-dispatch-general-contractor-12a8b9.md
---

PR #320 (feat(familiar): consolidate daemon stop/purge via CapTP control helper, G8 of #231).

Coverage assessment.
`@endo/familiar` is an Electron-shell package with no test/ directory, no AVA config, no c8 in scripts, and no test scripts in package.json.
The touched surface (daemon-control.js, src/daemon-manager.js, src/resource-paths.js, scripts/bundle.mjs) has no unit-test infrastructure to expand.
The PR body itself defers end-to-end smoke testing to the G16 packaged-smoke harness.
This is a no-coverage-surface case; the cleaner did not raise coverage.

Adversarial pass on the concurrent stop/purge paths found one real bug in `runDaemonControl` (packages/familiar/src/daemon-manager.js).
The 30s timeout was never cleared on the success or error close events, so after a Restart Daemon or Purge Daemon menu click the Electron event loop stayed alive for the remainder of the 30s window before the kill-and-reject no-op fired.
Fixed in one commit: hoisted a single-settle latch around resolve/reject that clears the timer in all three exit paths and guards the double-settle case where spawn synthesizes both an `error` and a `close` event on ENOENT.

Body audit.
PR body is accurate to the diff.
Bundle size numbers, CapTP shape, lockdown rationale, file-list, and changeset bump all match the code.

Dead-code audit.
`resourcePaths.endoCliPath` is now exported but no longer referenced by any source file in packages/familiar/.
Not deleted: the PR body explicitly defers dropping `endo-cli.cjs` from the production runtime path to a follow-up.
Removing the export now would create a small inconsistency with `scripts/bundle.mjs` still producing the bundle; the maintainer's framing keeps both in place pending the follow-up.

Commits landed.
1 commit: `fix(familiar): clear daemon-control timeout on settle`, pushed to feat/familiar-consolidated-stop-purge.

CI status.
3 jobs fail on the new HEAD: `lint`, `cover (20.x)`, `cover (24.x)`.
Single root cause: `packages/ocapn/test/netlayer-tcp-syrup.test.js` imports `makeClient` from `../src/client/index.js`, which exports `makeOcapn` on origin/llm (renamed in a recent base-branch commit).
The PR's last-CI run on 2026-05-20 was fully green; the base has drifted ~30 commits since then.
This is base-branch drift, not regression caused by my commit.
Recommend a weaver dispatch to rebase PR #320 onto origin/llm before judge; the rebase will surface the ocapn test as either resolved-upstream or as a real conflict needing maintainer attention.
All `familiar`-related checks (familiar-bundle, lint on linux, test, build) pass.

Self-improvement: cleaner-on-Electron-shell-package is a recurring no-coverage-surface case; consider a one-line norm in roles/cleaner/AGENT.md that "packages without test infrastructure (no test/ dir, no AVA config) fall under the same skip rule as doc-only PRs; the cleaner still does the body/dead-code/adversarial audit but coverage iteration is moot."
