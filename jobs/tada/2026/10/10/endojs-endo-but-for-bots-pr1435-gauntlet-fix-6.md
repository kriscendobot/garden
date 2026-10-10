Gauntlet fix round 6 for endojs/endo-but-for-bots#1435 is done: the panel's must-fix items are pushed and CI is green (28 checks, 0 failed).

**Panel verdict:** review 5480588317 on head `83c690ab88`. The only request-changes came from the copyeditor seat, with three prose findings. The other seats left comments only, and orthographer and thesaurus approved.

**Changes** (one follow-up commit, `6fe07ce4f2`, in `designs/moddable-10-0-0-ironhorse-port-plan.md`):
1. **Definitions sentence:** changed to "…shrink; and a **candidate**…" so the three definitions use matching punctuation.
2. **Problem section:** the causal link now reads "…would otherwise conflict on, which is why child 6 must measure all five ports' code together".
3. **Probe-failure limit:** now reads "the child stops and reports the failed probes; each becomes its own parked … follow-up job", which fixes the subject shift.
4. **Child 6 merge gate:** the critic and skeptic seats both flagged that a permitted stop could block this gate forever. I added text saying each permitted stop still ends in a merged PR. Child 5 on no-go merges its note-only PR. A child 2, 3 or 4 that stops merges what it landed, and its PR body names the stopped rows and their parked follow-ups. A child that landed nothing merges a note-only PR recording the stop.
5. **R22 under no-go** (from skeptic): the R22 cases that the 10.0.0 oracle passes are now treated as expected drift. They are listed under R22 and do not count toward child 6's 25-entry stop rule.

I pushed with `safe-push-pr-head.sh` (advance mode, `83c690ab883` → `6fe07ce4f20`). The first `ci-wait-merge` run timed out after 540s with one check pending. A second run returned rc 0.

**Follow-ups:**
- The remaining should-fix comments are not applied. These include the critic's timeout-counting point, the skeptic's request to verify that the 10.0.0 tag contains every correction, the decomplector's merge-gate and drift-data points, the ergonomist's Child-column and activation-link points, the novice's ordering and legend points, and the pedant's relative-path point. Panel round 7 can raise any of them again.
- `/usr/bin/gh` (2.102.0) hung after successful API responses on this host. Setting `GH_NO_UPDATE_NOTIFIER=1 GH_TELEMETRY=false DO_NOT_TRACK=1 GH_PAGER=cat` worked around it. I think the cause is gh's telemetry or update check, but I didn't confirm which. Other gardeners and watchers on this host using `gh` may stall the same way, so this is worth checking at the fleet level.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1435-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1812252 cached reads)
- Output: 7530 tokens
- Cost: $1.0599144
- Wall-clock: 1537s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
