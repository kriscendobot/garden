I couldn't merge endojs/endo-but-for-bots#1647, so there is no merged llm commit SHA to report yet. CI on the PR head is red, so I stopped as the conductor role requires: **ci red: needs shepherd**.

- **Approval and base are fine.** The PR is open, not a draft, mergeable, and based on live `llm` (head `6415705c84342a13e7a83d3ec291232d12afa024`). kriskowal's approval still stands.
- **First CI wait:** the merge script (`ci-wait-merge.sh`) found 2 of 38 checks failing, `test (22.x, ubuntu-latest)` and `cover (24.x, ubuntu-latest)`. It exited without merging.
- **Same test both times:** both failures are `packages/sandbox` › `bwrap timeout and repeated cancellation reap process groups`. It fails with `process group <pid> survived bounded cleanup` at `packages/sandbox/test/bwrap.test.js:266`.
- **Rerun:** I reran the failed jobs (run 41766203719). The `cover` job failed again on the same test, so CI stays red. The `test (22.x)` rerun was still pending. The script I started to wait on the rerun was killed by the background time limit before it finished, so nothing else was attempted.
- **Probably not caused by this PR:** #1647 only touches `packages/daemon`, `packages/ocapn-noise` and a changeset, none of them sandbox code. The garden's notes record bwrap CI failures as pre-existing, with endojs/endo-but-for-bots#1566 ("make bwrap tests runner-portable") as the fix. #1566 is still open and unmerged. Since the test failed twice in a row on #1647, a rerun alone is unlikely to clear it.

No commits, pushes, rebases or merges were made.

**Follow-ups**
- No shepherd job for #1647 is on the board yet. I didn't post one because the conductor role leaves follow-up jobs to the triager. The shepherd should decide whether to land #1566 first, or otherwise fix the sandbox bwrap test, and then rerun CI.
- After CI is green, re-post a merge job for #1647. The minion.town pin bump (`ENDO_COMMIT` / `PINNED_ENDO_COMMIT`, kriscendobot/minion.town#236) is blocked until #1647 merges.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/merge-endo-1647-advertise-host-20261104.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1267122 cached reads)
- Output: 5946 tokens
- Cost: $0.8979283999999998
- Wall-clock: 1290s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
