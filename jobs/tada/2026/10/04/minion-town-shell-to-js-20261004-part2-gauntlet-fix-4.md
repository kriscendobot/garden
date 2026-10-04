Fix round 4 for kriscendobot/minion.town PR #152 is pushed (head `b308a11`, previously `18d1006`) and CI is green (3 of 3 checks).

**What I changed, by panel seat:**
- **assessor (must-fix):** The create-function retry in `deploy-thunk.js` called `spawnSync` directly, so a Ctrl-C there was reported as an AWS failure. I added a helper, `awsAttempt()`, to `lib/common.js`. It captures stderr so the "cannot be assumed" retry still works, and on a Ctrl-C it exits with code 130 after running the exit hooks. `deploy-thunk.js` now uses it, and a new test covers it.
- **saboteur:**
  - `deploy-pre-token-gen.js` now reads the `describe-user-pool` output with `parseJson`, so bad output gives an error that names the pool.
  - The zip writer in `lib/zip.js` now throws when a value is too big for its ZIP field (entry count, sizes, offsets, name length) instead of silently writing a corrupt archive. A new test checks 65536 entries.
  - A failing exit hook now writes a line to stderr instead of failing silently.
  - Its comma-injection note is a pre-existing issue copied over from the shell scripts, so I left it out of scope.
- **archivist:** Added doc comments to `accountsStorePolicy`, `requireRole` and `makeAccountGateScript`.
- **pruner:** Shortened the first part of the PR body so it no longer restates the diff. The behavior-changes and series sections are unchanged.
- **scribe:** Posted a summary comment for fix rounds 3–4 with a per-seat table (https://github.com/kriscendobot/minion.town/pull/152#issuecomment-5984021113). It also covers the round-3 push, which never got one.

The PR's test file passes locally (29 tests). Prettier reports style warnings on some of the touched files, but the files had them before this round and prettier isn't one of the repo's npm scripts.

**Follow-ups:**
- The scribe suggests the gauntlet fix stage post the "Fix round N" summary itself, since a missing summary has now been flagged twice on this PR.
- `deploy-cd-iam.mjs` still calls `execFileSync` directly. This PR doesn't touch that file, so I left it alone.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part2-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1201453 cached reads)
- Output: 9725 tokens
- Cost: $0.9988946
- Wall-clock: 411s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
