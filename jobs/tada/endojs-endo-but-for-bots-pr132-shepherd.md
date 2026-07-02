Inbox empty. The work is complete: I diagnosed the failure, determined it's out of shepherd scope, escalated via a parked plan job, and documented the finding on the PR.

## Completion report — shepherd on endojs/endo-but-for-bots #132

**Diagnosis (real evidence).** Fetched live check state (`gh pr checks 132`): 4 failing checks — `cover (20.x)`, `cover (24.x)`, `lint`, `zizmor`; everything else green. Read each failing log:
- `cover (20.x/24.x)`: `packages/ocapn/test/netlayer-tcp-syrup.test.js exited with a non-zero exit code: 1` (`SyrupAnyCodec: read failed`).
- `lint`: `packages/ocapn/test/netlayer-tcp-syrup.test.js:7 makeClient not found in '../src/client/index.js'` (import/named), exit 1.
- `zizmor`: findings in `familiar-release.yml` / `ci.yml` / `release.yml`, exit 14.

**Root cause.** None of the failures are in the code this PR touches (only `packages/chat/{inbox-component.js,index.css,test/unit/command-executor.test.js}`). The branch is **1282 commits behind base `llm`**; base `llm` CI is fully green. Every failure is on the stale base (broken ocapn source/import, stale workflow files). A rebase onto current `llm` would clear all four checks.

**Why I stopped short of the rebase.** I attempted `git rebase origin/llm` in an isolated project worktree (`ensure-project-worktree.sh`). It hit an **architectural** conflict: on current `llm`, `inbox-component.js` is a 114-line thin host wrapper (message rendering moved into the confined `@endo/space-chat` `InboxRoot`); this PR added the Md/Raw/Pre toggle inside the old 911-line inline render loop that no longer exists. The feature must be **re-implemented inside `InboxRoot`**, not merged — builder/fixer work, beyond shepherd scope. (`command-executor.test.js` conflicts only additively.) I aborted the rebase cleanly; **no changes pushed to the PR branch**.

**Escalation / follow-ups.**
- Parked a **go-ahead-gated plan job** `endojs-endo-but-for-bots-pr132-report-render-mode` (by=fixer) capturing the re-port task and the alternative (close & rebuild fresh) — awaits a maintainer decision rather than auto-burning effort on a possibly-unwanted re-port of a 1282-commit-stale branch.
- Posted a top-level PR comment (issue #4861193694) documenting the stale-base diagnosis and the architectural blocker, per the PR-comms norm.

Inbox drained (empty). Project worktree left in place (stable across requeue; garbage-collected on teardown).
