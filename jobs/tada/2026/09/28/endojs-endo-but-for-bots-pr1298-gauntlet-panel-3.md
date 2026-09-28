Gauntlet panel round 3 on endojs/endo-but-for-bots PR #1298 came back **must-fix**, and the verdict is posted on the PR.

**What ran**
- I checked out the PR head in an isolated worktree (`kriscendobot/endo-but-for-bots` @ `ironhorse-fuzz-findings`). It was at `a60453be79`, the same commit as the live PR head.
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the pinned base `387ea66146` (`llm-387ea66`). It exited 0 and printed `code-panel single-round — must-fix`.
- 31 seats reviewed: 17 approve, 10 comment-only, 4 request-changes (typist, breaker, wire-watcher, integrator). Every seat process exited cleanly.
- The phase/evidence pre-pass couldn't resolve the PR body or the governing design. The panel reports this as not fatal.

**What was found**
- The round-2 problem is fixed. Every place that compares Number results now checks against the spec spelling of the oracle's exact double, and that spelling comes from Ryu rather than IronHorse's own formatter.
- The must-fix items:
  - **String comparison fallback:** in `comparison.rs`, `results_agree` still compares values that are not Numbers by parsing both as decimals, which hides real mismatches. It should require byte-identical strings and drop `as_ecma_number`. The breaker and wire-watcher seats flagged this independently.
  - **Fixture hashes:** the `finding_*` bytecode fixtures cite an input sha256 that nothing checks.
  - **Copied generators:** 28 VM tests each paste their own copy of a fuzz generator.
  - **Stale docs:** some docs still describe `ironhorse-text` as CESU-8-only, and some test comments refer to "the standing findings branch".
  - **Commit grouping:** formatting commits and fix-then-correction pairs should be folded into the commits they fix.
  - **Characters:** `…`, `×` and `−` appear in Rust doc comments and should be plain ASCII.

**Posted verdict**
- Review 5335270628 is on head `a60453be79`, about 18 KB.
- It's a `--comment` review: the bot account wrote this PR, and GitHub won't let it request changes on its own PR. The body states that the must-fix disposition is the source of truth.
- The full aggregate is about 81 KB, over GitHub's review-body limit. So the review carries a summary, the must-fix list, the comment-only notes, and the four request-changes seat reviews in full; the other seats' reviews are left out.

**Other notes**
- The inbox couldn't be read because cloning the journal timed out (offline, rc=75), so any messages to this job went unread.
- I made no changes to the garden or the project.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1298-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (802109 cached reads)
- Output: 5963 tokens
- Cost: $0.7665938
- Wall-clock: 585s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
