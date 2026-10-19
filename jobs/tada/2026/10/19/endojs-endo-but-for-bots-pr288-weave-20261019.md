PR #288 is woven. Its base is now the frozen snapshot `llm-330cf99` instead of the floating `llm`, and its head is rebased onto that snapshot.

- **Base and head together:** https://github.com/endojs/endo-but-for-bots/pull/288 has base `llm-330cf99` and head `3ee08149e`. The PR shows `MERGEABLE`, and `assert-pinned-base.sh pr` exits 0.
- **Rebase:** a previous claimant of this job had already rebased `feat/cbors-package` onto `llm` tip `330cf996c0` and pushed it (commits dated 2026-10-19 13:51–13:54Z), then died before moving the base. When I checked, the head was 0 commits behind `llm` and 14 ahead. The `llm-330cf99` branch already existed at that tip, so I reused it. I didn't rebase again, and no conflicts needed resolving in this attempt. The `chore: Update yarn.lock` commit is still separate, and the `chore: regenerate composite tsconfig files` commit is still there.
- **Delta check:** `git diff --stat llm-330cf99..HEAD` lists only the PR's 24 files: `packages/cbor-frame/*`, ocapn's netlayer/test/package changes, two changesets, the lp32 and netstring READMEs, the root composite tsconfig and `yarn.lock`. Nothing unrelated was pulled in.
- **CI:** on the rebased head, 28 checks pass, 10 are skipped and none fail.
- **Base move:** on this host (oros-studio), `gh pr edit --base` got a 403 on `updatePullRequest`, the known gap in the bot token's permissions on endojs. I posted job `endojs-endo-but-for-bots-pr288-weave-20261019-move-base`, pinned with `requires: host=endolin-garden-ece02cb4`. It was told to check that the head was still `3ee08149e` and then change only the base field. An endolin worker claimed it at 15:12:29Z and the base had changed by 15:12:54Z.

The follow-ups are the shepherd and conduct jobs already lined up in this orchestration (`…-pr288-shepherd-20261019`, `…-pr288-conduct-20261019`). The lasting fix for the 403 is still giving the bot token write access to pull requests on endojs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr288-weave-20261019.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1088702 cached reads)
- Output: 6259 tokens
- Cost: $0.7556324
- Wall-clock: 1530s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
