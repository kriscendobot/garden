---
handed-off: ebfb-petname-path-only-sweep-4
deliverable-complete: false
---
# ebfb-petname-path-only-sweep-3: completion report (handed off)

This job is not finished. I pushed two commits to https://github.com/endojs/endo-but-for-bots/pull/1390 (head `build/pet-name-path-only`, now `5cab6a0080`), but that head's CI is still red: `packages/floot` fails 30 tests locally. The rest of the work is posted as successor job `ebfb-petname-path-only-sweep-4`, which is confirmed in `jobs/todo/` on `origin/journal2`. The PR body status section and the pr-completion comment are not done; they are in the successor's scope.

## Commits pushed
Both were pushed with `safe-push-pr-head.sh`. A gauntlet clean stage is running on the same PR, so I sent it a coordination message.

1. **`795fa19377`, test fixes:**
   - endo-fs-exec: `makeFromTree` tree names are now arrays. These two tests were the CI failure on `3958a07`.
   - daemon test: `provideHost` inside an evaluated source string now takes an array.
   - Chat test expectations updated in `command-executor` and `edit-message-inbox` (the cover failures).
   - `directory-read-only-view` test expectations updated.
   - Reverted a codemod false positive: a mount file's `writeText(content)` takes text, not a path.

2. **`5cab6a0080`, source and test fixes:**
   - `agentName` options are now arrays across the daemon tests, `lal/setup.js`, `fae/src/subagent-host.js` and the chat whylip flow.
   - Also arrays now:
     - the handle passed to the `provideAgent` test helper
     - the archive name in `storeBlob`
     - `storeValue` names in codex-sandbox `audit-journal`, hosted-agent `account-oracle` and `claude-credentials-factory`
     - `storeLocator` names in chat `add-space-modal`
   - **Real bug in claude-sandbox `claude-sandbox-factory.js`:** it passed bare strings in several places — the evaluate endowment list, `adopt` pet names, `resultName`, `remove`, and the namespace helper's output. It now uses a helper that wraps a lone name into a one-element array and never splits a string. Edge names stay strings, because the daemon's `adopt` checks them with `assertName`.
   - Reverted more codemod false positives: `EndoRegistry.lookup(name, version)`, `EndoTraces.lookup(errorId)`, and the XS worker facet's `evaluate(source)`.
   - Test fakes updated: claude-sandbox factory, credentials and provisioner; codex-sandbox audit-journal; workflow setup; networks-ocapn.

## Verified locally
- **Package suites that pass:** chat (896), claude-sandbox (143), codex-sandbox (187), hosted-agent (143), workflow, fae `subagent-host`, endo-fs-exec (15).
- **Daemon test files that pass:** networks-ocapn, error-trace, registry, xs-worker-facet, request-result, directory-read-only-view (51 tests).
- **Partial:** a re-run of the daemon channel, endo and invite-retention-ocapn tests showed no failures before I stopped it.
- **Not run:** the full daemon suite. The first full run hit its 45-minute timeout with 226 tests still pending.

## Remaining work (owned by sweep-4)
- **floot:** 30 local failures on `5cab6a0` across ten test files. The cause is test fakes keyed by bare strings, and possibly a src round-trip: container-mounts-hosted fails with `Unknown session "one"`. Changing the fakes' `lookup`/`storeValue` to take arrays was not enough, so I reverted that attempt.
- **Other packages:** CI stops at the first failing package, so more may fail once floot passes.
- **Possible flake:** a hosted-agent provider-worker timeout on macOS in `795fa19`'s CI.
- **To finish:** pre-push gates, CI green, PR body status update, and the pr-completion comment.
- **Local daemon runs:** the successor brief has the recipe. Hardlink-copy the worktree to a short path on the same device (`/var/tmp` is on a different device), and rebuild better-sqlite3 with `node-gyp`.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 276 tokens (16328567 cached reads)
- Output: 47118 tokens
- Cost: $5.579969399999999
- Wall-clock: 2313s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
