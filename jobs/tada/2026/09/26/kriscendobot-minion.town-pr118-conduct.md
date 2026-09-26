I didn't merge PR #118. After I rebased it onto current `main`, one test fails every time, so I stopped the merge and posted a shepherd job to fix it.

**What happened:**
- **Checks before merging:** the PR was open, still a draft, and mergeable, with 3/3 checks green. dckc approved head `796cbf73a5b`, and dckc is on the maintainers allowlist. It's a bot repo, so none of the forbidden repos were involved.
- **Rebase:** I ran the merge script (`ci-wait-merge.sh`). It moved the PR's base from the frozen snapshot `main-27a6e2b` to live `main`, which was 19 commits ahead. It then rebased the head onto `main` (`561472a2157`) and pushed it, so the head changed from `796cbf73a5b` to `e71dd2e128e`. The first run stopped with exit 4 because the head changed during the push. The second run waited on CI.
- **CI after the rebase is red (exit 3).** Job `test`, step "Test live-daemon B1 acceptance against pinned Endo daemon", fails with `AssertionError: expected true to be false` in:
  `test/endo-daemon-integration.test.ts > B2 tool layer: writeText -> readText -> restart -> read (self-healing)`
  I re-ran the failed job once and it failed the same way. The same test passes on `main` at `561472a`. So the likely cause is this PR's guest-router scoping change interacting with the newer commits on `main`, not a one-off failure.
- **Result:** stalled with `ci red: needs shepherd`. The PR is still open and still a draft.

**Follow-ups:**
- I posted `kriscendobot-minion.town-pr118-shepherd-20260926`, which carries the failure details and tells the shepherd to use `GARDEN_YARN=npm`.
- dckc's approval is on the head from before the rebase, so it is now stale. Once CI is green, a maintainer has to approve the new head before a conductor can merge. The conductor removes draft status at merge time.
- dckc asked on the PR "why is this a draft?" and nobody has answered yet.
- The frozen base branch `main-27a6e2b` still exists. Clean it up with `sweep-frozen-bases.sh` after the merge.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr118-conduct.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (551479 cached reads)
- Output: 3753 tokens
- Cost: $0.5769158
- Wall-clock: 496s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
