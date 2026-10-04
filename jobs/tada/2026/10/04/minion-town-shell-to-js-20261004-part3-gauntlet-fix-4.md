I applied both of the panel's round-4 must-fix items to kriscendobot/minion.town#154, plus most of the should-fix items. They are pushed as one commit, `c5a3e50` (moving the head from `8b73552`), and CI went green: 3 of 3 checks passed, `ci-wait-merge` returned rc 0.

**Must-fix:**
1. **Word boundary in `$NAME` matching** (`deploy/aws/scripts/lib/remote-template.js`): a bare reference that starts with an upper-case letter now covers the whole variable name. So `echo $URLs` with `{ URL: … }` now throws `unsupplied variable $URLs` instead of rendering `http://evils`. New tests confirm `$URLs` works when `URLs` itself is supplied, and that `$URL/s` and `${URL}s` still render as before.
2. **`Pids` spelled out:** the reaper's exports are now `parseListenerProcessIds` / `listenerProcessIds`, and the test file is updated to match.

**Should-fix items also taken:**
- **Null values:** a `null` value now counts as missing, with a new test.
- **Variable rename:** `heredoc` is now `escapedSource`.
- **Unreachable error:** I removed the "no ENDO_CLAUDE_* environment" error in `deploy-app.js`, which could never fire. Each remaining MemoryMax error now has its own test input.
- **Unused variable:** I dropped `ENDO_COMMIT` from the variables `deploy-endo-daemon.js` passes to its remote template, which never used it.
- **Stale names:** the `deploy-endo-federation.js` error message and `DEPLOYMENT.md` now say `endoCommit`.

**Not taken:**
- **Shared `sleep` for the reaper:** the reaper is shipped on its own inside its systemd unit, so it can't import `lib/common.js`.
- **Left for later:** merging the two `quote` helpers, adding a check that `bash` is present before the syntax test, and the optional property tests.

I posted a PR comment summarising all of this: https://github.com/kriscendobot/minion.town/pull/154#issuecomment-5984867700

**Local tests:** in the full vitest run, 3 test files failed (1 test case plus 2 files that collected 0 tests). They are `test/git-remote/capability.test.ts` and two `tools/claude-harness` test files, none of which this commit changed. I didn't rerun them on the old head to confirm they were already failing. CI is green regardless. The tests I touched all pass.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part3-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1203398 cached reads)
- Output: 7881 tokens
- Cost: $0.9328036000000001
- Wall-clock: 417s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
