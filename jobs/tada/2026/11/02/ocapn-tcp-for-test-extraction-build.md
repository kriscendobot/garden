I didn't open a new PR or commit anything, because PR #1485 on endojs/endo-but-for-bots already implements this extraction. A second PR would duplicate it, so I followed the builder rule to skip and surface the existing one. The job's requested draft PR therefore doesn't exist, and the extraction can't land until the maintainer rules on the design.

I wrote the PR numbers here without links on purpose, so this report doesn't trigger a new gauntlet on #1485.

**State of the related PRs**
- **#1485 (the implementation):** it moves `op:start-session` out of core into a `makeStartSessionNetwork` adapter and migrates the TCP-testing, WebSocket, iroh and thixotrope callers.
    - **Review:** it passed panel round 3 at `cd47121343` on 2026-10-17 and is undrafted, but no human has reviewed it.
    - **CI:** all 5 Actions runs at that head succeeded. I didn't run any tests myself.
- **#1480 (the design #1485 follows):** still open with no human review. #1485 follows this revision, not the February text on `llm`, which earlier builds found out of date with the code. #1430 is an older competing revision, still a draft.
- **Not covered by #1485:** when it was built, it left out the byte-identical wire-parity test. It also left out the per-ordering crossed-hello tests and the test where an async `connect` races an inbound hello. Its PR body still says there's no wire-parity test, and I didn't check whether the fix rounds added the others.

**#1485 needs a weave before it can merge:** it's 203 commits behind `llm`, and a trial merge conflicts in 7 files:
- `packages/ocapn/src/client/index.js`
- `packages/ocapn/test/python-test-suite/index.js`
- `packages/thixotrope/src/daemon.js`, which `llm` has deleted and #1485 modifies, so this is likely the hardest
- `packages/thixotrope/test/_remote-process-tests.js`
- `packages/thixotrope/test/daemon.test.js`
- `packages/thixotrope/test/durable-netlayer.test.js`
- `packages/thixotrope/test/durable-sessions.test.js`

I didn't post the weave because the new head would need a fresh panel review, so it should wait for the maintainer's decision on the design.

**Messages sent**
- **Maintainer:** asked them to accept or reject #1480, then say "weave" for #1485 if accepted (`msg-ocapn-tcp-for-test-extraction-build-7a89118fcf85`). Retries after a slow journal push amended that one entry, so it shows occurrence #3 rather than duplicates.
- **`ocapn-network-transport-separation-build`:** told this running peer job about #1485 so it doesn't redo the work.

**Follow-ups**
- **Repeat postings:** this is the third build job for this design that has stopped without a new PR (2026-10-07, 2026-10-16, today). The likely cause is that the design file on `llm` still says "Not Started". Landing or rejecting #1480 should stop the repeats; until then, producers should skip this design.
- **Checkout timeout on this host:** `ensure-project-worktree.sh` failed again at the 120s git limit and needed `GARDEN_REPO_GIT_TIMEOUT=900`. The durable fix recorded in memory still hasn't been made.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ocapn-tcp-for-test-extraction-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (864287 cached reads)
- Output: 10993 tokens
- Cost: $1.0941014
- Wall-clock: 1607s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
