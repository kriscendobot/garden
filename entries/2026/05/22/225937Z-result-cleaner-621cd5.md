---
ts: 2026-05-22T22:59:37Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo
pr: 321
worktree: dispatches/cleaner--621cd5/project
refs:
  - entries/2026/05/22/230300Z-dispatch-general-contractor-621cd5.md
---

# Cleaner pass on PR #321: SKIP (workflow-only variant)

PR #321 (ci(familiar): wire macOS arm64 + x64 matrix end-to-end, G15 of #231) is MERGEABLE, draft, no review yet, all CI green. The diff touches three paths only:

- `.github/workflows/familiar-release.yml` (workflow YAML; +19/-1)
- `packages/familiar/scripts/make-distributables.mjs` (release-only build script; +19/-4)
- `packages/familiar/scripts/package-app.mjs` (release-only build script; +24/-6)

## Coverage assessment

No coverage surface to expand. The two `.mjs` files are release-only build scripts (consumed by the `workflow_dispatch`-only `familiar-release.yml` and by `yarn workspace @endo/familiar build:package` locally); they are not on the `c8` covered surface and have no existing unit-test scaffold. Adding one would land a unit test "whose only purpose is to keep otherwise-dead code alive" per the cleaner's anti-pattern norm. The natural exercise is end-to-end on GitHub's macos-14 / macos-13 / ubuntu-latest runners during a tagged release, which the PR body's *Testing Considerations* already documents (and which the builder exercised locally on macOS arm64 and x64 via `yarn workspace @endo/familiar build:package`).

This is functionally equivalent to the role file's enumerated skip cases (pure docs, lockfile-only, one-file format sweep, single-line bug fix with test fixture in diff): the unifying principle is *no coverage surface to expand*. The workflow-only / release-script-only variant fits cleanly.

## Body audit

PR body covers Description (with the two-gap explanation), Matrix-vs-universal rationale, Security / Scaling / Documentation / Testing / Compatibility / Upgrade considerations. References #231 (G15) and the design's followups table. Workflow-comment-in-place rationale prevents future readers from chasing the design. No body edits needed.

## Dead code

None introduced. The diff cleanly replaces inline `process.platform`/`process.arch` resolution with hoisted `targetOS` / `targetArch` variables; nothing left dangling.

## Commits landed

No commits. Cleaner-skip.

## CI status

All 22 checks SUCCESS (lint, build, familiar-bundle, test on 20/22/24 × ubuntu-latest/macos-15, cover on 20/24, test262, test-hermes, test-xs, viable-release, sandbox-drivers, check-action-pins, browser-tests, build-wasm, test-ocapn-python, test-async-hooks). The workflow under modification (`familiar-release.yml`) is `workflow_dispatch`-only and is not exercised by ordinary CI; the next maintainer-triggered release will surface any plumbing bug.

## Next stage

Judge dispatch (the per-PR-creation-flow chain's cleaner-skip variant routes builder -> judge directly; here the builder's PR was opened on 2026-05-19, so the orchestrator now dispatches the barrister for the first code-panel round).

Self-improvement: the role file's *Skip the cleaner pass* enumeration (pure docs, lockfile-only, one-file format sweep, single-line bug fix) does not name the "workflow-YAML + release-only scripts" case, even though the same *no coverage surface to expand* principle applies. Future cleaner dispatches on CI-plumbing PRs (workflow YAML, release-only scripts under `packages/*/scripts/`, build glue not exercised by `c8` or `ava`) would benefit from an explicit row. Posting a message to liaison to land the role-file edit.
