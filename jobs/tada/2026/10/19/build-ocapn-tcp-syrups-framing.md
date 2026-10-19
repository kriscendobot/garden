I didn't open a PR, because this job duplicates work that is already done or already in review.

**What I found on `endojs/endo-but-for-bots` `llm` (at `330cf996c`):**
- **The code has already shipped.** The framing package exists as `@endo/syrup-frame` (`packages/syrup-frame/`, exporting `makeSyrupReader` and `makeSyrupWriter`) and `@endo/ocapn` depends on it. `packages/ocapn/src/netlayers/tcp-test-only.js` uses `framing: 'syrup'` by default: incoming bytes go through the reader so each call gets exactly one message, and outgoing writes get a length prefix. `framing: 'none'` is kept for the Python test suite. `packages/ocapn/test/netlayer-tcp-syrup.test.js` covers the round-trip, the no-comma rule and the chunk-boundary case. All of this came from #109. `designs/README.md` already lists the design as **Complete**.
- **Only the design doc's own header was out of date.** `designs/ocapn-tcp-syrup-framing.md` still says Status: Not Started, which is almost certainly why this job was posted ("M4, Not Started").
- **PR #1479 already fixes that header.** It's titled "docs(designs): mark ocapn-tcp-syrup-framing Complete and record what shipped", was opened 2026-10-16 against the pinned base `llm-61cd656`, and passed panel round 2 at head `f188f851c0` with CI green. Its gauntlet stopped with "maintainer action required", and the PR is already out of draft.
- **Related open PRs:** #242 moves the Python suite onto the framed wire (stopped on a floating base; kriskowal asked for a rebase). #741 is an older naming fix that the base branch has made redundant.

**What I did:**
- I wrote the same header reconciliation myself (commit `f4369a7ff` on a new head off the pinned `llm-330cf99`) before I found #1479.
- `ensure-pr.sh` couldn't open a PR because this host's PAT gets a 403 on endojs `createPullRequest`.
- My handoff job `endo-but-for-bots-ocapn-tcp-syrup-framing-open-pr` was refused: a completed job with the same name already exists, and that earlier job is what opened #1479.
- I deleted my pushed head branch `build/ocapn-tcp-syrup-framing-status` so no duplicate is left behind. Nothing else changed: no garden edits, no new PR, no new job.

**Follow-ups:**
- The maintainer needs to act on #1479 (merge it or give direction). Until it merges, the header still says "Not Started", so a roadmap scan may post this job again.
- #242 still needs its rebase onto the `syrup-frame` naming and a pinned base before its gauntlet can resume.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-tcp-syrups-framing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1537537 cached reads)
- Output: 10256 tokens
- Cost: $1.1703394
- Wall-clock: 398s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
