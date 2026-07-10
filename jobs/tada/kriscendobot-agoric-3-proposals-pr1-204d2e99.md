The directive is fully satisfied. No garden-code changes were needed — this job was a confirm-and-close on the project fork.

## Completion report

**Job:** attention directive on `kriscendobot/agoric-3-proposals` PR #1 — "Please confirm that the analogous work landed upstream and close."

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer had already resolved). Inbox drained clean at start and before acting.

**What I did (all read-only upstream, per the no-touch-upstream constraint):**
- Verified `Agoric/agoric-3-proposals` now carries proposals **111** (ymax-beta), **112** (reserve-liquidate), **114** (qstn-survey), **115** (qstn-survey-2), **116** (mint-inflation-bounds) on the default branch, each with full `submission/`, `README.md`, `test.sh` (bundles present for 111/114/115). **113** is correctly omitted upstream too.
- Confirmed the equivalent change **merged upstream as PR 320** (state MERGED, mergedAt 2026-07-02, mergeCommit `401d3c5`) — identical per-proposal commit messages to the fork PR — and tracking **issue 316 is CLOSED** (2026-07-03).

**What changed:**
- Posted a confirmation comment on fork PR #1 and **closed it** (now `CLOSED`), under the bot identity, on the fork only. The comment cites the upstream landing in prose without `#`-autolink or URL syntax, so **no cross-reference event lands on the upstream repo** (honoring the fork PR's "no upstream links" scope and the standing upstream-agoric comment/link-free constraint).

**Repo/worktree:** No garden `main2` changes; nothing to commit or push. All work was read-only upstream inspection plus the in-scope close on the bot's own fork.

**Follow-ups:** None.
