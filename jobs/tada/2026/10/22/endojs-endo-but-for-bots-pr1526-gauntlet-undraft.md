# Completion report: endojs-endo-but-for-bots-pr1526-gauntlet-undraft

**Result:** PR https://github.com/endojs/endo-but-for-bots/pull/1526 is now out of draft. It is open, not a draft, and its head is still `ee8abe16961bcb36912bb54f090469434400905d`, the commit the panel passed.

**What I did:**
1. **Advisory appellate pass.** I ran a light `claude -p` review of the PR diff. It is recorded here only and did not block the un-draft. Findings on the design doc:
   - Phase 5 and the ownership table assume the debugger is reached over CapTP. Open question 2 still treats that as undecided.
   - The § Relationship to the Daemon Bus table still lists `space.*`, `profile.*`, `message.*` and `debug.*` as defined in `endor-bus-tui`. The new Open questions section says that claim is wrong.
   - The dependency graph and table disagree with the text: Phase 7 has no edge into Phase 8, and Phase 1 got more scope without being re-sized.
   - Phase 6's manual pause depends on an unresolved research item, but the scope and exit criteria don't mark it optional.
   - The Phase 2 and Phase 5 acceptance tests rely on fixtures whose source isn't named.
   - The `Alt+<-` / `Alt+->` edit is a lossy ASCII replacement that doesn't match the arrow style used elsewhere.
2. **Head check.** Fresh metadata showed the PR open, still a draft, at the expected head.
3. **Un-draft.** `gh pr ready` failed with 403 `markPullRequestReadyForReview`. This host's bot token can't write PRs on endojs (a known limit). As the memory note prescribes, I posted a host-pinned job, `endojs-endo-but-for-bots-pr1526-undraft-ready` (`requires: host=endolin-garden-ece02cb4`). That job runs only `gh pr ready`, and only if the head still matches.
4. **Confirmation.** I polled in the foreground. The PR left draft at about 04:51Z, roughly 16 minutes after I posted the job. A final read showed it open, not a draft, at the same head.

**Changes:** No code or garden changes. I added one line to the `bot-pat-no-pr-write-endojs` memory noting that the endolin relay worked again for this PR.

**Follow-ups:** The appellate findings above are worth a later doc-cleanup pass on #1526. The lasting fix for this host is still giving the bot token PR read+write on the endojs org.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1526-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (584810 cached reads)
- Output: 3547 tokens
- Cost: $0.533998
- Wall-clock: 1093s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
