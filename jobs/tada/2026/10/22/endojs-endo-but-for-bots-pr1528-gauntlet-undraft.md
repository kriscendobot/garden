# Gauntlet UNDRAFT: endojs/endo-but-for-bots#1528 is now ready for review

PR #1528 is out of draft at the panel-passed head `b172883e4e1666b4e075f98cd04292cf65d996a8`. It is a 1-file design PR: "design(endor-bus-tui): phase breakdown sequenced after endor-tui Phase 1", base `llm-f02cd81`.

**Gate checks:**
- **Before the change:** state was OPEN, headRefOid matched the panel-passed head exactly, and the PR was still a draft. I then ran `gh pr ready`.
- **After the change:** `isDraft=false`, and headRefOid still equals the expected head.

**Advisory appellate pass (recorded only, does not block the un-draft).** A light `claude -p` review of the diff found design issues the panel may have missed:
- **Phase 3 exit vs. parallelism:** Phase 3's end-to-end exit criterion needs Phase 2, which contradicts the claim that Phases 2 and 3 can be built in parallel. The dependency graph also has no B2→B3 edge.
- **Phase 2 base:** Phase 2 builds on code from #1525, which is still in flight, so it is unclear how it can sit on a frozen `llm-<sha>` base.
- **No delta feed:** `TuiStore` only produces snapshots, but Phase 2 needs ordered deltas, including `window.removed` from the owner sweep. No phase is assigned to build that.
- **Memory caps:** the claim that worker output is bounded is overstated. Only scrollback line count is capped. Nothing caps payload, window or region counts, and `too-large` has no defined limit.
- **Canvas before rate limits:** canvas (`drawCells`) arrives in Phase 5, two phases before its rate limits in Phase 7.
- **Missing client→daemon verbs:**
  - There is no "close window" verb for the `user-closed` reason.
  - Input does not carry the region's owner.
  - Input-injection authority is listed as an open question but blocks Phase 4.
- **Unowned daemon side:** the daemon side of #1525's chat verbs (`inbox.follow` and kin) has no owner.
- **Stale text after renumbering:**
  - Phase 6 says "Unchanged from the earlier plan," but that text was deleted.
  - Some old phase numbers are still cited.
  - The claim that workers re-request windows after a daemon restart is doubtful.

**Follow-ups:** the advisory points need a fixer pass or a maintainer decision during review. Nothing was posted for them, because this stage does not gate on them. No garden-repo changes.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1528-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (174563 cached reads)
- Output: 1792 tokens
- Cost: $0.4188166
- Wall-clock: 59s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
